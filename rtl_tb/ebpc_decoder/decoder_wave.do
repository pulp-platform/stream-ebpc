onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ebpc_decoder_tb/dut_i/clk_i
add wave -noupdate /ebpc_decoder_tb/dut_i/rst_ni
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/bpc_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/bpc_vld_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/bpc_rdy_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/znz_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/znz_vld_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/znz_rdy_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/num_words_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/num_words_vld_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/num_words_rdy_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/data_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/last_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/vld_o
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/rdy_i
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/word_cnt_d
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/word_cnt_q
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/vld_to_zrld
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/rdy_from_zrld
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/znz
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/flush_to_zrld
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/vld_from_zrld
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/rdy_to_zrld
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/data_from_bpc
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/clr_to_bpc
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/vld_from_bpc
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/rdy_to_bpc
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/state_d
add wave -noupdate -expand -group dut /ebpc_decoder_tb/dut_i/state_q
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/bpc_i
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/bpc_vld_i
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/bpc_rdy_o
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/data_o
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/vld_o
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/rdy_i
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/clr_i
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/data_unpacker_to_decoder
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/fill_state_unpacker_to_decoder
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/len_decoder_to_unpacker
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/vld_unpacker_to_decoder
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/rdy_decoder_to_unpacker
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/data_decoder_to_buffer
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/push_decoder_to_buffer
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/vld_decoder_to_buffer
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/rdy_buffer_to_decoder
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/data_buffer_to_dr
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/vld_buffer_to_dr
add wave -noupdate -group {BPC Decoder} /ebpc_decoder_tb/dut_i/bpcd_i/rdy_dr_to_buffer
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/data_i
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/vld_i
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/rdy_o
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/data_o
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/fill_state_o
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/len_i
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/vld_o
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/rdy_i
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/clr_i
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/stream_reg_d
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/stream_reg_q
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/fill_state_d
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/fill_state_q
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/state_d
add wave -noupdate -group unpacker /ebpc_decoder_tb/dut_i/bpcd_i/unpacker_i/state_q
add wave -noupdate -group decoder -radix binary /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/data_i
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/unpacker_fill_state_i
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/len_o
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/data_vld_i
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/data_rdy_o
add wave -noupdate -group decoder -radix binary /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/data_o
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/push_o
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/vld_o
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/rdy_i
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/clr_i
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/dbx_cnt_d
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/dbx_cnt_q
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/zero_cnt_d
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/zero_cnt_q
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/expander_out
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/expander_is_dbp
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/expander_zeros
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/expander_len
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/dbp_reg_d
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/dbp_reg_q
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/state_d
add wave -noupdate -group decoder /ebpc_decoder_tb/dut_i/bpcd_i/decoder_i/state_q
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/data_i
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/push_i
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/vld_i
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/rdy_o
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/data_o
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/vld_o
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/rdy_i
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/clr_i
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/state_d
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/state_q
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/base_d
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/base_q
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/shift_reg_d
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/shift_reg_q
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/vld_to_slice
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/rdy_from_slice
add wave -noupdate -group buffer /ebpc_decoder_tb/dut_i/bpcd_i/buffer_i/dbp_block_to_fifo
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/data_i
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/vld_i
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/rdy_o
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/data_o
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/vld_o
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/rdy_i
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/clr_i
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/diffs
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/state_d
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/state_q
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/acc_reg_d
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/acc_reg_q
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/diff_idx_d
add wave -noupdate -group delta_reverse /ebpc_decoder_tb/dut_i/bpcd_i/dr_i/diff_idx_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5131915709 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {5131902565 ps} {5131933629 ps}
