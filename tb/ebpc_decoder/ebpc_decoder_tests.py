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
from cocotb.triggers import Timer, RisingEdge
from common.drivers import reset_dut, wait_cycles
from ebpc_decoder_driver import EBPCDecoderDriver
from ebpc_decoder_scoreboard import EBPCDecoderScoreboard
from ebpc_decoder_monitor import EBPCDecoderMonitor
import numpy as np
import random

#import pydevd_pycharm
#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True, stderrToServer=True)

random.seed(29)
np.random.seed(29)

CLOCK_PERIOD = 2500
RESET_TIME = 15000
DATA_W = 8
BLOCK_SIZE = 8
MAX_ZRLE_LEN = 16
TA = 200
TT = 2000
NUM_WORDS = 600001

@cocotb.test()
def random_inputs(dut):

    drv = EBPCDecoderDriver(dut, TA, TT)
    sb = EBPCDecoderScoreboard(dut, BLOCK_SIZE, DATA_W, MAX_ZRLE_LEN)
    mon = EBPCDecoderMonitor(dut, sb)
    bpc_in, znz_in = sb.gen_rand_stimuli(NUM_WORDS, 10, 0.2)
    drv.apply_defaults()
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield wait_cycles(dut.clk_i, 4)
    mon.start()
    num_words_feed_task = cocotb.fork(drv.write_num_words(NUM_WORDS-1, 0, 50))
    bpc_feed_task = cocotb.fork(drv.drive_bpc(bpc_in, 0, 0))
    znz_feed_task = cocotb.fork(drv.drive_znz(znz_in, 0, 0))
    yield drv.read_outputs(100000000, 0, 0)
    bpc_feed_task.kill()
    znz_feed_task.kill()
    num_words_feed_task.kill()
    mon.stop()
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")
