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
from cocotb.triggers import Timer
from common.drivers import reset_dut, wait_cycles
from ebpc_encoder_driver import EBPCEncoderDriver
from ebpc_encoder_scoreboard import EBPCEncoderScoreboard
from ebpc_encoder_monitor import EBPCEncoderMonitor
import numpy as np
import random
import torchvision

#import pydevd_pycharm
#pydevd_pycharm.settrace('risa', port=9100, stdoutToServer=True, stderrToServer=True)

random.seed(38)
np.random.seed(79)

CLOCK_PERIOD = 2500
RESET_TIME = 15000
DATA_W = 8
BLOCK_SIZE = 8
MAX_ZRLE_LEN = 16
TA = 200
TT = 2000
# parameters for Fmap simulation
# images need to be in a subfolder of the specified folder so the torchvision
# image_folder dataset loader thinks it's in a category
IMAGE_LOCATION = '/usr/scratch2/risa/georgr/imagenet/imgs'
MODEL = 'vgg16'
NUM_BATCHES = 1
BATCHSIZE = 1
# Feature maps are massive - use a only this fraction of all fmaps:
FMAP_FRAC = 0.01

@cocotb.test()
def basic_bringup(dut):
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    yield Timer(10000)

@cocotb.test()
def random_inputs(dut):
    drv = EBPCEncoderDriver(dut, TA, TT)
    sb = EBPCEncoderScoreboard(dut, BLOCK_SIZE, DATA_W, MAX_ZRLE_LEN)
    mon = EBPCEncoderMonitor(dut, sb, TA, TT)
    inputs = sb.gen_rand_stimuli(10000, 1536, 0.25)
    drv.apply_defaults()
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    dut._log.info("Reset Done!")
    yield wait_cycles(dut.clk_i, 4)
    mon.start()
    bpc_read_task = cocotb.fork(drv.read_bpc_outputs(len(inputs)*2, tmin=0, tmax=0))
    znz_read_task = cocotb.fork(drv.read_znz_outputs(len(inputs)*2, tmin=0, tmax=0))
    cocotb.fork(drv.drive_input(inputs, tmin=0, tmax=0))
    yield mon.wait_done()
    bpc_read_task.kill()
    znz_read_task.kill()
    mon.stop()
    yield wait_cycles(dut.clk_i, 4)
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")


@cocotb.test()
def all_zeros(dut):
    drv = EBPCEncoderDriver(dut, TA, TT)
    sb = EBPCEncoderScoreboard(dut, BLOCK_SIZE, DATA_W, MAX_ZRLE_LEN)
    mon = EBPCEncoderMonitor(dut, sb, TA, TT)
    inputs = sb.gen_zero_stimuli(4000)
    drv.apply_defaults()
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    dut._log.info("Reset Done!")
    yield wait_cycles(dut.clk_i, 4)
    mon.start()
    bpc_read_task = cocotb.fork(drv.read_bpc_outputs(len(inputs)*2, tmin=0, tmax=0))
    znz_read_task = cocotb.fork(drv.read_znz_outputs(len(inputs)*2, tmin=0, tmax=0))
    cocotb.fork(drv.drive_input(inputs, tmin=0, tmax=0))
    yield mon.wait_done()
    bpc_read_task.kill()
    znz_read_task.kill()
    mon.stop()
    yield wait_cycles(dut.clk_i, 4)
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")

@cocotb.test(skip=True)
def fmap_inputs(dut):
    drv = EBPCEncoderDriver(dut, TA, TT)
    sb = EBPCEncoderScoreboard(dut, BLOCK_SIZE, DATA_W, MAX_ZRLE_LEN)
    mon = EBPCEncoderMonitor(dut, sb, TA, TT)
    inputs, bpc_len, znz_len = sb.gen_fmap_stimuli(model=MODEL, dataset_path=IMAGE_LOCATION, num_batches=NUM_BATCHES, batch_size=BATCHSIZE, fmap_frac=FMAP_FRAC)
    print('Compression Ratio: {}'.format((bpc_len+znz_len)/len(inputs)))
    drv.apply_defaults()
    cocotb.fork(Clock(dut.clk_i, CLOCK_PERIOD).start())
    yield reset_dut(dut.rst_ni, RESET_TIME)
    dut._log.info("Reset Done!")
    yield wait_cycles(dut.clk_i, 4)
    mon.start()
    bpc_read_task = cocotb.fork(drv.read_bpc_outputs(len(inputs)*2, tmin=0, tmax=0))
    znz_read_task = cocotb.fork(drv.read_znz_outputs(len(inputs)*2, tmin=0, tmax=0))
    cocotb.fork(drv.drive_input(inputs, tmin=0, tmax=0))
    yield mon.wait_done()
    bpc_read_task.kill()
    znz_read_task.kill()
    mon.stop()
    yield wait_cycles(dut.clk_i, 4)
    if sb.report():
        raise TestFailure("Scoreboard reported problems - check log!")
