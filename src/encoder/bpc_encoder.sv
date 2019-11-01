// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


import ebpc_pkg::*;

module bpc_encoder
  (
   input logic               clk_i,
   input logic               rst_ni,
   input logic [DATA_W-1:0]  data_i,
   input logic               flush_i,
   input logic               vld_i,
   output logic              rdy_o,
   output logic [DATA_W-1:0] data_o,
   output logic              vld_o,
   input logic               rdy_i,
   output logic              idle_o,
   output logic              waiting_for_data_o
   );

  dbp_block_t                  dbp_enc_to_coder;
  //logic [0:DATA_W][BLOCK_SIZE-2:0] dbp, dbx;
  logic                      vld_enc_to_coder;
  logic                      rdy_coder_to_enc;
  logic                      dbp_dbx_idle;
  logic                      dbp_waiting;
  logic                      seq_coder_idle;
  logic                      sc_waiting;
  logic                      flush_dbp_dbx_to_coder;

  assign idle_o = seq_coder_idle && dbp_dbx_idle;
  assign waiting_for_data_o = sc_waiting & dbp_waiting;

  dbp_dbx_enc
    dbp_dbx_i (
               .clk_i(clk_i),
               .rst_ni(rst_ni),
               .data_i(data_i),
               .flush_i(flush_i),
               .vld_i(vld_i),
               .rdy_o(rdy_o),
               .flush_o(flush_dbp_dbx_to_coder),
               .dbp_block_o(dbp_enc_to_coder),
               .vld_o(vld_enc_to_coder),
               .rdy_i(rdy_coder_to_enc),
               .idle_o(dbp_dbx_idle),
               .waiting_for_data_o(dbp_waiting)
               );

  seq_coder
    seq_coder_i (
                 .clk_i(clk_i),
                 .rst_ni(rst_ni),
                 .dbp_block_i(dbp_enc_to_coder),
                 .flush_i(flush_dbp_dbx_to_coder),
                 .vld_i(vld_enc_to_coder),
                 .rdy_o(rdy_coder_to_enc),
                 .data_o(data_o),
                 .vld_o(vld_o),
                 .rdy_i(rdy_i),
                 .idle_o(seq_coder_idle),
                 .waiting_for_data_o(sc_waiting)
                 );

endmodule // bpc_encoder
