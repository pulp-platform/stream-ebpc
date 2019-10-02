# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


from common import bpc
from common.util import zero_pad_bitstr, split_str
from cocotb.binary import BinaryValue
from cocotb.utils import get_sim_time
import re
import numpy as np

class BPCEncoderScoreboard:

    def __init__(self, dut, block_size, data_w, stim_report_file = None, int_report_file = None, summary_file = None, max_mismatches=20):
        self.block_size = block_size
        self.data_w = data_w
        self.inputs = {'data': [], 'flush': []}
        self.input_blocks = {'data': [], 'flush': []}
        self.input_times = []
        self.outputs_act = []
        self.dbp_dbx_exp = {'base': [], 'dbp': [], 'dbx': []}
        self.dbp_dbx_act = {'base': [], 'dbp': [], 'dbx': []}
        self.output_times = []
        self.curr_output_exp_str = ''
        self.output_exp_str = ''
        self.outputs_exp = []
        self.mismatch_positions = {'base': [], 'dbp': [], 'dbx': [], 'output': []}
        self.mismatch_times = {'base': [], 'dbp': [], 'dbx': [], 'output': []}
        self.flush = 0
        self.inputs_good = {'data': [], 'flush': []}
        self.outputs_good = {'data': []}
        self.dut = dut
        self.curr_output = 0
        self.curr_block = 0
        self.curr_dbx_out = 0
        self.max_mismatches = max_mismatches
        self.silence_mismatch_warnings = False
        self.stim_report_file = stim_report_file
        self.int_report_file = int_report_file
        self.summary_file = summary_file
        self.last_block = False
        self.stop_clk_cnt = True
        self.clk_cnt = 0
        self.stall_cnt = {'in': 0, 'out': 0}

    def push_input(self, data):
        self.stop_clk_cnt = False
        if re.search('[x,X,z,Z]', data[0].binstr) is not None:
            self.inputs_good['data'].append(0)
        else:
            self.inputs_good['data'].append(1)
        if re.search('[x,X,z,Z]', data[1].binstr) is not None:
            self.inputs_good['flush'].append(0)
        else:
            self.inputs_good['flush'].append(1)
        self.inputs['data'].append(data[0])
        self.inputs['flush'].append(data[1])
        self.input_times.append(get_sim_time())

        if len(self.inputs['data']) == self.block_size:
            self.dut._log.info("Block {} has been fed".format(self.curr_block))
            block = [el.signed_integer for el in self.inputs['data']]
            block_flush = [el.integer for el in self.inputs['flush']]
            self.input_blocks['data'].append(block)
            self.input_blocks['flush'].append(block_flush)
            self.push_expresp(block, block_flush)
            self.inputs['data'], self.inputs['flush'] = [], []
            self.curr_block += 1

    def push_expresp(self, block, block_flush):
        base, dbp, dbx = bpc.DBX(np.array(block), self.data_w)
        self.dbp_dbx_exp['base'].append(base)
        self.dbp_dbx_exp['dbp'].append(dbp)
        self.dbp_dbx_exp['dbx'].append(dbx + [dbp[self.data_w]])
        out_str = bpc.BPC_block(np.array(block), wordwidth=self.data_w, variant='paper')
        self.curr_output_exp_str += out_str
        if any(block_flush):
            self.curr_output_exp_str = zero_pad_bitstr(self.curr_output_exp_str, self.data_w)
            # this is just a heuristic...
            self.last_block = True
        while len(self.curr_output_exp_str) >= self.data_w:
            self.output_exp_str += self.curr_output_exp_str[:self.data_w]
            self.outputs_exp.append(BinaryValue(n_bits=self.data_w, value=self.curr_output_exp_str[:self.data_w]))
            self.curr_output_exp_str = self.curr_output_exp_str[self.data_w:]

    def push_output(self, data):
        assert len(self.outputs_act) == self.curr_output, "Scoreboard: len(outputs_act) != curr_output - something is wrong!"
        if re.search('[x,X,z,Z]', data.binstr) is not None:
            self.outputs_good['data'].append(0)
        else:
            self.outputs_good['data'].append(1)
        self.outputs_act.append(data)
        t = get_sim_time()
        self.output_times.append(t)
        try:
            if self.outputs_exp[self.curr_output].integer != data.integer or self.outputs_good['data'][-1] != 1:
                if not self.silence_mismatch_warnings:
                    self.dut._log.warning("Output Mismatch! Expected: {}   Got: {}".format(self.outputs_exp[self.curr_output].binstr, data.binstr))
                self.mismatch_positions['output'].append(self.curr_output)
                self.mismatch_times['output'].append(t)
                if len(self.mismatch_positions['output']) == self.max_mismatches:
                    self.dut._log.warning("{} output Mismatches - silencing output".format(len(self.mismatch_positions['output'])))
                    self.silence_mismatch_warnings = True
        except IndexError:
            self.dut._log.warning("Trying to push output for which there is no ExpResp yet - skipped!")
            pass
        self.curr_output += 1
        if self.curr_output == len(self.outputs_exp) and self.last_block:
            self.stop_clk_cnt = True

    def push_dbx(self, dbx):
        # This is sorta broken because of race conditions...
        # This is completely broken because of architecture changes - do not use!
        self.dbp_dbx_act['base'].append(dbx.base.value.binstr)
        dbps = split_str(dbx.dbp.value.binstr, self.block_size-1)
        dbxs = split_str(dbx.dbx.value.binstr, self.block_size-1)
        helper_data = {'dbp': dbps, 'dbx': dbxs}
        for k in helper_data:
            self.dbp_dbx_act[k].append(helper_data[k])
        for dat in ['base', 'dbp', 'dbx']:
            if len(self.dbp_dbx_exp[dat]) <= self.curr_dbx_out:
                self.dut._log.warning("Trying to push {} for which there is no ExpResp yet at time {}!".format(dat, get_sim_time()))
            if self.dbp_dbx_act[dat][self.curr_dbx_out] != self.dbp_dbx_exp[dat][self.curr_dbx_out]:
                #if not self.silence_mismatch_warnings:
                    #self.dut._log.warning("{} Mismatch! Expected: {}   Got: {}".format(dat, self.dbp_dbx_exp[dat][self.curr_dbx_out], self.dbp_dbx_act[dat][self.curr_dbx_out]))
                self.mismatch_times[dat].append(get_sim_time())
                if dat == 'base':
                    self.mismatch_positions[dat].append(self.curr_dbx_out)
                else:
                    assert len(helper_data[dat]) == len(self.dbp_dbx_exp[dat][self.curr_dbx_out]), \
                        "The {}-th {} datum is not of the expected length: Is {}, expected{}".format(self.curr_dbx_out, dat, len(helper_data[dat]), len(self.dbp_dbx_exp[dat][self.curr_dbx_out]))
                    self.mismatch_positions[dat].append([k for k in range(len(helper_data[dat])) if helper_data[dat][k] != self.dbp_dbx_exp[dat][self.curr_dbx_out][k]])
                #if len(self.mismatch_positions[dat]) == self.max_mismatches:
                 #   self.silence_mismatch_warnings = True

        self.curr_dbx_out += 1

    def clk_incr(self):
        if not self.stop_clk_cnt:
            self.clk_cnt += 1

    def stall_incr(self, key):
        self.stall_cnt[key] += 1


    def report_stimuli(self, file):
        if file is None:
            self.dut._log.info("No stimuli report file given - skipping stimuli report")
        else:
            self.dut._log.info("Writing Stimuli Report to {}".format(file))
            with open(file, 'w') as fh:
                fh.write("------------STIMULI REPORT------------\n\n")
                for idx, block in enumerate(self.input_blocks['data']):
                    fh.write("BLOCK {}:\n".format(idx))
                    header = "{:^9}|".format('INT')+"{st:^{width}}|".format(st="BIN", width=self.data_w+4)+ "   FLUSH   "
                    fh.write(header+"\n")
                    fh.write("-"*len(header)+"\n")
                    for bidx, el in enumerate(block):
                        fh.write("{:>8} |".format(el)+"{binstr:>{width}} |".format(binstr=bpc.valuesToBinary(np.array([el]),self.data_w), width=self.data_w+3) + "     {}     \n".format(self.input_blocks['flush'][idx][bidx]))
                    fh.write("\n\n")
    def report_int_results(self, file):
        if file is None:
            self.dut._log.info("No intermediate results report file given - skipping intermediate results report")
        else:
            self.dut._log.info("Writing Intermediate Results Report to {}".format(file))
            with open(file, 'w') as fh:
                fh.write("------------INTERMEDIATE RESULTS REPORT------------\n\n")
                #TODO: finish intermediate results reporting


    def report(self):
        assert self.curr_output_exp_str == '', "Scoreboard has data left in curr_output_exp_str at report time - something is wrong! Did you forget to flush?"
        self.dut._log.info("Scoreboard: Fed {} inputs in {} blocks".format(len(self.input_times), len(self.input_blocks['data'])))
        self.dut._log.info("Scoreboard: Read {} outputs with {} mismatches - {} outputs were expected".format(len(self.output_times),
                                                                                                         len(self.mismatch_times['output']),
                                                                                                         len(self.outputs_exp)))
        self.dut._log.info("Scoreboard: Active for {} cycles, input stalled for {} cycles, output stalled for {} cycles".format(self.clk_cnt, self.stall_cnt['in'], self.stall_cnt['out']))
        self.dut._log.info("Scoreboard: {} words/cycle (1 word/cycle would be optimal)".format(len(self.input_times)/self.clk_cnt))
        self.report_stimuli(self.stim_report_file)
        r = (self.curr_output_exp_str != '') or (len(self.mismatch_positions['output']) != 0) or (not all(self.inputs_good['data']+self.inputs_good['flush']+self.outputs_good['data']))
        return r
