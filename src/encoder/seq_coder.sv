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

module seq_coder
  (
   input logic               clk_i,
   input logic               rst_ni,
   input dbp_block_t         dbp_block_i,
   input logic               vld_i,
   output logic              rdy_o,
   // data out interface
   output logic [DATA_W-1:0] data_o,
   output logic              vld_o,
   input logic               rdy_i,
   output logic              idle_o
   );


  function logic[$clog2(BLOCK_SIZE+1)-1:0] get_shift(symb_len_t s);
    if (s == FIVE)
      return 5;
    else if (s == FIVE_PLUS_LOGN)
      return 5 + $clog2(BLOCK_SIZE-1);
    else
      return BLOCK_SIZE;
  endfunction //

  //dbp/dbx output from FIFO slice
  dbp_block_t                  dbp_block_from_fifo;

  //dbx encoder result
  encoding_t                 code_symb;

  //fsm
  typedef enum               {idle, fill, flush_st} state_t;
  state_t                    state_d, state_q;
  // counter to keep track on which dbx we're working
  logic [$clog2(DATA_W+1)-1:0] dbx_cnt_d, dbx_cnt_q;
  // keep track of running zeros
  logic [$clog2(DATA_W+1)-1:0] zero_cnt_d, zero_cnt_q;
  logic                        vld_from_slice, rdy_to_slice;
  logic                        last_was_zero_d, last_was_zero_q;
  logic                        flush;
  logic [DATA_W-1:0]           data;
  logic [$clog2(DATA_W+1)-1:0] shift;
  logic                        shift_vld, shift_rdy;
  logic                          streamer_idle;

  initial begin
    assert (!(BLOCK_SIZE > DATA_W)) else $error("Error: BLOCK_SIZE can't be larger than DATA_W in seq_coder");
  end

  always_comb begin : fsm
    automatic logic [$clog2(DATA_W)-1:0] zeros;
    automatic logic write_zero = 1'b0, stall = 1'b0;
    zeros                      = zero_cnt_q;
    state_d                    = state_q;
    dbx_cnt_d                  = dbx_cnt_q;
    zero_cnt_d                 = zero_cnt_q;
    last_was_zero_d            = last_was_zero_q;
    flush                      = 1'b0;
    rdy_to_slice               = 1'b0;
    data                       = 'd0;
    shift_vld                  = 1'b0;
    shift                      = 'd0;
    stall                      = 1'b0;
    idle_o                     = 1'b0;

    case (state_q)
      idle: begin
        assert (zero_cnt_q == 0) else $display("Assertion failed in seq_coder @ time %t: zero_cnt_q not 0 in state idle", $time);
        assert (dbx_cnt_q == DATA_W) else $display("Assertion failed in seq_coder @ time %t: dbx_cnt_q not DATA_W in state idle", $time);
        zero_cnt_d = 'd0;
        dbx_cnt_d  = DATA_W;
        idle_o     = streamer_idle;
        if (vld_from_slice) begin
          idle_o    = 1'b0;
          shift     = DATA_W;
          data      = dbp_block_from_fifo.base;
          shift_vld = 1'b1;
          if (shift_rdy)
            state_d = fill;
        end
      end
      fill: begin
        assert (vld_from_slice == 1'b1) else $display("Assertion failed in seq_coder @ time %t: vld_from_slice is not high in state 'fill'!", $time);
        //if (code_symb.len == N)
        shift_vld       = 1'b1;
        if (code_symb.zero) begin
          if (dbx_cnt_q != 'd0) begin
            zero_cnt_d      = zero_cnt_q+1;
            dbx_cnt_d       = dbx_cnt_q-1;
            last_was_zero_d = 1'b1;
            shift_vld       = 1'b0;
          end else begin
            zeros      += 1;
            write_zero = 1'b1;
          end
        end else begin // if (code_symb.zero)
          if (last_was_zero_q) begin// if (code_symb.zero)
            write_zero = 1'b1;
            stall = 1'b1;
          end else begin
            shift         = get_shift(code_symb.len);
            data          = {code_symb.symb, {(DATA_W-MAX_SYMB_LEN){1'b0}}};
          end
        end // else: !if(code_symb.zero)
        if (write_zero) begin
          if (zeros == 'd1) begin
            shift = 2;
            data  = {2'b01, {DATA_W-2{1'b0}}};
          end else begin
            shift = 3+$clog2(DATA_W);
            data  = {3'b001, $clog2(DATA_W)'(zeros-2), {DATA_W-3-$clog2(DATA_W){1'b0}}};
          end
        end
        if (shift_rdy) begin
          if (write_zero) begin
            last_was_zero_d = 1'b0;
            zero_cnt_d = 'd0;
          end // if (write_zero)
          if (~stall) begin
            if (dbx_cnt_q != 'd0) begin
              dbx_cnt_d = dbx_cnt_q-1;
            end else begin
              if (dbp_block_from_fifo.flush)
                flush      = 1'b1;
              rdy_to_slice = 1'b1;
              state_d      = idle;
              dbx_cnt_d    = DATA_W;
            end
          end // if (~stall)
        end // if (shift_rdy)
      end // case: fill
      default:
        state_d = idle;
    endcase // case (state_q)
  end // block: fsm



  always @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q         <= idle;
      dbx_cnt_q       <= DATA_W;
      zero_cnt_q      <= 'd0;
      last_was_zero_q <= 1'b0;
    end else begin
      state_q         <= state_d;
      dbx_cnt_q       <= dbx_cnt_d;
      zero_cnt_q      <= zero_cnt_d;
      last_was_zero_q <= last_was_zero_d;
    end // else: !if(~rst_ni)
  end // block: sequential


  fifo_slice #(
               .t(dbp_block_t)
               )
  slice_i (
           .clk_i(clk_i),
           .rst_ni(rst_ni),
           .din_i(dbp_block_i),
           .vld_i(vld_i),
           .rdy_o(rdy_o),
           .dout_o(dbp_block_from_fifo),
           .vld_o(vld_from_slice),
           .rdy_i(rdy_to_slice)
           );



  dbx_compressor
    compressor_i (
                  .dbp(dbp_block_from_fifo.dbp),
                  .dbp_cnt(dbx_cnt_q),
                  .code_symb(code_symb)
                  );

  shift_streamer
    streamer_i (
                .clk_i(clk_i),
                .rst_ni(rst_ni),
                .data_i({data,{DATA_W{1'b0}}}),
                .shift_i(shift),
                .flush_i(flush),
                .vld_i(shift_vld),
                .rdy_o(shift_rdy),
                .data_o(data_o),
                .vld_o(vld_o),
                .rdy_i(rdy_i),
                .idle_o(streamer_idle)
                );

endmodule : seq_coder
