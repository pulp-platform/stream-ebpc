# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


import cocotb
from cocotb.triggers import Timer, RisingEdge

class EBPCEncoderMonitor:
    def __init__(self, dut, scoreboard, ta, tt):
        self.clk = dut.clk_i
        self.rst_n = dut.rst_ni
        self.last_i = dut.last_i
        self.vld_i = dut.vld_i
        self.rdy_o = dut.rdy_o
        self.idle_o = dut.idle_o
        self.scoreboard = scoreboard
        self.znz_data_o = dut.znz_data_o
        self.znz_vld_o = dut.znz_vld_o
        self.znz_rdy_i = dut.znz_rdy_i
        self.bpc_data_o = dut.bpc_data_o
        self.bpc_vld_o = dut.bpc_vld_o
        self.bpc_rdy_i = dut.bpc_rdy_i
        self.bpc_in_data = dut.data_to_bpc
        self.bpc_in_vld = dut.vld_to_bpc
        self.bpc_in_rdy = dut.rdy_from_bpc
        self.znz_in_data = dut.is_one_to_znz
        self.znz_in_vld = dut.vld_to_znz
        self.znz_in_rdy = dut.rdy_from_znz
        self.ta = ta
        self.tt = tt
        self.bpc_listening_task = None
        self.znz_listening_task = None
        self.bpc_in_listening_task = None
        self.znz_in_listening_task = None


    @cocotb.coroutine
    def clk_listener(self):
        while True:
            yield RisingEdge(self.clk)
            self.scoreboard.incr_clk_cnt()

    # this is just to detect stalls
    @cocotb.coroutine
    def in_listener(self):
        while True:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            if self.vld_i.value and not self.rdy_o.value:
                self.scoreboard.incr_stall_cnt['in']

    @cocotb.coroutine
    def bpc_in_listener(self):
        while True:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            if self.bpc_in_vld.value and self.bpc_in_rdy.value:
                self.scoreboard.push_int_input('bpc', self.bpc_in_data.value)

    @cocotb.coroutine
    def znz_in_listener(self):
        while True:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            if self.znz_in_vld.value and self.znz_in_rdy.value:
                self.scoreboard.push_int_input('znz', self.znz_in_data.value)

    @cocotb.coroutine
    def znz_listener(self):
        while True:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            if self.znz_vld_o.value and self.znz_rdy_i.value:
                self.scoreboard.push_output('znz', self.znz_data_o.value)
            elif self.znz_vld_o.value and not self.znz_rdy_i.value:
                self.scoreboard.incr_stall_cnt('znz')

    @cocotb.coroutine
    def bpc_listener(self):
        while True:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            if self.bpc_vld_o.value == 1 and self.bpc_rdy_i.value == 1:
                self.scoreboard.push_output('bpc', self.bpc_data_o.value)
            elif self.bpc_vld_o.value and not self.bpc_rdy_i.value:
                self.scoreboard.incr_stall_cnt('bpc')

    @cocotb.coroutine
    def wait_done(self):
        yield RisingEdge(self.idle_o)

    def start(self):
        self.bpc_listening_task = cocotb.fork(self.bpc_listener())
        self.znz_listening_task = cocotb.fork(self.znz_listener())
        self.bpc_in_listening_task = cocotb.fork(self.bpc_in_listener())
        self.znz_in_listening_task = cocotb.fork(self.znz_in_listener())
        self.clk_listening_task = cocotb.fork(self.clk_listener())

    def stop(self):
        if self.bpc_listening_task is not None and self.znz_listening_task is not None and self.bpc_in_listening_task is not None and self.znz_in_listening_task is not None and self.clk_listening_task is not None:
            self.bpc_listening_task.kill()
            self.znz_listening_task.kill()
            self.clk_listening_task.kill()
            self.bpc_in_listening_task.kill()
            self.znz_in_listening_task.kill()
        else:
            assert(False), "Tried to stop non-running listening task!"

