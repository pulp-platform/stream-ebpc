# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


import numpy as np

from common.util import random_vals, int_list_to_binval_list
from common import bpc



class BPCDecoderScoreboard:
    def __init__(self, dut, block_size, data_w, num_blocks, stim_report_file=None, stim_dbg_file=None):
        self.dut = dut
        self.block_size = block_size
        self.data_w = data_w
        self.inputs = []
        self.outputs_exp = []
        self.outputs_act = []
        self.stalls = {'num_blocks':0, 'in':0, 'out':0}
        self.cycle_cnt = 0
        self.mismatches = 0
        self.curr_output = 0
        self.num_blocks = num_blocks
        self.stim_report_file = stim_report_file
        self.stim_dbg_file = stim_dbg_file
        self.curr_block = 1

    def clk_incr(self):
        self.cycle_cnt  += 1

    def stall_incr(self, key):
        self.stalls[key] += 1

    def gen_rand_stimuli(self):
        vals = random_vals(self.num_blocks*self.block_size, self.data_w)
        self.outputs_exp = int_list_to_binval_list(vals, self.data_w, True)
        vals = bpc.BPC_words(np.array(vals), block_size=self.block_size, variant='paper', word_w=self.data_w, dbg_fn=self.stim_dbg_file)
        self.inputs = int_list_to_binval_list(vals, self.data_w, True)
        self.report_stim(self.stim_report_file)
        return self.inputs

    def push_output(self, val):
        self.outputs_act.append(val.binstr)
        try:
            if val.binstr != self.outputs_exp[self.curr_output].binstr:
                self.mismatches += 1
                self.dut._log.warning("Output mismatch in block {}, word {}! Expected: {} Got: {}".format(self.curr_block, self.curr_output % self.block_size, self.outputs_exp[self.curr_output], val.binstr))
        except IndexError:
            print("Warning: Tried to push output for which there is no expected value! Ignored")
        self.curr_output += 1
        if (self.curr_output % self.block_size == 0):
            self.curr_block += 1

    def report(self):
        self.dut._log.info("Scoreboard: Fed {} inputs".format(len(self.inputs)))
        self.dut._log.info("Scoreboard: Read {} outputs with {} mismatches - {} outputs were expected".format(len(self.outputs_act), self.mismatches, len(self.outputs_exp)))
        self.dut._log.info("Scoreboard: Took {} cycles, input was stalled for {} cycles, output was stalled for {} cycles".format(self.cycle_cnt, self.stalls['in'], self.stalls['out']))
        if (self.mismatches==0):
            self.dut._log.info("Scoreboard: GREAT SUCCESS! WE THE BEST!")
        r = self.mismatches > 0
        return r

    def report_stim(self, fn):
        if fn is not None:
            with open(fn, "w+") as fh:
                fh.write("BPC DECODER STIMULI REPORT\n\n")
                fh.write("Number of blocks: {}\n".format(self.num_blocks))
                fh.write("Words per block: {}\n".format(self.block_size))
                fh.write("Word Width: {}\n\n".format(self.data_w))
                for b in range(len(self.inputs)):
                    fh.write("{}     /     {}\n".format(self.inputs[b].binstr, self.inputs[b].value))
