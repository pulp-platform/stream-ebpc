// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module buffer
  import ebpc_pkg::*;
  (
   input logic clk_i,
   input logic rst_ni,
   input logic [DATA_W-1:0] data_i,
   //input logic base_i,
   input logic push_i,
   input logic vld_i,
   output logic rdy_o,
   output dbp_block_t data_o,
   output logic vld_o,
   input logic rdy_i,
   input logic clr_i
   );

  typedef enum {wait_base, filling, full} state_t;
  state_t      state_d, state_q;
  logic [DATA_W-1:0] base_d, base_q;
  // dbps are shifted in from [DATA_W] to [0]
  logic [BLOCK_SIZE-2:0] shift_reg_d [DATA_W:0], shift_reg_q [DATA_W:0];
  logic                        vld_to_slice, rdy_from_slice;

  dbp_block_t                  dbp_block_to_fifo;


  always_comb begin : dbp_block_assign
    dbp_block_to_fifo.base = base_q;
    // flush signal not used
    dbp_block_to_fifo.flush = 1'b0;
    for (int i=0; i<DATA_W+1; i++)
      dbp_block_to_fifo.dbp[i] = shift_reg_q[i];
  end

  always_comb begin : fsm
    rdy_o        = 1'b0;
    shift_reg_d  = shift_reg_q;
    vld_to_slice = 1'b0;
    state_d      = state_q;
    base_d = base_q;

    case (state_q)
      wait_base : begin
        rdy_o = 1'b1;
        if (push_i) begin
          base_d  = data_i;
          state_d = filling;
        end
      end
      filling : begin
        rdy_o = 1'b1;
        if (push_i) begin
          shift_reg_d[DATA_W] = data_i[DATA_W-1:DATA_W-BLOCK_SIZE+1];
          for (int i=DATA_W-1; i>=0; i--)
            shift_reg_d[i] = shift_reg_q[i+1];
        end
        // if vld_i is high, the shift reg is full - we allow
        // the handshake to happen also in a cycle where no push is performed
        if (vld_i) begin
          state_d = full;
        end
      end // case: filling
      full : begin
        vld_to_slice = 1'b1;
        if (rdy_from_slice) begin
          rdy_o = 1'b1;
          if (push_i) begin
            base_d  = data_i;
            state_d = filling;
            // TODO: what if vld_i is high here - this should never happen but...
          end else
            state_d = wait_base;
        end
      end
    endcase // case (state_q)
    // soft clear - reset state
    if (clr_i) begin
      for (int i=0; i<DATA_W+1; i++)
        shift_reg_d[i] = 'd0;
      base_d           = 'd0;
      state_d          = wait_base;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      for (int i=0; i<DATA_W+1; i++)
        shift_reg_q[i] <= 'd0;
      base_q           <= 'd0;
      state_q          <= wait_base;
    end else begin
      shift_reg_q <= shift_reg_d;
      base_q      <= base_d;
      state_q <= state_d;
    end
  end // always_ff @ (posedge clk_i or negedge rst_ni)

  fifo_slice #(.t(dbp_block_t))
    slice_i (
             .clk_i(clk_i),
             .rst_ni(rst_ni),
             .din_i(dbp_block_to_fifo),
             .vld_i(vld_to_slice),
             .rdy_o(rdy_from_slice),
             .dout_o(data_o),
             .vld_o(vld_o),
             .rdy_i(rdy_i)
             );

endmodule // buffer
