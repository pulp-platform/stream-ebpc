// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`timescale 1ps/1fs
module rst_clk_drv
  #(
    parameter time CLK_PERIOD = 10ns,
    parameter time RST_TIME = 57ns
    )
  (
   output logic clk_o,
   output logic rst_no
   );

  initial begin
    clk_o  = 1'b1;
    rst_no = 1'b0;
    #RST_TIME rst_no = 1'b1;
  end

  always
    #(CLK_PERIOD/2) clk_o = ~clk_o;

endmodule // rst_clk_drv
