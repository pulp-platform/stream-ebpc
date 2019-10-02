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

class EBPCEncoderDriver:
    def __init__(self, dut, ta, tt):
        self.clk_i = dut.clk_i
        self.rst_ni = dut.rst_ni
        self.data_i = dut.data_i
        self.last_i = dut.last_i
        self.vld_i = dut.vld_i
        self.rdy_o = dut.rdy_o
        self.znz_data_o = dut.znz_data_o
        self.znz_vld_o = dut.znz_vld_o
        self.znz_rdy_i = dut.znz_rdy_i
        self.bpc_data_o = dut.bpc_data_o
        self.bpc_vld_o = dut.bpc_vld_o
        self.bpc_rdy_i = dut.bpc_rdy_i
        self.ta = ta
        self.tt = tt
        self.in_drv = HandshakeInputDriver(clk=self.clk_i, signals=[self.data_i, self.last_i], vld=self.vld_i, rdy=self.rdy_o, ta=self.ta, tt=self.tt)
        self.bpc_out_drv = HandshakeOutputDriver(clk=self.clk_i, vld=self.bpc_vld_o, rdy=self.bpc_rdy_i, ta=self.ta,  tt=self.tt)
        self.znz_out_drv = HandshakeOutputDriver(clk=self.clk_i, vld=self.znz_vld_o, rdy=self.znz_rdy_i, ta=self.ta,  tt=self.tt)
        self.apply_defaults()

    def apply_defaults(self):
        self.data_i <= 0
        self.last_i <= 0
        self.vld_i <= 0
        self.znz_rdy_i <= 0
        self.bpc_rdy_i <= 0

    @cocotb.coroutine
    def drive_input(self, values, tmin, tmax):
    # values: list of tuples (dat a, flush) to feed
    # tmin:   minimum # of clock cycles to wait between input applications
    # tmax:   maximum # of clock cycles to wait between applications
        assert self.rst_ni.value == 1, "BPCEncoderDriver Error: rst_ni is not high in drive_input!"
        for val in values:
            yield wait_cycles(self.clk_i, random.randint(tmin,tmax))
            yield self.in_drv.write_input(val)

    @cocotb.coroutine
    def read_znz_outputs(self, num, tmin, tmax):
        #num: how many output values to read
        #tmin: minimum # of clock cycles to wait between reads
        #tmax: maximum # of clock cycles to wait between reads
        assert self.rst_ni.value == 1, "BPCEncoderDriver Error: rst_ni is not high in read_outputs!"
        k = 0
        for i in range(num):
            yield wait_cycles(self.clk_i, random.randint(tmin, tmax))
            yield self.znz_out_drv.read_output()
            k+= 1
        return k

    @cocotb.coroutine
    def read_bpc_outputs(self, num, tmin, tmax):
        #num: how many output values to read
        #tmin: minimum # of clock cycles to wait between reads
        #tmax: maximum # of clock cycles to wait between reads
        assert self.rst_ni.value == 1, "BPCEncoderDriver Error: rst_ni is not high in read_outputs!"
        k = 0
        for i in range(num):
            yield wait_cycles(self.clk_i, random.randint(tmin, tmax))
            yield self.bpc_out_drv.read_output()
            k+= 1
        return k
