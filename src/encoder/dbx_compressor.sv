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
module dbx_compressor
  (
   input logic [0:DATA_W] [BLOCK_SIZE-2:0] dbp,
   input logic [$clog2(DATA_W+1)-1:0] dbp_cnt,
   //input logic [BLOCK_SIZE-2:0] dbp_i,
   //input logic [BLOCK_SIZE-2:0] dbx_i,
   output encoding_t            code_symb
   );

  import ebpc_pkg::*;

  localparam LOG2N = $clog2(BLOCK_SIZE);


  // compute DBXs
  logic [0:DATA_W] [BLOCK_SIZE-2:0] dbx;

  always_comb begin : dbx_assignment
    for (int i=0; i<DATA_W+1; i++) begin
      if (i<DATA_W)
        dbx[i]         = dbp[i] ^ dbp[i+1];
      else
        dbx[i] = dbp[i];
    end;
  end

  always_comb begin : encode
    automatic logic [LOG2N-1:0] cnt, pos;
    automatic logic prev_was_one, consec_ones;
    automatic logic [BLOCK_SIZE-2:0] dbp_i, dbx_i;

    //select dbp_i, dbx_i
    //dbp_i = dbp[DATA_W-dbp_cnt];
    //dbx_i = dbx[DATA_W-dbp_cnt];
    // order needs to be flipped so we can iteratively decode at the receiver
    dbp_i          = dbp[dbp_cnt];
    dbx_i          = dbx[dbp_cnt];
    // default: uncompressed
    code_symb.symb = {1'b1, dbx_i};
    code_symb.len  = N;
    code_symb.zero = 1'b0;
    if (|dbx_i == 1'b0) begin
      //if zero, we don't need to specify anything except that it's zero - ZRLE is handled outside
      code_symb.zero        = 1'b1;
      code_symb.symb        = 'X;
      code_symb.len         = symb_len_t'('X);
    end else if (|dbp_i == 1'b0) begin
      code_symb.symb      = {DBXZ_DBPNZ, {(MAX_SYMB_LEN-5){1'b0}}};
      code_symb.len       = FIVE;
    end else if (&dbx_i == 'b1) begin
      code_symb.symb    = {ALL_ONES,{(MAX_SYMB_LEN-5){1'b0}}};
      code_symb.len = FIVE;
    end else begin
      cnt          = 'd0;
      pos          = 'd0;
      prev_was_one = 1'b0;
      consec_ones = 1'b0;
      //for the single one/two consecutive ones cases we need to popcount and keep track of the position...
      for (int i=BLOCK_SIZE-2; i>=0; i--) begin
        cnt = cnt+dbx_i[i];
        if (dbx_i[i]) begin
          if (prev_was_one)
            consec_ones = 1'b1;
          else
            pos           = BLOCK_SIZE-2-i;
          prev_was_one  = 1'b1;
        end else
          prev_was_one = 1'b0;
        if (cnt >2)
          break;
      end // for (int i=0; i<BLOCK_SIZE-1; i++)
      if (cnt==1) begin
        code_symb.symb = {SINGLE_ONE_PREFIX, pos, {(MAX_SYMB_LEN-5-LOG2N){1'b0}}};
        code_symb.len  = FIVE_PLUS_LOGN;
      end else if (cnt==2 && consec_ones) begin
        code_symb.symb = {TWO_ONES_PREFIX, pos, {(MAX_SYMB_LEN-5-LOG2N){1'b0}}};
        code_symb.len  = FIVE_PLUS_LOGN;
      end
    end // else: !if(&dbx_i == 'b1)
  end // always_comb

endmodule // dbx_compressor
