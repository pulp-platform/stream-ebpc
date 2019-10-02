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
from cocotb.triggers import RisingEdge

class EBPCDecoderMonitor:
    def __init__(self, dut, scoreboard):
        self.dut = dut
        self.clk = dut.clk_i
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
        self.scoreboard = scoreboard
        self.clk_listening_task = None
        self.bpc_listening_task = None
        self.znz_listening_task = None
        self.out_listening_task = None



    @cocotb.coroutine
    def clk_listener(self):
        while True:
            yield RisingEdge(self.clk)
            self.scoreboard.clk_incr()

    @cocotb.coroutine
    def bpc_listener(self):
        while True:
            yield RisingEdge(self.clk)
            # we want to count stalls caused by TB
            if self.bpc_vld_i.value == 0 and self.bpc_rdy_o.value == 1:
                self.scoreboard.stall_incr('bpc')

    @cocotb.coroutine
    def znz_listener(self):
        while True:
            yield RisingEdge(self.clk)
            if self.znz_vld_i.value == 0 and self.znz_rdy_o.value == 1:
                self.scoreboard.stall_incr('znz')

    @cocotb.coroutine
    def output_listener(self):
        while True:
            yield RisingEdge(self.clk)
            if self.vld_o.value == 1 and self.rdy_i.value == 1:
                self.scoreboard.push_output(self.data_o.value)
            elif self.vld_o.value == 1 and self.rdy_i.value == 0:
                self.scoreboard.stall_incr('out')

    def start(self):
        assert self.bpc_listening_task is None, "BPCDecoderMonitor.start() was probably called twice - bpc_listening_task is not None!"
        self.bpc_listening_task = cocotb.fork(self.bpc_listener())
        assert self.znz_listening_task is None, "BPCDecoderMonitor.start() was probably called twice - znz_listening_task is not None!"
        self.znz_listening_task = cocotb.fork(self.bpc_listener())
        assert self.out_listening_task is None, "BPCDecoderMonitor.start() was probably called twice - out_listening_task is not None!"
        self.out_listening_task = cocotb.fork(self.output_listener())
        assert self.clk_listening_task is None, "BPCDecoderMonitor.start() was probably called twice - clk_listening_task is not None!"
        self.clk_listening_task = cocotb.fork(self.clk_listener())

    def stop(self):
        assert self.bpc_listening_task is not None and self.znz_listening_task is not None and self.out_listening_task is not None and self.clk_listening_task is not None, "Tried to stop a non-running BPCEncoderMonitor!"
        self.bpc_listening_task.kill()
        self.bpc_listening_task = None
        self.znz_listening_task.kill()
        self.znz_listening_task = None
        self.out_listening_task.kill()
        self.out_listening_task = None
        self.clk_listening_task.kill()
        self.clk_listening_task = None
