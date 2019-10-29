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
from common.util import *
from common import data
import torch
import numpy as np
import random
import math

class EBPCEncoderScoreboard:

    def __init__(self, dut, block_size, data_w, max_zrle_len):
        self.dut = dut
        self.block_size = block_size
        self.data_w = data_w
        self.inputs = {'data': [], 'last': []}
        self.outputs_exp = {'znz': [], 'bpc': []}
        self.outputs_act = {'znz': [], 'bpc': []}
        self.mismatches = {'znz': 0, 'bpc': 0, 'znz_in': 0, 'bpc_in': 0}
        self.internal_inputs_exp = {'znz': [], 'bpc': []}
        self.internal_inputs_act = {'znz': [], 'bpc': []}
        self.curr_internal_input = {'znz': 0, 'bpc': 0}
        self.clk_cnt = 0
        self.stall_cnt = {'in': 0, 'bpc': 0, 'znz': 0}
        self.max_zrle_len = max_zrle_len
        self.curr_output = {'bpc': 0, 'znz': 0}

 
    def gen_rand_stimuli(self, n_inputs, max_zero_block, p_zero):
        # generate random stimuli and return them as a list of (data_i, last_i) tuples
        data_in = []
        last_in = []
        znz_stream = []
        nz_data = []
        i = 0
        while i < n_inputs:
            if (np.random.binomial(1, p_zero)):
                zero_len = min(random.randint(1, max_zero_block), n_inputs-i)
                znz_stream += [0] * zero_len
                i += zero_len
                data_in += [0]*zero_len
            else:
                znz_stream.append(1)
                dat = get_random_nonzero_in_range(-2**(self.data_w-1), 2**(self.data_w-1)-1)
                nz_data.append(dat)
                data_in.append(dat)
                i += 1
        last_in += ([0]*(len(data_in)-1)+[1])
        nz_data = zero_pad_list(nz_data, self.block_size)
        self.internal_inputs_exp['bpc'] += int_list_to_binval_list(nz_data, n_bits=self.data_w, signed=True)
        self.internal_inputs_exp['znz'] += int_list_to_binval_list(znz_stream, n_bits=1, signed=False)
        self.outputs_exp['bpc'] = bpc.BPC_words(np.array(nz_data), self.block_size, variant='paper', word_w=self.data_w)
        self.outputs_exp['znz'] = bpc.ZRLE_words(data_in, max_burst_len=self.max_zrle_len, wordwidth=self.data_w)
        self.inputs['data'] = int_list_to_binval_list(data_in, n_bits=self.data_w, signed=True)
        self.inputs['last'] = int_list_to_binval_list(last_in, n_bits=1, signed=False)

        # very pythonic.
        return list(zip(*self.inputs.values()))

    def gen_fmap_stimuli(self, model, dataset_path, num_batches, batch_size, signed=True, fmap_frac=0.01):
        assert self.data_w in [8, 16, 32]
        fms_q = data.getFMStimuli(model=model, dataset_path=dataset_path, data_w=self.data_w, num_batches=num_batches, batch_size=batch_size, signed=signed, fmap_frac=fmap_frac)
        nz_data = [el for el in fms_q if el != 0]
        nz_data = zero_pad_list(nz_data, self.block_size)
        znz_stream = [0 if el==0 else 1 for el in fms_q]
        last_in = ([0]*(len(fms_q)-1)+[1])
        self.inputs['data'] = int_list_to_binval_list(fms_q, self.data_w, signed=signed)
        self.inputs['last'] = int_list_to_binval_list(last_in, n_bits=1, signed=False)
        self.internal_inputs_exp['bpc'] += int_list_to_binval_list(nz_data, n_bits=self.data_w, signed=True)
        self.internal_inputs_exp['znz'] += int_list_to_binval_list(znz_stream, n_bits=1, signed=False)
        self.outputs_exp['bpc'] = bpc.BPC_words(np.array(nz_data),self.block_size,variant='paper',word_w=self.data_w)
        self.outputs_exp['znz'] = bpc.ZRLE_words(fms_q, max_burst_len=self.max_zrle_len, wordwidth=self.data_w)
        return list(zip(*self.inputs.values())), len(self.outputs_exp['bpc']), len(self.outputs_exp['znz'])

    def incr_clk_cnt(self):
        self.clk_cnt += 1;

    def incr_stall_cnt(self, key):
        self.stall_cnt[key] += 1

    def push_int_input(self, key, in_act):
        self.internal_inputs_act[key].append(in_act)
        if in_act.binstr != self.internal_inputs_exp[key][self.curr_internal_input[key]].binstr:
            self.mismatches[key+'_in'] += 1
            self.dut._log.warning("{} input mismatch! Expected: {}   Got: {}".format(key, self.internal_inputs_exp[key][self.curr_internal_input[key]], in_act.binstr))
        self.curr_internal_input[key] += 1

    def push_output(self, key, out_act):
        self.outputs_act[key].append(out_act.binstr)
        if out_act.binstr != self.outputs_exp[key][self.curr_output[key]]:
            self.mismatches[key] += 1
            self.dut._log.warning("{} mismatch! Expected: {}   Got: {}".format(key, self.outputs_exp[key][self.curr_output[key]], out_act.binstr))
        self.curr_output[key] += 1

    def report(self):
        self.dut._log.info("Scoreboard: Fed {} inputs in {} cycles - input was stalled for {} cycles, bpc output was stalled for {} cycles and znz output was stalled for {} cycles. Throughput: {} words/cycle".format(len(self.inputs['last']), self.clk_cnt, self.stall_cnt['in'], self.stall_cnt['bpc'], self.stall_cnt['znz'], len(self.inputs['data'])/self.clk_cnt))
        for k in ['znz', 'bpc']:
            self.dut._log.info("Scoreboard: Read {} {} outputs with {} mismatches - {} such outputs were expected".format(len(self.outputs_act[k]), k, self.mismatches[k], len(self.outputs_exp[k])))
        
        r = any(self.mismatches.values())
        return r
