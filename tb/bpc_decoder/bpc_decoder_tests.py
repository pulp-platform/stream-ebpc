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
from cocotb.clock import Clock
from cocotb.result import TestFailure
from cocotb.triggers import Timer
from common.drivers import reset_dut, wait_cycles
from bpc_decoder_driver import BPCDecoderDriver
from common.util import int_list_to_binval_list, random_vals
from bpc_decoder_scoreboard import BPCDecoderScoreboard
from bpc_decoder_monitor import BPCDecoderMonitor
import random
import numpy as np


#import pydevd_pycharm
#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True, stderrToServer=True)

random.seed(89)
np.random.seed(29)

BLOCK_SIZE = 8
DATA_W = 8
NUM_BLOCKS_W = 14
NUM_BLOCKS = 2000
CLOCK_PERIOD = 2500
RESET_TIME = 15000
TA = 200
TT = 2000

STIM_REPORT_FILE = '../reports/stimuli.log'
STIM_DBG_FILE =  '../reports/stim_dbg.log'

@cocotb.test()
def basic_bringup(dut):
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield Timer(10000)

@cocotb.test()
def random_inputs_only(dut):
    num_blocks = 200
    drv = BPCDecoderDriver(dut, TA, TT)
    vals = random_vals(num_blocks*BLOCK_SIZE, DATA_W)
    vals = int_list_to_binval_list(vals, DATA_W, True)
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield wait_cycles(dut.clk_i, 4)
    cocotb.fork(drv.read_outputs(1000000, 0, 5))
    yield drv.drive_input(vals, 0, 5)
    yield Timer(10000)
    dut._log.info("The assertion errors are bound to happen, as the inputs do not amount to a sensible encoding! No worries here :^)")

@cocotb.test()
def random_blocks(dut):
    drv = BPCDecoderDriver(dut, TA, TT)
    sb = BPCDecoderScoreboard(dut, BLOCK_SIZE, DATA_W, NUM_BLOCKS, STIM_REPORT_FILE, STIM_DBG_FILE)
    mon = BPCDecoderMonitor(dut, sb)
    encoded_vals = sb.gen_rand_stimuli()
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield wait_cycles(dut.clk_i, 4)
    cocotb.fork(drv.drive_input(encoded_vals, 0, 5))
    mon.start()
    yield drv.read_outputs(NUM_BLOCKS * BLOCK_SIZE, 0, 5)
    yield Timer(1000)
    yield wait_cycles(dut.clk_i, 1)
    drv.clear()
    mon.stop()
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")
