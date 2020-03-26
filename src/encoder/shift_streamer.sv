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

module shift_streamer
  (
   input logic                        clk_i,
   input logic                        rst_ni,
   input logic [2*DATA_W-1:0]         data_i,
   input logic [$clog2(DATA_W+1)-1:0] shift_i,
   input logic                        flush_i,
   input logic                        vld_i,
   output logic                       rdy_o,
   output logic [DATA_W-1:0]          data_o,
   output logic                       last_o,
   output logic                       vld_o,
   input logic                        rdy_i,
   output logic                       idle_o
   );

  // can probably save one flipflop by making this register one bit less wide
  logic [2*DATA_W-1:0]                    stream_reg_d, stream_reg_q;
  // this too
  logic [$clog2(DATA_W):0]                shift_cnt_d, shift_cnt_q;
  typedef enum                            {empty, filling, flush, full} state_t;
  state_t                                 st_d, st_q;

  assign data_o = stream_reg_q[2*DATA_W-1:DATA_W];

always_comb begin : fsm
  stream_reg_d = stream_reg_q;
  shift_cnt_d  = shift_cnt_q;
  st_d         = st_q;
  last_o       = 1'b0;
  rdy_o        = 1'b0;
  vld_o        = 1'b0;
  idle_o       = 1'b0;
  assert (stream_reg_q[0] == 0) else $warning("Assertion failed: Last bit of stream_reg_q should always be 0 but is 1!");
  assert (shift_i <= DATA_W) else $warning("Assertion failed: invalid shift_i in shift_streamer (can't be larger than DATA_W)");
  case (st_q)
    empty: begin
      shift_cnt_d = 'd0;
      rdy_o       = 1'b1;
      idle_o      = 1'b1;
      assert (shift_cnt_q == 'd0) else $warning("ASSERTION FAILED: shift_cnt_q is not 0 in shifter empty state!");
      assert (stream_reg_q == 'd0) else $warning("ASSERTION FAILED: stream_reg_q is not 0 in shifter empty state!");
      if (vld_i) begin
        idle_o       = 1'b0;
        stream_reg_d = stream_reg_q | (data_i>>shift_cnt_q);
        if (shift_i == DATA_W) // shift_i must never be larger than DATA_W
          st_d = full;
        else begin
          st_d = filling;
          shift_cnt_d = shift_cnt_q + shift_i;
        end
      end
    end // case: empty
    filling: begin
      rdy_o = 1'b1;
      if (vld_i) begin
        stream_reg_d = stream_reg_q |  (data_i>>shift_cnt_q);
        shift_cnt_d  = shift_cnt_q + shift_i;
        if (shift_cnt_d >= DATA_W) begin
          shift_cnt_d = shift_cnt_d - DATA_W;
          st_d        = full;
        end
      end // if (vld_i)
      if (flush_i)
        st_d = flush;
    end // case: filling
    full: begin
      vld_o  = 1'b1;
      // For this to work, the flush_i has to be applied until idle_o goes high (as it is done in ebpc_encoder)!
      last_o = flush_i && (shift_cnt_q == 'd0);
      if (rdy_i) begin
        rdy_o       = 1'b1;
        if (vld_i) begin
          shift_cnt_d    = shift_cnt_q + shift_i;
          stream_reg_d = {stream_reg_q[DATA_W-1:0], {DATA_W{1'b0}}} | (data_i>>shift_cnt_q);
          if (shift_cnt_d >= DATA_W)
            shift_cnt_d = shift_cnt_d - DATA_W;
          else
            st_d = filling;
        end else begin // if (vld_i)
          stream_reg_d      = {stream_reg_q[DATA_W-1:0], {DATA_W{1'b0}}};
            if (shift_cnt_q == 'd0)
              st_d = empty;
            else if (flush_i)
              st_d = flush;
            else
              st_d   = filling;
          end // else: !if(vld_i)
      end // if (rdy_i)
    end // case: full
    flush: begin
      assert(shift_cnt_q >0) else $warning("Assertion failed in shift_streamer - shift_cnt is 0 in flush state!");
      vld_o = 1'b1;
      last_o = 1'b1;
      if (rdy_i) begin
        stream_reg_d = {stream_reg_q[DATA_W-1:0], {DATA_W{1'b0}}};
        if (shift_cnt_q > DATA_W) begin
          shift_cnt_d = shift_cnt_q - DATA_W;
        end else begin
          shift_cnt_d = 'd0;
          st_d        = empty;
        end
      end
    end // case: flush
  endcase // case (st_q)
end // block: fsm

always @(posedge clk_i or negedge rst_ni) begin : sequential
  if (~rst_ni) begin
    st_q         <= empty;
    stream_reg_q <= '0;
    shift_cnt_q  <= '0;
  end else begin
    st_q         <= st_d;
    stream_reg_q <= stream_reg_d;
    shift_cnt_q  <= shift_cnt_d;
  end
end

endmodule // shift_streamer
