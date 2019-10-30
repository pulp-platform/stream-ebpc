#! /usr/bin/env bash
#change executable names to match your system setup
TOP="ebpc_decoder_tb"
CADENCE_IUS="cds_ius-18.09.005 xrun"
XRUN_OPTIONS="-64bit -design_top ${TOP} -sv -timescale 100ps/1ps -input decoder_xcelium_commands.tcl"
XRUN_GUI_OPTIONS="-access +rc -gui"
QUESTA_VLOG="questa-2019.3 vlog"
QUESTA_VSIM="questa-2019.3 vsim"
QUESTA_OPTIONS="-do decoder_questa_commands.tcl -64 -t 1ps"
QUESTA_BATCH_OPTIONS="-batch"

SV_SOURCES="../hs_drivers.sv \
           ../../src/ebpc_pkg.sv \
           ../../src/decoder/bpc_decoder.sv \
           ../../src/decoder/buffer.sv \
           ../../src/decoder/delta_reverse.sv \
           ../../src/decoder/ebpc_decoder.sv \
           ../../src/decoder/expander.sv \
           ../../src/decoder/symbol_decoder.sv \
           ../../src/decoder/unpacker.sv \
           ../../src/decoder/zrle_decoder.sv \
           ../../src/fifo_slice.sv \
           ../rst_clk_drv.sv \
           ../hs_intf.sv \
           ./ebpc_decoder_tb.sv"

#uncomment if you use cadence
#${CADENCE_IUS} ${XRUN_OPTIONS} ${XRUN_GUI_OPTIONS} ${SV_SOURCES}
${QUESTA_VLOG} ${SV_SOURCES}
echo -e "-------GUI SIMULATION COMMAND------\n${QUESTA_VSIM} ${QUESTA_OPTIONS} +acc -debugdb -classdebug ${TOP}"
echo -e "------BATCH SIMULATION COMMAND-----\n${QUESTA_VSIM} ${QUESTA_OPTIONS} ${QUESTA_BATCH_OPTIONS} ${TOP}"
