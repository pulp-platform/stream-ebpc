// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module zrle_decoder
  import ebpc_pkg::*;
  (
   input logic              clk_i,
   input logic              rst_ni,
   input logic [DATA_W-1:0] znz_i,
   input logic              vld_i,
   output logic             rdy_o,
   output logic             znz_o,
   output logic             vld_o,
   input logic              flush_i,
   input logic              rdy_i
   );

  logic [2*DATA_W-1:0] stream_reg_d, stream_reg_q;
  logic [LOG_DATA_W:0] fill_state_d, fill_state_q;
  logic [LOG_MAX_ZRLE_LEN-1:0] zero_cnt_d, zero_cnt_q;
  typedef enum                 {empty, filling, full, zeros} state_t;
  state_t                      state_d, state_q;

  always_comb begin : fsm
    stream_reg_d = stream_reg_q;
    fill_state_d = fill_state_q;
    zero_cnt_d   = zero_cnt_q;
    state_d      = state_q;
    vld_o        = 1'b0;
    rdy_o        = 1'b0;
    znz_o        = stream_reg_q[2*DATA_W-1];
    case (state_q)
      empty : begin
        rdy_o = 1'b1;
        if (vld_i) begin
          state_d      = full;
          fill_state_d = DATA_W;
          stream_reg_d = {znz_i, {DATA_W{1'b0}}};
        end
      end
      full : begin
        vld_o = 1'b1;
        assert(zero_cnt_q == 'd0) else $warning("Assertion failed in zrle_decoder: zero_cnt_q not 0 in full state");
        if (rdy_i) begin
          if (~stream_reg_q[2*DATA_W-1]) begin
            stream_reg_d = (stream_reg_q << 1+LOG_MAX_ZRLE_LEN);
            fill_state_d = fill_state_q - 1-LOG_MAX_ZRLE_LEN;
            if (stream_reg_q[2*DATA_W-2:2*DATA_W-LOG_MAX_ZRLE_LEN-1] > 'd0) begin
              state_d    = zeros;
              zero_cnt_d = stream_reg_q[2*DATA_W-2:2*DATA_W-LOG_MAX_ZRLE_LEN-1] - 1;
            end
          end else begin
            stream_reg_d = stream_reg_q << 1;
            fill_state_d = fill_state_q - 1;
          end // else: !if(~stream_reg_q[2*DATA_W-1])
          if (fill_state_d < DATA_W) begin
            rdy_o = 1'b1;
            if (vld_i) begin
              stream_reg_d         = stream_reg_d | ({znz_i, {DATA_W{1'b0}}} >> fill_state_d);
              fill_state_d         = fill_state_d + DATA_W;
            // this is a bit ugly...
            end else if (state_d != zeros)
              state_d            = filling;
          end
          if (flush_i) begin
            // assumption: the zrle decoder cannot start reading input words from the next transmission before
            // the current one has been flushed - this needs to be ensured externally!
            stream_reg_d = 'd0;
            state_d      = empty;
            fill_state_d = 'd0;
            zero_cnt_d     = 'd0;
            rdy_o = 1'b0;
          end
        end // if (rdy_i)
      end // case: full
      filling : begin
        rdy_o = 1'b1;
        assert(zero_cnt_q == 'd0) else $warning("Assertion failed in zrle_decoder: zero_cnt_q not 0 in full state");
        if (vld_i) begin
          stream_reg_d = stream_reg_q | ({znz_i, {DATA_W{1'b0}}} >> fill_state_q);
          fill_state_d = fill_state_q + DATA_W;
          state_d = full;
        end
        if (stream_reg_q[2*DATA_W-1] || fill_state_q > LOG_MAX_ZRLE_LEN) begin
          vld_o = 1'b1;
          if (rdy_i) begin
            if (flush_i) begin
              assert (stream_reg_q[2*DATA_W-1] || (stream_reg_q[2*DATA_W-2:2*DATA_W-LOG_MAX_ZRLE_LEN-1]=='d0)) else $warning("Assertion failed in zrle_decoder: stream_reg_q's uppermost bit is zero but the runlength is not zero in state filling when flush is high!");
              rdy_o = 1'b0;
              stream_reg_d = 'd0;
              state_d      = empty;
              fill_state_d = 'd0;
            end else if (stream_reg_q[2*DATA_W-1]) begin
              stream_reg_d     = stream_reg_d << 1;
              fill_state_d     = fill_state_d-1;
              if (fill_state_d == 'd0)
                state_d = empty;
            end else begin
              stream_reg_d = stream_reg_d << (LOG_MAX_ZRLE_LEN + 1);
              fill_state_d = fill_state_d - LOG_MAX_ZRLE_LEN - 1;
              if (stream_reg_q[2*DATA_W-2:2*DATA_W-LOG_MAX_ZRLE_LEN-1] > 'd0) begin
                state_d    = zeros;
                zero_cnt_d = stream_reg_q[2*DATA_W-2:2*DATA_W-LOG_MAX_ZRLE_LEN-1] - 1;
              end else if (fill_state_d == 'd0)
                state_d = empty;
            end
          end
        end
      end // case: filling
      zeros : begin
        znz_o = 1'b0;
        vld_o = 1'b1;
        if (rdy_i) begin
          if (flush_i) begin
            assert (zero_cnt_q == 'd0) else $warning("Assertion failed in zrle_decoder: zero_cnt_q not 0 in zeros state when flush is high - likely encoding problem!");
            zero_cnt_d   = 'd0;
            state_d      = empty;
            stream_reg_d = 'd0;
          end else if (zero_cnt_q == 'd0) begin
            if (fill_state_q < DATA_W)
              state_d = filling;
            else if (fill_state_q == 'd0)
              state_d = empty;
            else
              state_d   = full;
          end else
            zero_cnt_d = zero_cnt_q - 1;
        end // if (rdy_i)
      end // case: zeros
    endcase // case (state_q)
  end


  always_ff @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q      <= empty;
      zero_cnt_q   <= 'd0;
      stream_reg_q <= 'd0;
      fill_state_q <= 'd0;
    end else begin
      state_q      <= state_d;
      zero_cnt_q   <= zero_cnt_d;
      stream_reg_q <= stream_reg_d;
      fill_state_q <= fill_state_d;
    end // else: !if(~rst_ni)
  end
endmodule // zrle_decoder

