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
from common.drivers import HandshakeInputDriver, HandshakeOutputDriver, wait_cycles, apply_signal

class BPCDecoderDriver:
    def __init__(self, dut, ta, tt):
        self.clk_i = dut.clk_i
        self.rst_ni = dut.rst_ni
        self.bpc_i = dut.bpc_i
        self.bpc_vld_i = dut.bpc_vld_i
        self.bpc_rdy_o = dut.bpc_rdy_o
        self.data_o = dut.data_o
        self.vld_o = dut.vld_o
        self.rdy_i = dut.rdy_i
        self.clr_i = dut.clr_i
        self.dut = dut
        self.ta = ta
        self.tt = tt
        self.bpc_i_drv = HandshakeInputDriver(clk=self.clk_i, signals=[self.bpc_i], vld=self.bpc_vld_i, rdy=self.bpc_rdy_o, ta=self.ta, tt=self.tt)
        self.out_drv = HandshakeOutputDriver(clk=self.clk_i, vld=self.vld_o, rdy=self.rdy_i, ta=self.ta, tt=self.tt)
        self.apply_defaults()

    def apply_defaults(self):
        self.bpc_i <= 0
        self.bpc_vld_i <= 0
        self.rdy_i <= 0
        self.clr_i <= 0


    @cocotb.coroutine
    def drive_input(self, values, tmin, tmax):
        # values: list of values to feed
        # tmin:   minimum # of clock cycles to wait between input applications
        # tmax:   maximum # of clock cycles to wait between applications
        assert self.rst_ni.value == 1, "BPCDecoderDriver Error: rst_ni is not high in drive_input!"
        for val in values:
            yield wait_cycles(self.clk_i, random.randint(tmin,tmax))
            yield self.bpc_i_drv.write_input(val)

    @cocotb.coroutine
    def read_outputs(self, num, tmin, tmax):
    #num: how many output values to read
    #tmin: minimum # of clock cycles to wait between reads
    #tmax: maximum # of clock cycles to wait between reads
        assert self.rst_ni.value == 1, "BPCEncoderDriver Error: rst_ni is not high in read_outputs!"
        k = 0
        for i in range(num):
            yield wait_cycles(self.clk_i, random.randint(tmin, tmax))
            yield self.out_drv.read_output()
            k+= 1
        return k

    @cocotb.coroutine
    def clear(self):
        yield apply_signal(dut.clr_i, 1, TA)
        yield wait_cycles(dut.clk_i, 1)
        yield apply_signal(dut.clr_i, 0, TA)
