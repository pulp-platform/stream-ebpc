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
module zrle
  (
   input logic               clk_i,
   input logic               rst_ni,
   input logic               is_one_i,
   input logic               flush_i,
   input logic               vld_i,
   output logic              rdy_o,
   output logic [DATA_W-1:0] data_o,
   output logic              last_o,
   output logic              vld_o,
   input logic               rdy_i,
   output logic              idle_o
   );


  typedef enum {empty, filling, full, flush, flush_zeros} state_t;
  state_t      state_d, state_q;
  logic [LOG_MAX_ZRLE_LEN-1:0] zero_cnt_d, zero_cnt_q;
  logic [2*DATA_W-1:0]         stream_reg_d, stream_reg_q;
  logic [$clog2(DATA_W):0]     shift_cnt_d, shift_cnt_q;
  assign data_o = stream_reg_q[2*DATA_W-1:DATA_W];

  always_comb begin : fsm
    state_d      = state_q;
    zero_cnt_d   = zero_cnt_q;
    stream_reg_d = stream_reg_q;
    shift_cnt_d  = shift_cnt_q;
    rdy_o        = 1'b0;
    vld_o        = 1'b0;
    idle_o       = 1'b0;
    last_o       = 1'b0;

    case (state_q)
      empty : begin
        assert (stream_reg_q == 'd0) else $display("Assertion failed @ time %t in zrle: stream_reg not empty in empty state", $time);
        assert (shift_cnt_q == 'd0) else $display("Assertion failed @ time %t in zrle: shift_cnt not 0 in empty state", $time);
        assert (zero_cnt_q == 'd0) else $display("Assertion failed @ time %t in zrle: zero_cnt not 0 in empty state", $time);
        rdy_o = 1'b1;
        idle_o = 1'b1;
        if (vld_i) begin
          idle_o = 1'b0;
          state_d = filling;
          if (is_one_i) begin
            shift_cnt_d  = shift_cnt_q + 1;
            stream_reg_d = stream_reg_q | ({1'b1, {2*DATA_W-1{1'b0}}} >> shift_cnt_q);
          end else begin
            zero_cnt_d = zero_cnt_q + 1;
          end
          if (flush_i)
            state_d = flush;
        end
      end // case: empty
      filling : begin
        rdy_o = 1'b1;
        if (vld_i) begin
          if (is_one_i) begin
            zero_cnt_d   = 'd0;
            if (zero_cnt_q != 'd0) begin
              stream_reg_d = stream_reg_q
                             | ({1'b0, LOG_MAX_ZRLE_LEN'(zero_cnt_q-1), 1'b1, {2*DATA_W-LOG_MAX_ZRLE_LEN-2{1'b0}}}
                                         >> shift_cnt_q);
              shift_cnt_d             = shift_cnt_q + 1 + 1 + LOG_MAX_ZRLE_LEN;
            end else begin
              shift_cnt_d  = shift_cnt_q + 1;
              stream_reg_d = stream_reg_q | ({1'b1, {2*DATA_W-1{1'b0}}} >> shift_cnt_q);
            end
          end else if (zero_cnt_q == MAX_ZRLE_LEN-1) begin
            stream_reg_d          = stream_reg_q |
                                    ({1'b0, LOG_MAX_ZRLE_LEN'(MAX_ZRLE_LEN-1), {2*DATA_W-LOG_MAX_ZRLE_LEN-1{1'b0}}}
                                     >> shift_cnt_q);
            shift_cnt_d = shift_cnt_q + 1 + LOG_MAX_ZRLE_LEN;
            zero_cnt_d  = 'd0;
          end else
            zero_cnt_d = zero_cnt_q + 1;
          if (flush_i) begin
            if (zero_cnt_d != 'd0)
              state_d = flush_zeros;
            else
              state_d                  = flush;
          end else if (shift_cnt_d >= DATA_W) begin
            state_d                = full;
            shift_cnt_d            = shift_cnt_d - DATA_W;
          end
        end // if (vld_i)
      end // case: filling
      flush_zeros : begin
        assert (zero_cnt_q != 0) else $display("Assertion failed in ZRLE @ time %t: zero_cnt == 0 in flush_zeros!", $time);
        zero_cnt_d = 'd0;
        stream_reg_d     = stream_reg_q
                           | ({1'b0, LOG_MAX_ZRLE_LEN'(zero_cnt_q-1), {2*DATA_W-LOG_MAX_ZRLE_LEN-1{1'b0}}}
                              >> shift_cnt_q);
        shift_cnt_d = shift_cnt_q + LOG_MAX_ZRLE_LEN + 1;
        state_d = flush;
      end
      full : begin
        assert (shift_cnt_q < DATA_W) else $display("Assertion failed in zrle: shift_cnt >= DATA_W in full state");
        assert (zero_cnt_q == 0) else $display("Assertion failed in zrle: zero_cnt is not 0 in full state (should it really?)");
        vld_o = 1'b1;
        if (rdy_i) begin
          rdy_o        = 1'b1;
          stream_reg_d = {stream_reg_q[DATA_W-1:0], {DATA_W{1'b0}}};
          state_d = filling;
          if (vld_i) begin
            if (is_one_i) begin
              shift_cnt_d                 = shift_cnt_q+1;
              stream_reg_d                = stream_reg_d | ({1'b1, {2*DATA_W-1{1'b0}}} >> shift_cnt_q);
            end else if (zero_cnt_q == MAX_ZRLE_LEN - 1) begin
              shift_cnt_d = shift_cnt_q + 1 + LOG_MAX_ZRLE_LEN;
              stream_reg_d              = stream_reg_d |
                                          ({1'b0, LOG_MAX_ZRLE_LEN'(MAX_ZRLE_LEN-1), {2*DATA_W-LOG_MAX_ZRLE_LEN-1{1'b0}}}
                                           >> shift_cnt_q);
            end else
              zero_cnt_d = zero_cnt_q + 1;
            if (flush_i) begin
              if (zero_cnt_d != 'd0)
                state_d                = flush_zeros;
              else
                state_d = flush;
            end else if (shift_cnt_d >= DATA_W) begin
                state_d                = full;
                shift_cnt_d            = shift_cnt_d - DATA_W;
            end
          end else begin // if (vld_i)
            if (shift_cnt_q == 'd0)
              state_d = empty;
            else
              state_d = filling;
          end // else: !if(vld_i)
        end
      end // case: full
      flush : begin
        vld_o = 1'b1;
        if (shift_cnt_q <= DATA_W)
          last_o = 1'b1;
        if (rdy_i) begin
          stream_reg_d = {stream_reg_q[DATA_W-1:0], {DATA_W{1'b0}}};
          if (shift_cnt_q > DATA_W)
            shift_cnt_d = shift_cnt_q-DATA_W;
          else begin
            shift_cnt_d = 'd0;
            state_d     = empty;
          end
      end
      end // case: flush
    endcase // case (state_q)
  end

always @(posedge clk_i or negedge rst_ni) begin
  if (~rst_ni) begin
    state_q         <= empty;
    zero_cnt_q      <= 'd0;
    stream_reg_q    <= 'd0;
    shift_cnt_q     <= 'd0;
    //last_was_zero_q <= 1'b0;
  end else begin
    state_q      <= state_d;
    zero_cnt_q   <= zero_cnt_d;
    stream_reg_q <= stream_reg_d;
    shift_cnt_q  <= shift_cnt_d;
    //last_was_zero_q <= last_was_zero_d;
  end
end

endmodule // zrle
