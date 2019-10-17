onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Global
add wave -noupdate /ebpc_encoder/clk_i
add wave -noupdate /ebpc_encoder/rst_ni
add wave -noupdate -expand -group Top -radix decimal /ebpc_encoder/data_i
add wave -noupdate -expand -group Top /ebpc_encoder/last_i
add wave -noupdate -expand -group Top /ebpc_encoder/vld_i
add wave -noupdate -expand -group Top /ebpc_encoder/rdy_o
add wave -noupdate -expand -group Top /ebpc_encoder/znz_data_o
add wave -noupdate -expand -group Top /ebpc_encoder/znz_vld_o
add wave -noupdate -expand -group Top /ebpc_encoder/znz_rdy_i
add wave -noupdate -expand -group Top -expand /ebpc_encoder/bpc_data_o
add wave -noupdate -expand -group Top /ebpc_encoder/bpc_vld_o
add wave -noupdate -expand -group Top /ebpc_encoder/bpc_rdy_i
add wave -noupdate -expand -group Top /ebpc_encoder/idle_o
add wave -noupdate -expand -group Top /ebpc_encoder/bpc_idle
add wave -noupdate -expand -group Top /ebpc_encoder/znz_idle
add wave -noupdate -expand -group Top /ebpc_encoder/data_reg_d
add wave -noupdate -expand -group Top /ebpc_encoder/data_reg_q
add wave -noupdate -expand -group Top /ebpc_encoder/flush_d
add wave -noupdate -expand -group Top /ebpc_encoder/flush_q
add wave -noupdate -expand -group Top /ebpc_encoder/data_reg_en
add wave -noupdate -expand -group Top -radix decimal /ebpc_encoder/data_to_bpc
add wave -noupdate -expand -group Top /ebpc_encoder/vld_to_bpc
add wave -noupdate -expand -group Top /ebpc_encoder/rdy_from_bpc
add wave -noupdate -expand -group Top /ebpc_encoder/vld_to_znz
add wave -noupdate -expand -group Top /ebpc_encoder/rdy_from_znz
add wave -noupdate -expand -group Top /ebpc_encoder/is_one_to_znz
add wave -noupdate -expand -group Top /ebpc_encoder/wait_rdy_d
add wave -noupdate -expand -group Top /ebpc_encoder/wait_rdy_q
add wave -noupdate -expand -group Top /ebpc_encoder/state_d
add wave -noupdate -expand -group Top /ebpc_encoder/state_q
add wave -noupdate -expand -group Top /ebpc_encoder/block_cnt_d
add wave -noupdate -expand -group Top /ebpc_encoder/block_cnt_q
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/is_one_i
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/flush_i
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/vld_i
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/rdy_o
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/data_o
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/vld_o
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/rdy_i
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/state_d
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/state_q
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/zero_cnt_d
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/zero_cnt_q
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/stream_reg_d
add wave -noupdate -group ZNZ/ZRLE /ebpc_encoder/zrle_i/stream_reg_q
add wave -noupdate -group ZNZ/ZRLE -radix unsigned /ebpc_encoder/zrle_i/shift_cnt_d
add wave -noupdate -group ZNZ/ZRLE -radix unsigned /ebpc_encoder/zrle_i/shift_cnt_q
add wave -noupdate -expand -group {BPC Encoder} -radix hexadecimal -childformat {{{/ebpc_encoder/bpc_encoder_i/data_i[7]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[6]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[5]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[4]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[3]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[2]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[1]} -radix decimal} {{/ebpc_encoder/bpc_encoder_i/data_i[0]} -radix decimal}} -expand -subitemconfig {{/ebpc_encoder/bpc_encoder_i/data_i[7]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[6]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[5]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[4]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[3]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[2]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[1]} {-radix decimal} {/ebpc_encoder/bpc_encoder_i/data_i[0]} {-radix decimal}} /ebpc_encoder/bpc_encoder_i/data_i
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/flush_i
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/vld_i
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/rdy_o
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/data_o
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/vld_o
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/rdy_i
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/idle_o
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/vld_enc_to_coder
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/rdy_coder_to_enc
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/dbp_dbx_idle
add wave -noupdate -expand -group {BPC Encoder} /ebpc_encoder/bpc_encoder_i/seq_coder_idle
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} -radix hexadecimal /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/data_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/flush_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/vld_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/rdy_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/vld_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/rdy_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/idle_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} -radix decimal /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/diffs_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} -radix decimal /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/diffs_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/last_item_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/last_item_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/state_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/state_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/fill_cnt_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/fill_cnt_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/shift
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} -radix binary /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/dbp
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/dbx
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/flush_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {DBP DBX Enc} /ebpc_encoder/bpc_encoder_i/dbp_dbx_i/flush_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/dbp_block_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/vld_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/rdy_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/data_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/vld_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/rdy_i
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/idle_o
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_idle
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/code_symb
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/state_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/state_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/dbx_cnt_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/dbx_cnt_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/zero_cnt_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/zero_cnt_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/vld_from_slice
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/rdy_to_slice
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/last_was_zero_d
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/last_was_zero_q
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/flush
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/data
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/shift
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/shift_vld
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} /ebpc_encoder/bpc_encoder_i/seq_coder_i/shift_rdy
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} -expand -group Compressor /ebpc_encoder/bpc_encoder_i/seq_coder_i/compressor_i/dbp
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} -expand -group Compressor /ebpc_encoder/bpc_encoder_i/seq_coder_i/compressor_i/dbp_cnt
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} -expand -group Compressor /ebpc_encoder/bpc_encoder_i/seq_coder_i/compressor_i/code_symb
add wave -noupdate -expand -group {BPC Encoder} -expand -group {Seq Coder} -expand -group Compressor /ebpc_encoder/bpc_encoder_i/seq_coder_i/compressor_i/dbx
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/data_i
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} -radix unsigned /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/shift_i
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/flush_i
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/vld_i
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/rdy_o
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} -radix binary /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/data_o
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/vld_o
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/rdy_i
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/idle_o
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/stream_reg_d
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/stream_reg_q
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/shift_cnt_d
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/shift_cnt_q
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/st_d
add wave -noupdate -expand -group {BPC Encoder} -group {Shfit Streamer} /ebpc_encoder/bpc_encoder_i/seq_coder_i/streamer_i/st_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {125513832 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 660
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
WaveRestoreZoom {419957602 ps} {420017498 ps}
