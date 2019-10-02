// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module bpc_decoder
  import ebpc_pkg::*;
  (
   input logic                          clk_i,
   input logic                          rst_ni,
   input logic [DATA_W-1:0]             bpc_i,
   input logic                          bpc_vld_i,
   output logic                         bpc_rdy_o,
   output logic [DATA_W-1:0]            data_o,
   output logic                         vld_o,
   input logic                          rdy_i,
   input logic                          clr_i
   );

  // signals between unpacker and decoder
  logic [DATA_W-1:0]                    data_unpacker_to_decoder;
  logic [LOG_DATA_W:0]                  fill_state_unpacker_to_decoder;
  logic [LOG_DATA_W:0]                  len_decoder_to_unpacker;
  logic                                 vld_unpacker_to_decoder, rdy_decoder_to_unpacker;
  // signals between decoder and buffer
  logic [DATA_W-1:0]                    data_decoder_to_buffer;
  logic                                 push_decoder_to_buffer;
  logic                                 vld_decoder_to_buffer, rdy_buffer_to_decoder;

  // signals between buffer and delta reverse
  dbp_block_t                           data_buffer_to_dr;
  logic                                 vld_buffer_to_dr, rdy_dr_to_buffer;

  unpacker
    unpacker_i (
                .clk_i(clk_i),
                .rst_ni(rst_ni),
                .data_i(bpc_i),
                .vld_i(bpc_vld_i),
                .rdy_o(bpc_rdy_o),
                .data_o(data_unpacker_to_decoder),
                .fill_state_o(fill_state_unpacker_to_decoder),
                .len_i(len_decoder_to_unpacker),
                .vld_o(vld_unpacker_to_decoder),
                .rdy_i(rdy_decoder_to_unpacker),
                .clr_i(clr_i)
                );

  symbol_decoder
    decoder_i(
              .clk_i(clk_i),
              .rst_ni(rst_ni),
              .data_i(data_unpacker_to_decoder),
              .unpacker_fill_state_i(fill_state_unpacker_to_decoder),
              .len_o(len_decoder_to_unpacker),
              .data_vld_i(vld_unpacker_to_decoder),
              .data_rdy_o(rdy_decoder_to_unpacker),
              .data_o(data_decoder_to_buffer),
              .push_o(push_decoder_to_buffer),
              .vld_o(vld_decoder_to_buffer),
              .rdy_i(rdy_buffer_to_decoder),
              .clr_i(clr_i)
              );

  buffer
    buffer_i(
             .clk_i(clk_i),
             .rst_ni(rst_ni),
             .data_i(data_decoder_to_buffer),
             .push_i(push_decoder_to_buffer),
             .vld_i(vld_decoder_to_buffer),
             .rdy_o(rdy_buffer_to_decoder),
             .data_o(data_buffer_to_dr),
             .vld_o(vld_buffer_to_dr),
             .rdy_i(rdy_dr_to_buffer),
             .clr_i(clr_i)
             );

  delta_reverse
    dr_i(
         .clk_i(clk_i),
         .rst_ni(rst_ni),
         .data_i(data_buffer_to_dr),
         .vld_i(vld_buffer_to_dr),
         .rdy_o(rdy_dr_to_buffer),
         .data_o(data_o),
         .vld_o(vld_o),
         .rdy_i(rdy_i),
         .clr_i(clr_i)
         );

endmodule // bpc_decoder
