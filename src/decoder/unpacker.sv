// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module unpacker
  import ebpc_pkg::*;
  (
   input logic                 clk_i,
   input logic                 rst_ni,
   input logic [DATA_W-1:0]    data_i,
   input logic                 vld_i,
   output logic                rdy_o,
   output logic [DATA_W-1:0]   data_o,
   output logic [LOG_DATA_W:0] fill_state_o,
   input logic [LOG_DATA_W:0]  len_i,
   output logic                vld_o,
   input logic                 rdy_i,
   input logic                 clr_i
   );

  logic [2*DATA_W-1:0]       stream_reg_d, stream_reg_q;
  logic [LOG_DATA_W:0]     fill_state_d, fill_state_q;
  typedef enum             {idle, full, filling}                 state_t;
  state_t                      state_d, state_q;

  assign data_o = stream_reg_q[2*DATA_W-1:DATA_W];
  assign fill_state_o = fill_state_q;

  always_comb begin : fsm
    automatic logic [LOG_DATA_W:0] shift;
    shift        = 0;
    stream_reg_d = stream_reg_q;
    fill_state_d = fill_state_q;
    rdy_o        = 1'b0;
    vld_o        = 1'b0;
    state_d = state_q;
    case (state_q)
      idle: begin
        assert(fill_state_q == 'd0) else $warning("Assertion failed in unpacker: fill_state_q not 0 in idle state");
        assert(stream_reg_q == 'd0) else $warning("Assertion failed in unpacker: stream_reg_q not 0 in idle state");
        rdy_o     = 1'b1;
        if (vld_i) begin
          // the first word will be a base word
          fill_state_d = DATA_W;
          stream_reg_d = {data_i, {DATA_W{1'b0}}};
          state_d = full;
        end
      end
      full : begin
        vld_o = 1'b1;
        if (rdy_i) begin
          shift        = len_i;
          stream_reg_d = stream_reg_q << shift;
          fill_state_d = fill_state_q - shift;

          if (fill_state_d < DATA_W) begin
            rdy_o = 1'b1;
            if (vld_i) begin
              stream_reg_d = stream_reg_d | ({data_i, {DATA_W{1'b0}}}>>fill_state_d);
              fill_state_d = fill_state_d+DATA_W;
            end else
              state_d = filling;
          end
        end // if (rdy_i)
      end // case: full
      filling : begin
        rdy_o          = 1'b1;
        if (vld_i) begin
          state_d      = full;
          stream_reg_d = stream_reg_q | ({data_i, {DATA_W{1'b0}}}>>fill_state_d);
          fill_state_d = fill_state_q + DATA_W;
        end
        if (fill_state_q != 'd0) begin
          vld_o = 1'b1;
          if (rdy_i) begin
            shift        = len_i;
            stream_reg_d = stream_reg_d << shift;
            fill_state_d = fill_state_d - shift;
          end
        end
      end
    endcase // case (state_q)
    // soft clear - we can complete an output (not input hence rdy_o=0)
    // transaction happening in this cycle, but the state is reset
    if (clr_i) begin
      rdy_o = 1'b0;
      stream_reg_d = 'd0;
      fill_state_d = 'd0;
      state_d      = idle;
    end
  end

  always_ff @(posedge(clk_i) or negedge(rst_ni)) begin : sequential
    if (~rst_ni) begin
      state_q      <= idle;
      stream_reg_q <= 'd0;
      fill_state_q <= 'd0;
    end else begin
      state_q      <= state_d;
      stream_reg_q <= stream_reg_d;
      fill_state_q <= fill_state_d;
    end
  end // block: sequential

endmodule
