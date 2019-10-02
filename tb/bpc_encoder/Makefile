# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
TOPLEVEL_LANG ?= verilog


WPWD=$(shell sh -c 'pwd -W')
PWD=$(shell pwd)
SRC_DIR = $(PWD)/../../src
ENC_SRC_DIR = $(SRC_DIR)/encoder
SIM_ARGS = "-t 1ps -do '../sim.do'"


#PYTHONPATH := $(PWD)/../pydevd-pycharm.egg:$(PYTHONPATH)


VERILOG_SOURCES +=	$(SRC_DIR)/ebpc_pkg.sv \
        $(ENC_SRC_DIR)/dbx_compressor.sv \
        $(SRC_DIR)/fifo_slice.sv \
        $(ENC_SRC_DIR)/shift_streamer.sv \
        $(ENC_SRC_DIR)/seq_coder.sv \
        $(ENC_SRC_DIR)/dbp_dbx_enc.sv \
        $(ENC_SRC_DIR)/bpc_encoder.sv


TOPLEVEL = bpc_encoder
MODULE = bpc_encoder_tests


include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
