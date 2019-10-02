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
from common.bpc import valuesToBinary

from common.util import zero_pad_bitstr, zero_pad_list, split_str, int_list_to_binval_list, get_random_nonzero_in_range
import numpy as np
import random
import math


class EBPCDecoderScoreboard:
    def __init__(self, dut, block_size, data_w, max_zrle_len):
        self.dut = dut
        self.block_size = block_size
        self.data_w = data_w
        self.inputs = {'bpc':[], 'znz':[]}
        self.outputs_exp = []
        self.outputs_act = []
        self.mismatches = 0
        self.cycle_cnt = 0
        self.stalls = {'bpc': 0, 'znz': 0, 'out': 0}
        self.max_zrle_len = max_zrle_len
        self.curr_output = 0

    def clk_incr(self):
        self.cycle_cnt  += 1

    def stall_incr(self, key):
        self.stalls[key] += 1

    def gen_rand_stimuli(self, n_inputs, max_zero_block, p_zero):
        # generate random stimuli and return them as a list of (data_i, last_i) tuples
        data_decoded = []
        znz_stream = []
        nz_data = []
        i = 0
        while i < n_inputs:
            if (np.random.binomial(1, p_zero)):
                zero_len = min(random.randint(1, max_zero_block), n_inputs-i)
                znz_stream += [0] * zero_len
                i += zero_len
                data_decoded += [0]*zero_len
            else:
                znz_stream.append(1)
                dat = get_random_nonzero_in_range(-2**(self.data_w-1), 2**(self.data_w-1)-1)
                nz_data.append(dat)
                data_decoded.append(dat)
                i += 1
        nz_data = zero_pad_list(nz_data, self.block_size)
        self.inputs['bpc'] = bpc.BPC_words(np.array(nz_data),self.block_size,variant='paper',word_w=self.data_w)
        # ZRLE
        bw_zrle = math.ceil(math.log2(self.max_zrle_len))
        zero_run = 0
        enc_znz_stream = ''
        for el in znz_stream:
            if el == 0:
                if zero_run == self.max_zrle_len-1:
                    enc_znz_stream += '0' + bin(self.max_zrle_len-1)[2:].zfill(bw_zrle)
                    zero_run = 0
                else:
                    zero_run += 1
            else:
                if zero_run != 0:
                    enc_znz_stream += ('0' + bin(zero_run-1)[2:].zfill(bw_zrle))
                    zero_run = 0
                enc_znz_stream += '1'
        # catch any remaining zero run
        if zero_run != 0:
            enc_znz_stream += ('0' + bin(zero_run-1)[2:].zfill(bw_zrle))
        # pad to wordwidth
        enc_znz_stream = zero_pad_bitstr(enc_znz_stream, self.data_w)
        self.inputs['znz'] = split_str(enc_znz_stream, self.data_w)
        data_decoded_bin = valuesToBinary(np.array(data_decoded), wordwidth=self.data_w)
        self.outputs_exp += split_str(data_decoded_bin, self.data_w)

        # very pythonic.
        return int_list_to_binval_list(self.inputs['bpc'], self.data_w, True), int_list_to_binval_list(self.inputs['znz'], self.data_w, True)

    def push_output(self, out_act):
        self.outputs_act.append(out_act.binstr)
        try:
            if out_act.binstr != self.outputs_exp[self.curr_output]:
                self.mismatches += 1
                self.dut._log.warning("Output mismatch! Expected: {}   Got: {}".format(self.outputs_exp[self.curr_output], out_act.binstr))
        except IndexError:
            print("Warning: Tried to push output for which there is no expected value! Ignored")
        self.curr_output += 1

    def report(self):
        self.dut._log.info("Scoreboard: Fed {} bpc, {} znz inputs".format(len(self.inputs['bpc']), len(self.inputs['znz'])))
        self.dut._log.info("Scoreboard: Read {} outputs with {} mismatches - {} such outputs were expected".format(len(self.outputs_act), self.mismatches, len(self.outputs_exp)))
        self.dut._log.info("Scoreboard: Took {} cycles, bpc/znz inputs were stalled for {}/{} cycles respectively, output was stalled for {} cycles".format(self.cycle_cnt, self.stalls['bpc'], self.stalls['znz'], self.stalls['out']))
        if (self.mismatches==0):
            self.dut._log.info("Scoreboard: GREAT SUCCESS! WE THE BEST!")
        r = self.mismatches > 0
        return r
