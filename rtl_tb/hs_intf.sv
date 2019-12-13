// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

interface   HandshakeIf_t
  #(
    parameter int unsigned DATA_W = 8
    )
  (
   input logic clk_i
   );


  logic [DATA_W-1:0]                    data;
  logic                                 last;
  logic                                 vld; //
  logic                                 rdy;
 // these guys are super useless because we have to use virtual interfaces with the driver classes...
  modport in(
             input data, last, vld,
             output rdy
             );

  modport out(
              output data, last, vld,
              input rdy
              );

endinterface // HandshakeIf_t
