// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module expander
  import ebpc_pkg::*;
  (
   input logic [DATA_W-1:0]      data_i,
   output logic [LOG_DATA_W-1:0] zeros_o,
   output symb_len_t             len_o,
   output logic [BLOCK_SIZE-2:0] dbx_dbp_o,
   output logic                  is_dbp_o
   );

  // thanks emacs for messing up the indentation
  always_comb begin
    zeros_o   = 'd0;
    is_dbp_o  = 1'b0;
    len_o     = N;
    dbx_dbp_o = 'd0;
    if (data_i[DATA_W-1] == 1'b1) begin
      dbx_dbp_o                                                            = data_i[DATA_W-2 -: BLOCK_SIZE-1];
    end else if (data_i[DATA_W-1:DATA_W-2] == 2'b01) begin
      dbx_dbp_o                                                          = 'd0;
      len_o                                                              = TWO;
    end else if (data_i[DATA_W-1:DATA_W-3] == 3'b001) begin
      dbx_dbp_o                                                        = 'd0;
      len_o                                                            = THREE_PLUS_LOGM;
      zeros_o                                                          = data_i[DATA_W-4 -: LOG_DATA_W] + 1;
    end else if (data_i[DATA_W-1:DATA_W-5] == 5'b00000) begin
      dbx_dbp_o                                                      = {BLOCK_SIZE-1{1'b1}};
             len_o                                                   = FIVE;
           end else if (data_i[DATA_W-1:DATA_W-5] == 5'b00001) begin
             dbx_dbp_o                                             = {BLOCK_SIZE-1{1'b0}};
                    len_o                                          = FIVE;
                    is_dbp_o                                       = 1'b1;
                  end else if (data_i[DATA_W-1:DATA_W-5] == 5'b00010) begin
                    dbx_dbp_o                                    = ({2'b11, {BLOCK_SIZE-3{1'b0}}} >> data_i[DATA_W - 6 -: $clog2(BLOCK_SIZE-1)]);
                    len_o                                        = FIVE_PLUS_LOGN;
                  end else if (data_i[DATA_W-1:DATA_W-5] == 5'b00011) begin
                    dbx_dbp_o                                  = {BLOCK_SIZE-1{1'b0}} | ({1'b1, {BLOCK_SIZE-2{1'b0}}} >> data_i[DATA_W - 6 -: $clog2(BLOCK_SIZE-1)]);
                           len_o                               = FIVE_PLUS_LOGN;
                         end
  end // always_comb
endmodule // expander
