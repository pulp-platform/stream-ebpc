// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module ebpc_encoder
  import ebpc_pkg::*;
  (
   input logic               clk_i,
   input logic               rst_ni,
   input logic [DATA_W-1:0]  data_i,
   input logic               last_i,
   input logic               vld_i,
   output logic              rdy_o,
   output logic              idle_o,
   output logic [DATA_W-1:0] znz_data_o,
   output logic              znz_last_o,
   output logic              znz_vld_o,
   input logic               znz_rdy_i,
   output logic [DATA_W-1:0] bpc_data_o,
   output logic              bpc_last_o,
   output logic              bpc_vld_o,
   input logic               bpc_rdy_i,
   output logic              blk_done_o
   );


  //logic                      bpc_encoder_clk;


  logic [DATA_W-1:0]         data_reg_d, data_reg_q;
  logic                      last_d, last_q;
  logic                      flush;
  logic                      data_reg_en;
  logic [DATA_W-1:0]         data_to_bpc;
  logic                      vld_to_bpc, rdy_from_bpc;
  logic                      vld_to_znz, rdy_from_znz;
  logic                      is_one_to_znz;

  logic                      bpc_idle, bpc_waiting;
  logic                      last_from_bpc;
  logic                      znz_idle;

  logic [DATA_W-1:0]         data_from_bpc;
  logic                      vld_from_bpc, rdy_to_bpc;
  logic                      bpc_was_last;
  logic                      bpc_buf_full;


  typedef enum               {idle, running, wait_rdy, flush_st, last_bpc} state_t;
  // 0: waiting for packer
  // 1: waiting for bpc
  logic                      wait_rdy_d, wait_rdy_q;
  state_t                    state_d, state_q;


  logic [$clog2(BLOCK_SIZE)-1:0] block_cnt_d, block_cnt_q;

  initial assert(DATA_W >= MAX_SYMB_LEN) else $fatal("DATA_W must be larger or equal to MAX_SYMB_LEN!");

  assign last_d = last_i;
  assign data_reg_d = data_i;


  always_comb begin : fsm
    automatic logic rdy_to_wait_for;
    automatic logic incr_block_cnt;
    incr_block_cnt = 1'd0;
    state_d        = state_q;
    block_cnt_d    = block_cnt_q;
    wait_rdy_d     = wait_rdy_q;
    block_cnt_d    = block_cnt_q;
    data_to_bpc    = data_reg_q;
    vld_to_bpc     = 1'b0;
    is_one_to_znz  = 1'b0;
    vld_to_znz     = 1'b0;
    data_reg_en    = 1'b0;
    rdy_o          = 1'b0;
    idle_o         = 1'b0;
    flush          = 1'b0;
    bpc_was_last   = 1'b0;

    case (state_q)
      idle : begin
        rdy_o = 1'b1;
        idle_o = bpc_idle && znz_idle;
        if (vld_i) begin
          data_reg_en = 1'b1;
          state_d     = running;
        end
      end
      running : begin
        // feed to BPC
        if (data_reg_q != '0) begin
          is_one_to_znz = 1'b1;
          vld_to_bpc    = 1'b1;
          vld_to_znz    = 1'b1;
          if (rdy_from_bpc && rdy_from_znz) begin
            incr_block_cnt = 1'b1;
            if (last_q)
              state_d  = flush_st;
            else begin
              rdy_o = 1'b1;
              if (vld_i)
                data_reg_en = 1'b1;
              else
                state_d = idle;
            end
          end else if (rdy_from_bpc || rdy_from_znz) begin // if (rdy_from_bpc && rdy_from_znz)
            wait_rdy_d = rdy_from_znz;
            state_d    = wait_rdy;
          end
          //don't feed to bpc if input is 0
        end else begin // if (data_reg_q != '0)
          vld_to_znz = 1'b1;
          if (rdy_from_znz) begin
            if (last_q) begin
              // somewhat (very) nasty hack: there is no need to flush if the BPC encoder is already idle,
              // but in that case we never emitted a bpc_last_o. as a workaround, there is an intermediate
              // register at the output which keeps its value unless:
              // 1. it holds the last bpc value (which it knows from the bpc encoder telling it, i.e.,
              // last_from_bpc is 1)
              // 2. we tell it the value it is holding is the last one
              // 3. it gets a new value
              if (bpc_idle) begin
                assert (bpc_buf_full) else $warning("Assertion fail in EBPC Encoder: BPC is idle, but BPC buffer not full in running state! Are you compressing all zeros?");
                bpc_was_last = 1'b1;
                state_d = idle;
              end else begin
                // if bpc is not idle, the flush signal will have an effect and the bpc encoder will emit a last_o
                state_d = flush_st;
              end
            end else begin
              rdy_o = 1'b1;
              if (vld_i) begin
                data_reg_en    = 1'b1;
              end else begin
                state_d = idle;
              end
            end // else: !if(last_q)
          end // if (rdy_from_znz)
        end // else: !if(data_reg_q != '0)
      end // case: running
      wait_rdy : begin
        // we can only get into this state if we have a nonzero value
        is_one_to_znz = 1'b1;
        if (wait_rdy_q) begin
          // waiting for bpc rdy
          vld_to_bpc = 1'b1;
          rdy_to_wait_for = rdy_from_bpc;
        end else begin // if (wait_rdy_q)
          // wait for znz rdy
          vld_to_znz = 1'b1;
          rdy_to_wait_for = rdy_from_znz;
        end
        if (rdy_to_wait_for) begin
          incr_block_cnt = 1'b1;
          if (last_q)
            state_d = flush_st;
          else begin
              rdy_o = 1'b1;
            if (vld_i) begin
              data_reg_en = 1'b1;
              state_d     = running;
            end else
              state_d = idle;
          end
        end
      end // case: wait_rdy
      flush_st : begin
        data_to_bpc = 'd0;
        if (block_cnt_q > 0) begin
          // this part is needed to deal with data streams that have a number of
          // non-zero elements that is not a multiple of BLOCK_SIZE. In this case,
          // we feed the BPC encoder enough zero values to fill up a started
          // block. No ZNZ values are generated for these bogus values, as they
          // will be stripped out by the EBPC Decoder. Nevertheless, they must
          // be accounted for when counting the number of BPC words!
          vld_to_bpc = 1'b1;
          if (rdy_from_bpc)
            incr_block_cnt = 1'b1;
        end else if (~bpc_idle)
          // keep applying flush signal until BPC signals idle
          flush = 1'b1;
        else
          state_d = idle;
      end // case: flush_st
      default : begin
        state_d = idle;
      end
    endcase // case (state_q)
    if (incr_block_cnt)
      if (block_cnt_q == BLOCK_SIZE-1)
        block_cnt_d = 'd0;
      else
        block_cnt_d = block_cnt_q + 1;
  end // block: fsm

  always @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      data_reg_q  <= 'd0;
      last_q     <= 'd0;
      wait_rdy_q  <= 1'b0;
      state_q     <= idle;
      block_cnt_q <= 'd0;
    end else begin
      if (data_reg_en) begin
        data_reg_q  <= data_reg_d;
        last_q     <= last_d;
      end
      wait_rdy_q  <= wait_rdy_d;
      state_q     <= state_d;
      block_cnt_q <= block_cnt_d;
    end
  end // block: sequential



  bpc_encoder
    bpc_encoder_i (
                   .clk_i(clk_i),
                   .rst_ni(rst_ni),
                   .data_i(data_to_bpc),
                   .flush_i(flush),
                   .vld_i(vld_to_bpc),
                   .rdy_o(rdy_from_bpc),
                   .data_o(data_from_bpc),
                   .last_o(last_from_bpc),
                   .vld_o(vld_from_bpc),
                   .rdy_i(rdy_to_bpc),
                   .idle_o(bpc_idle),
                   .waiting_for_data_o(bpc_waiting)
                   );

  bpc_buffer
    bpc_buf_i (
               .clk_i(clk_i),
               .rst_ni(rst_ni),
               .data_i(data_from_bpc),
               .last_i(last_from_bpc),
               .vld_i(vld_from_bpc),
               .rdy_o(rdy_to_bpc),
               .was_last_i(bpc_was_last),
               .data_o(bpc_data_o),
               .last_o(bpc_last_o),
               .vld_o(bpc_vld_o),
               .rdy_i(bpc_rdy_i),
               .full_o(bpc_buf_full)
               );

  zrle
    zrle_i (
            .clk_i(clk_i),
            .rst_ni(rst_ni),
            .is_one_i(is_one_to_znz),
            .flush_i(last_q),
            .vld_i(vld_to_znz),
            .rdy_o(rdy_from_znz),
            .data_o(znz_data_o),
            .last_o(znz_last_o),
            .vld_o(znz_vld_o),
            .rdy_i(znz_rdy_i),
            .idle_o(znz_idle)
            );

  done_gen
    done_gen_i(
               .clk_i(clk_i),
               .rst_ni(rst_ni),
               .vld_to_znz_i(vld_to_znz),
               .znz_last_i(znz_last_o),
               .znz_hs_active_i(znz_vld_o && znz_rdy_i),
               .bpc_idle_i(bpc_idle),
               .bpc_last_i(bpc_last_o),
               .bpc_last_hs_active_i(bpc_vld_o && bpc_rdy_i),
               .bpc_was_last_i(bpc_was_last),
               .bpc_was_last_hs_active_i((vld_from_bpc && rdy_to_bpc) || ~bpc_buf_full),
               .blk_done_o(blk_done_o)
               );

endmodule // ebpc_encoder
