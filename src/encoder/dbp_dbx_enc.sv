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
module dbp_dbx_enc
  (
   input logic                     clk_i,
   input logic                     rst_ni,
   //input data interface - one word at a time
   input logic signed [DATA_W-1:0] data_i,
   input logic                     flush_i,
   input logic                     vld_i,
   output logic                    rdy_o,
   //output data interface - (BLOCK_SIZE-1)*(DATA_W+1) DBPs plus the base word
   output dbp_block_t              dbp_block_o,
   output logic                    vld_o,
   input logic                     rdy_i,
   output logic                    flush_o,
   output logic                    idle_o
);

  logic signed [DATA_W:0]                 diffs_d [0:BLOCK_SIZE-1], diffs_q [0:BLOCK_SIZE-1];
  logic signed [DATA_W-1:0]               last_item_d, last_item_q;

  // fsm
  typedef enum                     {idle, fill, dbx_comp, wait_out} state_t;
  state_t                          state_d, state_q;
  logic [$clog2(BLOCK_SIZE)-1:0]   fill_cnt_d, fill_cnt_q;
  logic                            shift;
  logic [0:DATA_W] [BLOCK_SIZE-2:0] dbp;

  always_comb begin : dbp_assignment
    for (int i=0; i<BLOCK_SIZE-1; i++) begin
      for (int j=0; j<DATA_W+1; j++) begin
        // DBP 0 is the MSB dbp!
        dbp[j][BLOCK_SIZE-2-i] = diffs_q[BLOCK_SIZE-2-i][DATA_W-j];
      end
    end
  end

  assign dbp_block_o.dbp = dbp;
  assign dbp_block_o.base = diffs_q[BLOCK_SIZE-1][DATA_W-1:0];

  always_comb begin : fsm
    diffs_d     = diffs_q;
    state_d     = state_q;
    fill_cnt_d  = fill_cnt_q;
    rdy_o       = 1'b0;
    vld_o       = 1'b0;
    last_item_d = last_item_q;
    shift       = 1'b0;
    flush_o     = 1'b0;
    idle_o      = 1'b0;

    case (state_q)
      idle: begin
        assert (fill_cnt_q==BLOCK_SIZE-1) else $display("Assertion fail @ time %t: fill_cnt_q is not BLOCK_SIZE-1 in idle state!", $time);
        fill_cnt_d  = BLOCK_SIZE-1;
        rdy_o       = 1'b1;
        last_item_d = 'd0;
        idle_o      = 1'b1;
        flush_o = flush_i;
        if (vld_i) begin
          idle_o      = 1'b0;
          last_item_d = data_i;
          flush_o     = 1'b0;
          shift       = 1'b1;
          state_d     = fill;
          fill_cnt_d  = fill_cnt_q-1;
        end
      end // case: idle
      fill: begin
        rdy_o = 1'b1;
        if (vld_i) begin
          shift          = 1'b1;
          last_item_d    = data_i;
          fill_cnt_d     = fill_cnt_q-1;
          if (fill_cnt_q == 0) begin
            last_item_d = 'd0;
            state_d     = wait_out;
          end
        end
      end
      wait_out: begin
        vld_o = 1'b1;
        if (rdy_i) begin
          rdy_o = 1'b1;
          if (vld_i) begin
            shift       = 1'b1;
            last_item_d = data_i;
            fill_cnt_d  = fill_cnt_q-1;
            state_d     = fill;
          end else
            state_d = idle;
        end
      end // case: wait_out
      default:
        state_d = idle;
    endcase // case (state_d)
    //if (shift) begin
      diffs_d[0] = data_i - last_item_q;
      for (int i=1; i<BLOCK_SIZE; i++)
        diffs_d[i] = diffs_q[i-1];
  //  end
  end // block: fsm


  always @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      for (int i=0; i<BLOCK_SIZE; i++)
        diffs_q[i] <= 'd0;
      state_q      <= idle;
      fill_cnt_q   <= BLOCK_SIZE-1;
      last_item_q  <= 'd0;
    end else begin
      for (int i=0; i<BLOCK_SIZE; i++)
        if (shift)
          diffs_q[i] <= diffs_d[i];
      state_q         <= state_d;
      fill_cnt_q      <= fill_cnt_d;
      last_item_q     <= last_item_d;
    end
  end // block: sequential

endmodule : dbp_dbx_enc
