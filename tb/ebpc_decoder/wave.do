onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ebpc_decoder/clk_i
add wave -noupdate /ebpc_decoder/rst_ni
add wave -noupdate -group Top /ebpc_decoder/bpc_i
add wave -noupdate -group Top /ebpc_decoder/bpc_vld_i
add wave -noupdate -group Top /ebpc_decoder/bpc_rdy_o
add wave -noupdate -group Top -radix binary /ebpc_decoder/znz_i
add wave -noupdate -group Top /ebpc_decoder/znz_vld_i
add wave -noupdate -group Top /ebpc_decoder/znz_rdy_o
add wave -noupdate -group Top /ebpc_decoder/num_words_i
add wave -noupdate -group Top /ebpc_decoder/num_words_vld_i
add wave -noupdate -group Top /ebpc_decoder/num_words_rdy_o
add wave -noupdate -group Top /ebpc_decoder/data_o
add wave -noupdate -group Top /ebpc_decoder/last_o
add wave -noupdate -group Top /ebpc_decoder/vld_o
add wave -noupdate -group Top /ebpc_decoder/rdy_i
add wave -noupdate -group Top -radix unsigned /ebpc_decoder/word_cnt_d
add wave -noupdate -group Top -radix unsigned /ebpc_decoder/word_cnt_q
add wave -noupdate -group Top /ebpc_decoder/vld_to_zrld
add wave -noupdate -group Top /ebpc_decoder/rdy_from_zrld
add wave -noupdate -group Top /ebpc_decoder/znz
add wave -noupdate -group Top /ebpc_decoder/flush_to_zrld
add wave -noupdate -group Top /ebpc_decoder/vld_from_zrld
add wave -noupdate -group Top /ebpc_decoder/rdy_to_zrld
add wave -noupdate -group Top /ebpc_decoder/data_from_bpc
add wave -noupdate -group Top /ebpc_decoder/clr_to_bpc
add wave -noupdate -group Top /ebpc_decoder/vld_from_bpc
add wave -noupdate -group Top /ebpc_decoder/rdy_to_bpc
add wave -noupdate -group Top /ebpc_decoder/state_d
add wave -noupdate -group Top /ebpc_decoder/state_q
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/znz_i
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/vld_i
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/rdy_o
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/znz_o
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/vld_o
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/flush_i
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/rdy_i
add wave -noupdate -group Top -group ZRLD -radix binary /ebpc_decoder/zrld_i/stream_reg_d
add wave -noupdate -group Top -group ZRLD -radix binary /ebpc_decoder/zrld_i/stream_reg_q
add wave -noupdate -group Top -group ZRLD -radix unsigned /ebpc_decoder/zrld_i/fill_state_d
add wave -noupdate -group Top -group ZRLD -radix unsigned /ebpc_decoder/zrld_i/fill_state_q
add wave -noupdate -group Top -group ZRLD -radix unsigned /ebpc_decoder/zrld_i/zero_cnt_d
add wave -noupdate -group Top -group ZRLD -radix unsigned /ebpc_decoder/zrld_i/zero_cnt_q
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/state_d
add wave -noupdate -group Top -group ZRLD /ebpc_decoder/zrld_i/state_q
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/bpc_i
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/bpc_vld_i
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/bpc_rdy_o
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/data_o
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/vld_o
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/rdy_i
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/clr_i
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/data_unpacker_to_decoder
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/fill_state_unpacker_to_decoder
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/len_decoder_to_unpacker
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/vld_unpacker_to_decoder
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/rdy_decoder_to_unpacker
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/data_decoder_to_buffer
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/push_decoder_to_buffer
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/vld_decoder_to_buffer
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/rdy_buffer_to_decoder
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/data_buffer_to_dr
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/vld_buffer_to_dr
add wave -noupdate -group Top -group BPCD /ebpc_decoder/bpcd_i/rdy_dr_to_buffer
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/clk_i
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/rst_ni
add wave -noupdate -group Top -group Unpacker -radix binary /ebpc_decoder/bpcd_i/unpacker_i/data_i
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/vld_i
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/rdy_o
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/data_o
add wave -noupdate -group Top -group Unpacker -radix unsigned /ebpc_decoder/bpcd_i/unpacker_i/fill_state_o
add wave -noupdate -group Top -group Unpacker -radix unsigned /ebpc_decoder/bpcd_i/unpacker_i/len_i
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/vld_o
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/rdy_i
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/clr_i
add wave -noupdate -group Top -group Unpacker -radix binary /ebpc_decoder/bpcd_i/unpacker_i/stream_reg_d
add wave -noupdate -group Top -group Unpacker -radix binary /ebpc_decoder/bpcd_i/unpacker_i/stream_reg_q
add wave -noupdate -group Top -group Unpacker -radix unsigned /ebpc_decoder/bpcd_i/unpacker_i/fill_state_d
add wave -noupdate -group Top -group Unpacker -radix unsigned /ebpc_decoder/bpcd_i/unpacker_i/fill_state_q
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/state_d
add wave -noupdate -group Top -group Unpacker /ebpc_decoder/bpcd_i/unpacker_i/state_q
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/clk_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/rst_ni
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/data_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/unpacker_fill_state_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/len_o
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/data_vld_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/data_rdy_o
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/data_o
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/push_o
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/vld_o
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/rdy_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/clr_i
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/dbx_cnt_d
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/dbx_cnt_q
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/zero_cnt_d
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/zero_cnt_q
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/expander_out
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/expander_is_dbp
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/expander_zeros
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/expander_len
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/dbp_reg_d
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/dbp_reg_q
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/state_d
add wave -noupdate -group Top -group {Symbol Decoder} /ebpc_decoder/bpcd_i/decoder_i/state_q
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/clk_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/rst_ni
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/data_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/push_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/vld_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/rdy_o
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/data_o
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/vld_o
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/rdy_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/clr_i
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/state_d
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/state_q
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/base_d
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/base_q
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/vld_to_slice
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/rdy_from_slice
add wave -noupdate -group Top -group Buffer /ebpc_decoder/bpcd_i/buffer_i/dbp_block_to_fifo
add wave -noupdate -group Top -group {Delta Reverse} -radix binary -childformat {{/ebpc_decoder/bpcd_i/dr_i/data_i.dbp -radix binary -childformat {{{[0]} -radix binary} {{[1]} -radix binary} {{[2]} -radix binary} {{[3]} -radix binary} {{[4]} -radix binary} {{[5]} -radix binary} {{[6]} -radix binary} {{[7]} -radix binary} {{[8]} -radix binary}}} {/ebpc_decoder/bpcd_i/dr_i/data_i.base -radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.flush -radix binary}} -expand -subitemconfig {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp {-height 17 -radix binary -childformat {{{[0]} -radix binary} {{[1]} -radix binary} {{[2]} -radix binary} {{[3]} -radix binary} {{[4]} -radix binary} {{[5]} -radix binary} {{[6]} -radix binary} {{[7]} -radix binary} {{[8]} -radix binary}}} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[0]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[1]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[2]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[3]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[4]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[5]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[6]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[7]} {-radix binary} {/ebpc_decoder/bpcd_i/dr_i/data_i.dbp[8]} {-radix binary} /ebpc_decoder/bpcd_i/dr_i/data_i.base {-height 17 -radix binary} /ebpc_decoder/bpcd_i/dr_i/data_i.flush {-height 17 -radix binary}} /ebpc_decoder/bpcd_i/dr_i/data_i
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/vld_i
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/rdy_o
add wave -noupdate -group Top -group {Delta Reverse} -radix decimal /ebpc_decoder/bpcd_i/dr_i/data_o
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/vld_o
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/rdy_i
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/clr_i
add wave -noupdate -group Top -group {Delta Reverse} -radix decimal /ebpc_decoder/bpcd_i/dr_i/diffs
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/state_d
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/state_q
add wave -noupdate -group Top -group {Delta Reverse} -radix decimal /ebpc_decoder/bpcd_i/dr_i/acc_reg_d
add wave -noupdate -group Top -group {Delta Reverse} -radix decimal /ebpc_decoder/bpcd_i/dr_i/acc_reg_q
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/diff_idx_d
add wave -noupdate -group Top -group {Delta Reverse} /ebpc_decoder/bpcd_i/dr_i/diff_idx_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {518152304 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 356
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
WaveRestoreZoom {0 ps} {2526222977 ps}
