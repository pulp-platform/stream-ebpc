// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module fifo_slice
  #(
    parameter type t = logic
    )
  (
   input  logic  clk_i,
   input  logic  rst_ni,
   input      t  din_i,
   input  logic  vld_i,
   output logic  rdy_o,
   output     t  dout_o,
   output logic  vld_o,
   input  logic  rdy_i
   );

  t data_d, data_q;
  typedef enum  {empty, full} state_t;
  state_t       state_d, state_q;

  assign dout_o = data_q;
  
  always_comb begin : fsm
    vld_o   = 1'b0;
    rdy_o = 1'b0;
    data_d  = data_q;
    state_d = state_q;

    case (state_q)
      empty: begin
        rdy_o = 1'b1;
        if (vld_i) begin
          state_d = full;
          data_d  = din_i;
        end
      end
      full: begin
        vld_o = 1'b1;
        if (rdy_i) begin
          rdy_o = 1'b1;
          if (vld_i)
            data_d = din_i;
          else
            state_d = empty;
        end
      end
      endcase // case (state_q)
  end // block: fsm

  always @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q <= empty;
      data_q  <= '0;
    end else begin
      state_q <= state_d;
      data_q  <= data_d;
    end
  end

endmodule // fifo_slice
