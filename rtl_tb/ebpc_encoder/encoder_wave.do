onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ebpc_encoder_tb/dut_i/clk_i
add wave -noupdate /ebpc_encoder_tb/dut_i/rst_ni
add wave -noupdate -group dut_i -radix decimal /ebpc_encoder_tb/dut_i/data_i
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/last_i
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/vld_i
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/rdy_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/idle_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/znz_data_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/znz_vld_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/znz_rdy_i
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/bpc_data_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/bpc_vld_o
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/bpc_rdy_i
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/data_reg_d
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/data_reg_q
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/last_d
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/last_q
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/flush
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/data_reg_en
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/data_to_bpc
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/vld_to_bpc
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/rdy_from_bpc
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/vld_to_znz
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/rdy_from_znz
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/is_one_to_znz
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/bpc_idle
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/znz_idle
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/wait_rdy_d
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/wait_rdy_q
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/state_d
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/state_q
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/block_cnt_d
add wave -noupdate -group dut_i /ebpc_encoder_tb/dut_i/block_cnt_q
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/data_i
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/flush_i
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/vld_i
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/rdy_o
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/data_o
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/vld_o
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/rdy_i
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/idle_o
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_enc_to_coder
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/vld_enc_to_coder
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/rdy_coder_to_enc
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_idle
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_idle
add wave -noupdate -group bpc_encoder /ebpc_encoder_tb/dut_i/bpc_encoder_i/flush_dbp_dbx_to_coder
add wave -noupdate -group dbp_dbx -radix decimal /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/data_i
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/flush_i
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/vld_i
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/rdy_o
add wave -noupdate -group dbp_dbx -childformat {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp_block_o.dbp -radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp_block_o.base -radix decimal}} -expand -subitemconfig {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp_block_o.dbp {-height 17 -radix binary} /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp_block_o.base {-height 17 -radix decimal}} /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp_block_o
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/vld_o
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/rdy_i
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/flush_o
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/idle_o
add wave -noupdate -group dbp_dbx -radix decimal /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/diffs_d
add wave -noupdate -group dbp_dbx -radix decimal /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/diffs_q
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/last_item_d
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/last_item_q
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/state_d
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/state_q
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/fill_cnt_d
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/fill_cnt_q
add wave -noupdate -group dbp_dbx /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/shift
add wave -noupdate -group dbp_dbx -radix binary -childformat {{{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[0]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[1]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[2]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[3]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[4]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[5]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[6]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[7]} -radix binary} {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[8]} -radix binary}} -expand -subitemconfig {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[0]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[1]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[2]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[3]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[4]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[5]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[6]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[7]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp[8]} {-radix binary}} /ebpc_encoder_tb/dut_i/bpc_encoder_i/dbp_dbx_i/dbp
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_i
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/flush_i
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/vld_i
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/rdy_o
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/data_o
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/vld_o
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/rdy_i
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/idle_o
add wave -noupdate -group seq_coder -radix binary -childformat {{/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp -radix binary -childformat {{{[0]} -radix binary} {{[1]} -radix binary} {{[2]} -radix binary} {{[3]} -radix binary} {{[4]} -radix binary} {{[5]} -radix binary} {{[6]} -radix binary} {{[7]} -radix binary} {{[8]} -radix binary}}} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.base -radix binary}} -subitemconfig {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp {-height 17 -radix binary -childformat {{{[0]} -radix binary} {{[1]} -radix binary} {{[2]} -radix binary} {{[3]} -radix binary} {{[4]} -radix binary} {{[5]} -radix binary} {{[6]} -radix binary} {{[7]} -radix binary} {{[8]} -radix binary}} -expand} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[0]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[1]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[2]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[3]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[4]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[5]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[6]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[7]} {-radix binary} {/ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.dbp[8]} {-radix binary} /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo.base {-height 17 -radix binary}} /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbp_block_from_fifo
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/code_symb
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/state_d
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/state_q
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbx_cnt_d
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/dbx_cnt_q
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/zero_cnt_d
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/zero_cnt_q
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/vld_from_slice
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/rdy_to_slice
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/last_was_zero_d
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/last_was_zero_q
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/flush
add wave -noupdate -group seq_coder -radix binary /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/data
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/shift
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/shift_vld
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/shift_rdy
add wave -noupdate -group seq_coder /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_idle
add wave -noupdate -group streamer -radix binary /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/data_i
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/shift_i
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/flush_i
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/vld_i
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/rdy_o
add wave -noupdate -group streamer -radix binary /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/data_o
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/vld_o
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/rdy_i
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/idle_o
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/stream_reg_d
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/stream_reg_q
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/shift_cnt_d
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/shift_cnt_q
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/st_d
add wave -noupdate -group streamer /ebpc_encoder_tb/dut_i/bpc_encoder_i/seq_coder_i/streamer_i/st_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 360
configure wave -valuecolwidth 510
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {32 ns}
