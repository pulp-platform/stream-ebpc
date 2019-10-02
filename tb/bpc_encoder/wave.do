onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Top /bpc_encoder/clk_i
add wave -noupdate -expand -group Top /bpc_encoder/rst_ni
add wave -noupdate -expand -group Top /bpc_encoder/data_i
add wave -noupdate -expand -group Top /bpc_encoder/flush_i
add wave -noupdate -expand -group Top /bpc_encoder/vld_i
add wave -noupdate -expand -group Top /bpc_encoder/rdy_o
add wave -noupdate -expand -group Top /bpc_encoder/data_o
add wave -noupdate -expand -group Top /bpc_encoder/vld_o
add wave -noupdate -expand -group Top /bpc_encoder/rdy_i
add wave -noupdate -expand -group Top /bpc_encoder/vld_enc_to_coder
add wave -noupdate -expand -group Top /bpc_encoder/rdy_coder_to_enc
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/data_i
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/flush_i
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/vld_i
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/rdy_o
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/vld_o
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/rdy_i
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/diffs_d
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/diffs_q
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/last_item_d
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/last_item_q
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/state_d
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/state_q
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/fill_cnt_d
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/fill_cnt_q
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/shift
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/dbp
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/dbx
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/flush_d
add wave -noupdate -group {DBP/DBX Converter} /bpc_encoder/dbp_dbx_i/flush_q
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/vld_i
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/rdy_o
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/data_o
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/vld_o
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/rdy_i
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/code_symb
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/state_d
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/state_q
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/dbx_cnt_d
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/dbx_cnt_q
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/zero_cnt_d
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/zero_cnt_q
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/vld_from_slice
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/rdy_to_slice
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/last_was_zero_d
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/last_was_zero_q
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/flush
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/data
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/shift
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/stream_base
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/shift_vld
add wave -noupdate -expand -group {Seqential Encoder} /bpc_encoder/seq_coder_i/shift_rdy
add wave -noupdate -expand -group {Shift Streamer} -radix binary /bpc_encoder/seq_coder_i/streamer_i/data_i
add wave -noupdate -expand -group {Shift Streamer} -radix unsigned /bpc_encoder/seq_coder_i/streamer_i/shift_i
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/flush_i
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/vld_i
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/rdy_o
add wave -noupdate -expand -group {Shift Streamer} -radix binary /bpc_encoder/seq_coder_i/streamer_i/data_o
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/vld_o
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/rdy_i
add wave -noupdate -expand -group {Shift Streamer} -radix binary /bpc_encoder/seq_coder_i/streamer_i/stream_reg_d
add wave -noupdate -expand -group {Shift Streamer} -radix binary /bpc_encoder/seq_coder_i/streamer_i/stream_reg_q
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/shift_cnt_d
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/shift_cnt_q
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/st_d
add wave -noupdate -expand -group {Shift Streamer} /bpc_encoder/seq_coder_i/streamer_i/st_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105122561 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 118
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
WaveRestoreZoom {105111149 ps} {105202047 ps}
