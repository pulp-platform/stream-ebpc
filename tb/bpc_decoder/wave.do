onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bpc_decoder/clk_i
add wave -noupdate /bpc_decoder/rst_ni
add wave -noupdate -group Top /bpc_decoder/bpc_i
add wave -noupdate -group Top /bpc_decoder/bpc_vld_i
add wave -noupdate -group Top /bpc_decoder/bpc_rdy_o
add wave -noupdate -group Top -radix decimal /bpc_decoder/data_o
add wave -noupdate -group Top /bpc_decoder/vld_o
add wave -noupdate -group Top /bpc_decoder/rdy_i
add wave -noupdate -group Top /bpc_decoder/clr_i
add wave -noupdate -group Top /bpc_decoder/data_unpacker_to_decoder
add wave -noupdate -group Top /bpc_decoder/fill_state_unpacker_to_decoder
add wave -noupdate -group Top /bpc_decoder/len_decoder_to_unpacker
add wave -noupdate -group Top /bpc_decoder/vld_unpacker_to_decoder
add wave -noupdate -group Top /bpc_decoder/rdy_decoder_to_unpacker
add wave -noupdate -group Top /bpc_decoder/data_decoder_to_buffer
add wave -noupdate -group Top /bpc_decoder/vld_decoder_to_buffer
add wave -noupdate -group Top /bpc_decoder/rdy_buffer_to_decoder
add wave -noupdate -group Top /bpc_decoder/data_buffer_to_dr
add wave -noupdate -group Top /bpc_decoder/vld_buffer_to_dr
add wave -noupdate -group Top /bpc_decoder/rdy_dr_to_buffer
add wave -noupdate -group unpacker -radix binary /bpc_decoder/unpacker_i/data_i
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/vld_i
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/rdy_o
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/data_o
add wave -noupdate -group unpacker -radix unsigned /bpc_decoder/unpacker_i/fill_state_o
add wave -noupdate -group unpacker -radix unsigned /bpc_decoder/unpacker_i/len_i
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/vld_o
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/rdy_i
add wave -noupdate -group unpacker -radix binary /bpc_decoder/unpacker_i/stream_reg_d
add wave -noupdate -group unpacker -radix binary /bpc_decoder/unpacker_i/stream_reg_q
add wave -noupdate -group unpacker -radix unsigned /bpc_decoder/unpacker_i/fill_state_d
add wave -noupdate -group unpacker -radix unsigned /bpc_decoder/unpacker_i/fill_state_q
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/state_d
add wave -noupdate -group unpacker /bpc_decoder/unpacker_i/state_q
add wave -noupdate -group decoder -radix binary /bpc_decoder/decoder_i/data_i
add wave -noupdate -group decoder -radix unsigned /bpc_decoder/decoder_i/unpacker_fill_state_i
add wave -noupdate -group decoder /bpc_decoder/decoder_i/len_o
add wave -noupdate -group decoder /bpc_decoder/decoder_i/data_vld_i
add wave -noupdate -group decoder /bpc_decoder/decoder_i/data_rdy_o
add wave -noupdate -group decoder -radix binary /bpc_decoder/decoder_i/data_o
add wave -noupdate -group decoder /bpc_decoder/decoder_i/push_o
add wave -noupdate -group decoder /bpc_decoder/decoder_i/vld_o
add wave -noupdate -group decoder /bpc_decoder/decoder_i/rdy_i
add wave -noupdate -group decoder /bpc_decoder/decoder_i/dbx_cnt_d
add wave -noupdate -group decoder /bpc_decoder/decoder_i/dbx_cnt_q
add wave -noupdate -group decoder /bpc_decoder/decoder_i/zero_cnt_d
add wave -noupdate -group decoder /bpc_decoder/decoder_i/zero_cnt_q
add wave -noupdate -group decoder /bpc_decoder/decoder_i/base
add wave -noupdate -group decoder -radix binary /bpc_decoder/decoder_i/expander_out
add wave -noupdate -group decoder /bpc_decoder/decoder_i/expander_is_dbp
add wave -noupdate -group decoder /bpc_decoder/decoder_i/expander_zeros
add wave -noupdate -group decoder /bpc_decoder/decoder_i/expander_len
add wave -noupdate -group decoder -radix binary /bpc_decoder/decoder_i/dbp_reg_d
add wave -noupdate -group decoder -radix binary /bpc_decoder/decoder_i/dbp_reg_q
add wave -noupdate -group decoder /bpc_decoder/decoder_i/state_d
add wave -noupdate -group decoder /bpc_decoder/decoder_i/state_q
add wave -noupdate -group buffer -radix binary /bpc_decoder/buffer_i/data_i
add wave -noupdate -group buffer /bpc_decoder/buffer_i/push_i
add wave -noupdate -group buffer /bpc_decoder/buffer_i/vld_i
add wave -noupdate -group buffer /bpc_decoder/buffer_i/rdy_o
add wave -noupdate -group buffer /bpc_decoder/buffer_i/data_o
add wave -noupdate -group buffer /bpc_decoder/buffer_i/vld_o
add wave -noupdate -group buffer /bpc_decoder/buffer_i/rdy_i
add wave -noupdate -group buffer /bpc_decoder/buffer_i/state_d
add wave -noupdate -group buffer /bpc_decoder/buffer_i/state_q
add wave -noupdate -group buffer /bpc_decoder/buffer_i/shift_reg_d
add wave -noupdate -group buffer /bpc_decoder/buffer_i/shift_reg_q
add wave -noupdate -group buffer /bpc_decoder/buffer_i/base_d
add wave -noupdate -group buffer /bpc_decoder/buffer_i/base_q
add wave -noupdate -group buffer /bpc_decoder/buffer_i/vld_to_slice
add wave -noupdate -group buffer /bpc_decoder/buffer_i/rdy_from_slice
add wave -noupdate -group buffer /bpc_decoder/buffer_i/dbp_block_to_fifo
add wave -noupdate -group delta_reverse -expand /bpc_decoder/dr_i/data_i
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/vld_i
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/rdy_o
add wave -noupdate -group delta_reverse -radix decimal /bpc_decoder/dr_i/data_o
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/vld_o
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/rdy_i
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/state_d
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/state_q
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/diffs
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/acc_reg_d
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/acc_reg_q
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/diff_idx_d
add wave -noupdate -group delta_reverse /bpc_decoder/dr_i/diff_idx_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {156419 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 211
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
WaveRestoreZoom {148105 ps} {172675 ps}
