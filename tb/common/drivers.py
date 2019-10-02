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
import numpy as np
import random
@cocotb.coroutine
def apply_signal(signal, value, ta):
    yield Timer(ta)
    signal <= value

@cocotb.coroutine
def apply_signals(signals, values, ta):
    yield Timer(ta)
    for sig, val in zip(signals, values):
        sig <= val

@cocotb.coroutine
def wait_cycles(clk, c):
        for k in range(c):
            yield RisingEdge(clk)


@cocotb.coroutine
def reset_dut(rst_line, duration, units="ps"):
    rst_line <= 0
    yield Timer(duration, units=units)
    rst_line <= 1
    rst_line._log.debug("Reset complete")

class HandshakeInputDriver:
    def __init__(self, clk, signals, vld, rdy, ta, tt):
        assert(ta <= tt)
        if isinstance(signals, tuple):
            signals = list(signals)
        if not isinstance(signals, list):
            signals = [signals]
        self.clk = clk
        self.signals = signals
        self.vld = vld
        self.rdy = rdy
        self.ta = ta
        self.tt = tt

    @cocotb.coroutine
    def write_input(self, values):
        t = 0
        if isinstance(values, tuple):
            values = list(values)
        if not isinstance(values, list):
            values = [values]
        cocotb.fork(apply_signals(self.signals + [self.vld], values + [1], self.ta))
        yield Timer(self.tt)
        while self.rdy.value != 1:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
            t += 1
        yield RisingEdge(self.clk)
        cocotb.fork(apply_signal(self.vld, 0, self.ta))
        return t

class HandshakeOutputDriver:
    def __init__(self, clk, vld, rdy, ta, tt):
        assert(ta <= tt)
        self.clk = clk
        self.vld = vld
        self.rdy = rdy
        self.ta = ta
        self.tt = tt

    @cocotb.coroutine
    def read_output(self):
        cocotb.fork(apply_signal(self.rdy, 1, self.ta))
        yield Timer(self.tt)
        while self.vld.value != 1:
            yield RisingEdge(self.clk)
            yield Timer(self.tt)
        yield RisingEdge(self.clk)
        cocotb.fork(apply_signal(self.rdy, 0, self.ta))
