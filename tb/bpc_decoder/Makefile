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
DEC_SRC_DIR = $(SRC_DIR)/decoder
SIM_ARGS = -t 1ps -do ../sim.do -debugdb


#PYTHONPATH := $(PWD)/../pydevd-pycharm.egg:$(PYTHONPATH)


VERILOG_SOURCES +=	$(SRC_DIR)/ebpc_pkg.sv \
        $(DEC_SRC_DIR)/bpc_decoder.sv \
        $(SRC_DIR)/fifo_slice.sv \
        $(DEC_SRC_DIR)/buffer.sv \
        $(DEC_SRC_DIR)/delta_reverse.sv \
        $(DEC_SRC_DIR)/expander.sv \
        $(DEC_SRC_DIR)/symbol_decoder.sv \
				$(DEC_SRC_DIR)/unpacker.sv \


TOPLEVEL = bpc_decoder
MODULE = bpc_decoder_tests


include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
