// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module delta_reverse
  import ebpc_pkg::*;
  (
   input logic                      clk_i,
   input logic                      rst_ni,
   input dbp_block_t                data_i,
   input logic                      vld_i,
   output logic                     rdy_o,
   output logic signed [DATA_W-1:0] data_o,
   output logic                     vld_o,
   input logic                      rdy_i,
   input logic                      clr_i
   );

  logic signed [DATA_W:0]    diffs [0:BLOCK_SIZE-2];
  typedef enum               {base, stream} state_t;
  state_t                    state_d, state_q;
  logic signed [DATA_W-1:0]  acc_reg_d, acc_reg_q;
  logic [$clog2(BLOCK_SIZE-1)-1:0] diff_idx_d, diff_idx_q;

  always_comb begin
    for (int i=0; i<BLOCK_SIZE-1; i++)
      for (int j=0; j<DATA_W+1; j++)
        diffs[i][j] = data_i.dbp[j][BLOCK_SIZE-2-i];
  end


  always_comb begin : fsm
    state_d    = state_q;
    acc_reg_d  = acc_reg_q;
    rdy_o      = 1'b0;
    vld_o      = 1'b0;
    diff_idx_d = diff_idx_q;
    data_o     = acc_reg_q;

    case (state_q)
      base : begin
        assert(diff_idx_q == 0) else $warning("Assertion failed in delta_reverse: diff_idx_q not 0 in idle state!");
        diff_idx_d = 'd0;
        data_o    = data_i.base;
        if (vld_i) begin
          acc_reg_d = data_i.base + diffs[diff_idx_q];
          vld_o     = 1'b1;
          if (rdy_i) begin
            state_d    = stream;
            diff_idx_d = diff_idx_q + 'd1;
          end
        end
      end
      stream : begin
        assert (vld_i == 1'b1) else $warning("Assertion failed in delta_reverse: rdy_i not 1 in stream state!");
        vld_o = 1'b1;
        if (rdy_i) begin
          acc_reg_d      = acc_reg_q + diffs[diff_idx_q];
          if (diff_idx_q == 'd0) begin
            rdy_o = 1'b1;
            state_d      = base;
          end else if (diff_idx_q < BLOCK_SIZE-2)
            diff_idx_d = diff_idx_q + 'd1;
          else
            diff_idx_d = 'd0;
        end
      end // case: stream
    endcase // case (state_q)
    if (clr_i) begin
      state_d    = base;
      acc_reg_d  = 'd0;
      diff_idx_d = 'd0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q    <= base;
      acc_reg_q  <= 'd0;
      diff_idx_q <= 'd0;
    end else begin
      state_q    <= state_d;
      acc_reg_q  <= acc_reg_d;
      diff_idx_q <= diff_idx_d;
    end
  end // always_ff @ (posedge clk_i or negedge rst_ni)
endmodule // delta_reverse
