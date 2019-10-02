# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


import random
import cocotb
from common.drivers import HandshakeInputDriver, HandshakeOutputDriver, wait_cycles

class EBPCDecoderDriver:
    def __init__(self, dut, ta, tt):
        self.clk_i = dut.clk_i
        self.rst_ni = dut.rst_ni
        self.bpc_i = dut.bpc_i
        self.bpc_vld_i = dut.bpc_vld_i
        self.bpc_rdy_o = dut.bpc_rdy_o
        self.znz_i = dut.znz_i
        self.znz_vld_i = dut.znz_vld_i
        self.znz_rdy_o = dut.znz_rdy_o
        self.data_o = dut.data_o
        self.last_o = dut.last_o
        self.vld_o = dut.vld_o
        self.rdy_i = dut.rdy_i
        self.num_words_i = dut.num_words_i
        self.num_words_vld_i = dut.num_words_vld_i
        self.num_words_rdy_o = dut.num_words_rdy_o
        self.dut = dut
        self.ta = ta
        self.tt = tt
        self.bpc_i_drv = HandshakeInputDriver(clk=self.clk_i, signals=[self.bpc_i], vld=self.bpc_vld_i,
                                              rdy=self.bpc_rdy_o, ta=self.ta, tt=self.tt)
        self.num_words_drv = HandshakeInputDriver(clk=self.clk_i, signals=[self.num_words_i], vld=self.num_words_vld_i,
                                              rdy=self.num_words_rdy_o, ta=self.ta, tt=self.tt)
        self.znz_i_drv = HandshakeInputDriver(clk=self.clk_i, signals=[self.znz_i], vld=self.znz_vld_i, rdy=self.znz_rdy_o, ta=self.ta, tt=self.tt)
        self.out_drv = HandshakeOutputDriver(clk=self.clk_i, vld=self.vld_o, rdy=self.rdy_i, ta=self.ta, tt=self.tt)

    def apply_defaults(self):
        self.bpc_i <= 0
        self.bpc_vld_i <= 0
        self.znz_i <= 0
        self.znz_vld_i <= 0
        self.num_words_i <= 0
        self.num_words_vld_i <= 0
        self.rdy_i <= 0

    @cocotb.coroutine
    def drive_bpc(self, values, tmin, tmax):
        # values: list of values to feed
        # tmin:   minimum # of clock cycles to wait between input applications
        # tmax:   maximum # of clock cycles to wait between applications
        assert self.rst_ni.value == 1, "BPCDecoderDriver Error: rst_ni is not high in drive_bpc!"
        for val in values:
            yield wait_cycles(self.clk_i, random.randint(tmin,tmax))
            yield self.bpc_i_drv.write_input(val)

    @cocotb.coroutine
    def drive_znz(self, values, tmin, tmax):
        # values: list of values to feed
        # tmin:   minimum # of clock cycles to wait between input applications
        # tmax:   maximum # of clock cycles to wait between applications
        assert self.rst_ni.value == 1, "BPCDecoderDriver Error: rst_ni is not high in drive_znz!"
        for val in values:
            yield wait_cycles(self.clk_i, random.randint(tmin,tmax))
            yield self.znz_i_drv.write_input(val)

    @cocotb.coroutine
    def write_num_words(self, n, tmin, tmax):
        # values: list of values to feed
        # tmin:   minimum # of clock cycles to wait between input applications
        # tmax:   maximum # of clock cycles to wait between applications
        assert self.rst_ni.value == 1, "BPCDecoderDriver Error: rst_ni is not high in write_num_words!"
        yield wait_cycles(self.clk_i, random.randint(tmin,tmax))
        yield self.num_words_drv.write_input(n)

    @cocotb.coroutine
    def read_outputs(self, num, tmin, tmax):
    #num: max number of output values to read
    #tmin: minimum # of clock cycles to wait between reads
    #tmax: maximum # of clock cycles to wait between reads
        assert self.rst_ni.value == 1, "BPCEncoderDriver Error: rst_ni is not high in read_outputs!"
        k = 0
        for i in range(num):
            yield wait_cycles(self.clk_i, random.randint(tmin, tmax))
            yield self.out_drv.read_output()
            k+= 1
            if self.dut.last_o.value == 1:
                return k
        return k
