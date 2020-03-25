// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module ebpc_decoder
  import ebpc_pkg::*;
  (
   input logic                     clk_i,
   input logic                     rst_ni,
   input logic [DATA_W-1:0]        bpc_i,
   input logic                     bpc_last_i,
   input logic                     bpc_vld_i,
   output logic                    bpc_rdy_o,
   input logic [DATA_W-1:0]        znz_i,
   input logic                     znz_last_i,
   input logic                     znz_vld_i,
   output logic                    znz_rdy_o,
   // num_words must be (#unencoded words - 1)
   input logic [LOG_MAX_WORDS-1:0] num_words_i,
   input logic                     num_words_vld_i,
   output logic                    num_words_rdy_o,
   output logic [DATA_W-1:0]       data_o,
   output logic                    last_o,
   output logic                    vld_o,
   input logic                     rdy_i
   );

  logic [LOG_MAX_WORDS-1:0]             word_cnt_d, word_cnt_q;

  // after bpc_last_i/znz_last_i have been asserted, the respective decoder
  // input handshakes will be blocked to prevent corruption of subsequent streams
  logic                                 vld_to_bpc, rdy_from_bpc;
  logic                                 block_bpc_inp_d, block_bpc_inp_q;
  assign bpc_rdy_o = (block_bpc_inp_q) ? 1'b0 : rdy_from_bpc;
  assign vld_to_bpc = (block_bpc_inp_q) ? 1'b0 : bpc_vld_i;

  logic                                 vld_to_zrld, rdy_from_zrld;

  logic                                 znz;
  logic                                 flush_to_zrld;
  logic                                 vld_from_zrld, rdy_to_zrld;
  logic                                 block_znz_inp_d, block_znz_inp_q;
  assign znz_rdy_o = (block_znz_inp_q) ? 1'b0 : rdy_from_zrld;
  assign vld_to_zrld = (block_znz_inp_q) ? 1'b0 : znz_vld_i;

  logic [DATA_W-1:0]                    data_from_bpc;
  logic                                 clr_to_bpc;
  logic                                 vld_from_bpc, rdy_to_bpc;

  typedef enum                          {idle, running, flush} state_t;
  state_t                               state_d, state_q;


  always_comb begin : fsm
    num_words_rdy_o = 1'b0;
    vld_o           = 1'b0;
    last_o          = 1'b0;
    word_cnt_d      = word_cnt_q;
    state_d         = state_q;
    flush_to_zrld   = 1'b0;
    clr_to_bpc      = 1'b0;
    data_o          = 'd0;
    rdy_to_bpc      = 1'b0;
    rdy_to_zrld     = 1'b0;
    block_bpc_inp_d = block_bpc_inp_q;
    block_znz_inp_d = block_znz_inp_q;

    case (state_q)
      idle : begin
        assert (block_bpc_inp_q == 1'b0) else $warning("Assertion failed in ebpc_decoder - block_bpc_inp_q not low in idle state!");
        assert (block_znz_inp_q == 1'b0) else $warning("Assertion failed in ebpc_decoder - block_znz_inp_q not low in idle state!");
        num_words_rdy_o = 1'b1;
        if (num_words_vld_i) begin
          block_bpc_inp_d = 1'b0;
          block_znz_inp_d = 1'b0;
          word_cnt_d      = num_words_i;
          state_d         = running;
        end
      end
      running : begin
        if (bpc_vld_i & bpc_last_i & bpc_rdy_o)
          block_bpc_inp_d = 1'b1;
        if (znz_vld_i & znz_last_i & znz_rdy_o)
          block_znz_inp_d = 1'b1;
        if (vld_from_zrld) begin
          if (word_cnt_q == 'd0)
            last_o = 1'b1;
          if (znz) begin
            vld_o       = vld_from_bpc;
            data_o      = data_from_bpc;
            rdy_to_zrld = vld_from_bpc && rdy_i;
            rdy_to_bpc  = vld_from_bpc && rdy_i;
            if (vld_from_bpc && rdy_i) begin
              if (word_cnt_q == 'd0) begin
                flush_to_zrld   = 1'b1;
                state_d         = idle;
                block_znz_inp_d = 1'b0;
                block_bpc_inp_d = 1'b0;
              end else
                word_cnt_d = word_cnt_q-1;
            end
          end else begin
            vld_o       = 1'b1;
            rdy_to_zrld = rdy_i;
            data_o = 'd0;
            if (rdy_i) begin
              if (word_cnt_q == 'd0) begin
                flush_to_zrld = 1'b1;
                clr_to_bpc    = 1'b1;
                state_d       = idle;
                block_znz_inp_d = 1'b0;
                block_bpc_inp_d = 1'b0;
              end else
                word_cnt_d = word_cnt_q - 1;
            end
          end // else: !if(znz)
        end // if (vld_from_zrle)
      end // case: running
    endcase
  end // block: fsm

  always_ff @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q         <= idle;
      word_cnt_q      <= 'd0;
      block_znz_inp_q <= 1'b0;
      block_bpc_inp_q <= 1'b0;
    end else begin
      state_q         <= state_d;
      word_cnt_q      <= word_cnt_d;
      block_znz_inp_q <= block_znz_inp_d;
      block_bpc_inp_q <= block_bpc_inp_d;
    end
  end

  zrle_decoder
    zrld_i (
            .clk_i(clk_i),
            .rst_ni(rst_ni),
            .znz_i(znz_i),
            .vld_i(vld_to_zrld),
            .rdy_o(rdy_from_zrld),
            .znz_o(znz),
            .vld_o(vld_from_zrld),
            .rdy_i(rdy_to_zrld),
            .flush_i(flush_to_zrld)
            );

  bpc_decoder
    bpcd_i (
            .clk_i(clk_i),
            .rst_ni(rst_ni),
            .bpc_i(bpc_i),
            .bpc_vld_i(vld_to_bpc),
            .bpc_rdy_o(rdy_from_bpc),
            .data_o(data_from_bpc),
            .vld_o(vld_from_bpc),
            .rdy_i(rdy_to_bpc),
            .clr_i(clr_to_bpc)
            );

endmodule // ebpc_decoder
