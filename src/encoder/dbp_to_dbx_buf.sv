// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module dpb_to_dbx_buf
  #(
    parameter int unsigned BLOCK_SIZE=8,
    parameter int unsigned DATA_W=32
    )
  (
   input logic                   clk_i,
   input logic                   rst_ni,
   // input interface
   input logic [BLOCK_SIZE-2:0]  dbp_i [0:DATA_W],
   input logic [DATA_W-1:0]      base_i,
   input logic                   vld_i,
   output logic                  rdy_o,
   //output interface - instead of rdy, call it done because the output is processed in-place
   output logic [BLOCK_SIZE-2:0] dbp_o [0:DATA_W],
   output logic [BLOCK_SIZE-2:0] dbx_o [0:DATA_W],
   output logic [DATA_W-1:0]     base_o,
   output logic                  vld_o,
   input logic                   rdy_i
   );

  logic [BLOCK_SIZE-2:0]         dbp_d[0:DATA_W], dbp_q[0:DATA_W];
  logic [DATA_W-1:0]             base_d, base_q;

  //fsm
  typedef enum                   {idle, wait_out} state_t;
  state_t                        state_d, state_q;


  always_comb begin : dbx_assignment
    dbx_o[DATA_W] = dbp_q[DATA_W];
    for (int i=0; i<DATA_W; i++)
      dbx_o[i] = dbp_q[i]^dbp_q[i+1];
  end
  assign dbp_o = dbp_q;
  always_comb begin : fsm
    dbp_d   = dbp_q;
    state_d = state_q;
    base_d = base_q;
    rdy_o   = 1'b0;
    vld_o   = 1'b0;
    case (state_q)
      idle: begin
        if (vld_i) begin
          dbp_d   = dbp_i;
          base_d  = base_i;
          state_d = wait_out;
        end
      end
      wait_out: begin
        vld_o = 1'b1;
        if (rdy_i) begin
          rdy_o = 1'b1;
          if (vld_i)
            dbp_d = dbp_i;
          else
            state_d = idle;
        end
      end
      default:
        state_d = idle;
    endcase // case (state_q)
  end // block: fsm

  always @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      for (int i=0; i<=DATA_W; i++)
        dbp_q[i] = 'd0;
      base_q     = 'd0;
      state_q    = idle;
    end else begin
      for (int i=0; i<=DATA_W; i++)
        dbp_q[i] = dbp_d[i];
      base_q     = base_d;
      state_q    = state_d;
    end // else: !if(~rst_ni)
  end // block: sequential

endmodule : dpb_to_dbx_buf
