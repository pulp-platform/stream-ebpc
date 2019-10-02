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

class BPCEncoderMonitor:
    def __init__(self, dut, block_size, data_w, scoreboard):
        self.clk = dut.clk_i
        self.rst_n = dut.rst_ni
        self.di = dut.data_i
        self.flush = dut.flush_i
        self.vld_i = dut.vld_i
        self.rdy_o = dut.rdy_o
        self.do = dut.data_o
        self.vld_o = dut.vld_o
        self.rdy_i = dut.rdy_i
        self.dbx_vld = dut.seq_coder_i.vld_from_slice
        self.dbx_rdy = dut.seq_coder_i.rdy_to_slice
        self.dbx_d = dut.seq_coder_i.compressor_i.dbx
        self.data_w = data_w
        self.in_listening_task = None
        self.out_listening_task = None
        self.clk_listening_task = None
        self.scoreboard = scoreboard

    @cocotb.coroutine
    def clk_listener(self):
        while True:
            yield RisingEdge(self.clk)
            self.scoreboard.clk_incr()

    @cocotb.coroutine
    def input_listener(self):
        while True:
            yield RisingEdge(self.clk)
            if self.vld_i.value == 1 and self.rdy_o.value == 1:
                self.scoreboard.push_input((self.di.value, self.flush.value))
            elif self.vld_i.value == 1 and self.rdy_o.value == 0:
                self.scoreboard.stall_incr('in')

    @cocotb.coroutine
    def output_listener(self):
        while True:
            yield RisingEdge(self.clk)
            if self.vld_o.value == 1 and self.rdy_i.value == 1:
                self.scoreboard.push_output(self.do.value)
            elif self.vld_o.value == 1 and self.rdy_i.value == 0:
                self.scoreboard.stall_incr('out')

    def start(self):
        assert self.in_listening_task is None, "BMCEncoderMonitor.start() was probably called twice - in_listening_task is not None!"
        self.in_listening_task = cocotb.fork(self.input_listener())
        assert self.out_listening_task is None, "BMCEncoderMonitor.start() was probably called twice - out_listening_task is not None!"
        self.out_listening_task = cocotb.fork(self.output_listener())
        self.clk_listening_task = cocotb.fork(self.clk_listener())

    def stop(self):
        assert self.in_listening_task is not None and self.out_listening_task is not None, "Tried to stop a non-running BPCEncoderMonitor!"
        self.in_listening_task.kill()
        self.in_listening_task = None
        self.out_listening_task.kill()
        self.out_listening_task = None
        self.clk_listening_task.kill()
        self.clk_listening_task = None
