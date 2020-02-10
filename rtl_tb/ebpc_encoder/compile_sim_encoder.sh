#! /usr/bin/env bash
TOP="ebpc_encoder_tb"
CADENCE_IUS="cds_ius-18.09.005 xrun"
#CADENCE_IUS="xrun"
XRUN_OPTIONS="-64bit -design_top ${TOP} -sv -timescale 100ps/1ps -input encoder_xcelium_commands.tcl"
XRUN_GUI_OPTIONS="-access +rc -gui"
QUESTA_VLOG="questa-2019.3 vlog"
#QUESTA_VLOG="vlog"
QUESTA_VSIM="questa-2019.3 vsim"
#QUESTA_VSIM="vsim"
QUESTA_OPTIONS="-do encoder_questa_commands.tcl -64 -t 1ps"
QUESTA_BATCH_OPTIONS="-batch"

SV_SOURCES="../../src/ebpc_pkg.sv \
           ../../src/encoder/bpc_encoder.sv \
           ../../src/encoder/dbp_dbx_enc.sv \
           ../../src/encoder/dbx_compressor.sv \
           ../../src/encoder/ebpc_encoder.sv \
           ../../src/encoder/seq_coder.sv \
           ../../src/encoder/shift_streamer.sv \
           ../../src/encoder/zrle.sv \
           ../../src/encoder/bpc_buffer.sv \
           ../../src/fifo_slice.sv \
           ../../src/clk_gate.sv \
           ../hs_intf.sv \
           ../hs_drivers.sv \
           ../rst_clk_drv.sv \
           ./${TOP}.sv"

#uncomment if you use cadence
#${CADENCE_IUS} ${XRUN_OPTIONS} ${XRUN_GUI_OPTIONS} ${SV_SOURCES}

${QUESTA_VLOG} ${SV_SOURCES}
echo -e "-------GUI SIMULATION COMMAND------\n${QUESTA_VSIM} ${QUESTA_OPTIONS} +acc -debugdb -classdebug ${TOP} &"
echo -e "------BATCH SIMULATION COMMAND-----\n${QUESTA_VSIM} ${QUESTA_OPTIONS} ${QUESTA_BATCH_OPTIONS} ${TOP}"
