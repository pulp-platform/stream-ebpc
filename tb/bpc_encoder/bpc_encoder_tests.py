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
from cocotb.triggers import Timer, RisingEdge
from cocotb.binary import BinaryValue
from common.drivers import reset_dut
from bpc_encoder_driver import BPCEncoderDriver
from bpc_encoder_scoreboard import BPCEncoderScoreboard
from bpc_encoder_monitor import BPCEncoderMonitor
import random

#import pydevd_pycharm
#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True, stderrToServer=True)

random.seed(a=8)

CLOCK_PERIOD = 2500
RESET_TIME = 15000
DATA_W = 8
BLOCK_SIZE = 8
TA = 200
TT = 2000

STIM_REPORT_FILE = '../reports/stimuli.log'
#STIM_REPORT_FILE = None
INT_RESULTS_REPORT_FILE = '../intermediate_results.log'
#INT_RESULTS_REPORT_FILE = None
SUMMARY_REPORT_FILE = '../reports/summary.log'
#SUMMARY_REPORT_FILE = None

@cocotb.test()
def basic_bringup(dut):
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield Timer(10000)

@cocotb.test()
def random_inputs(dut):
    drv = BPCEncoderDriver(dut, TA, TT)
    sb = BPCEncoderScoreboard(dut, BLOCK_SIZE, DATA_W, stim_report_file=STIM_REPORT_FILE)
    mon = BPCEncoderMonitor(dut, BLOCK_SIZE, DATA_W, sb)
    num_input_blocks = 1000
    input_vals = [BinaryValue(n_bits=DATA_W, bigEndian=False, value=random.randint(-2**(DATA_W-1), 2**(DATA_W-1)-1), binaryRepresentation=2) for k in range(BLOCK_SIZE*num_input_blocks)]
    flush = [0] * (len(input_vals)-1)
    flush.append(1)
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    drv.apply_defaults()
    yield reset_dut(dut.rst_ni, RESET_TIME)
    dut._log.info("Reset Done!")
    for k in range(4):
        yield RisingEdge(dut.clk_i)
    mon.start()
    read_task = cocotb.fork(drv.read_outputs(len(input_vals)*2, tmin=0, tmax=0))
    yield drv.drive_input(zip(input_vals, flush), tmin=0, tmax=0)
    yield Timer(4*CLOCK_PERIOD*len(input_vals))
    read_task.kill()
    mon.stop()
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")
