// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


package ebpc_pkg;
//  let maximum(a,b) = a > b ? a : b;
  localparam logic [5-1:0] ALL_ONES = 5'b00000;
  localparam logic [5-1:0] DBXZ_DBPNZ = 5'b00001;
  localparam logic [5-1:0] TWO_ONES_PREFIX = 5'b00010;
  localparam logic [5-1:0] SINGLE_ONE_PREFIX = 5'b00011;

  // how many bits do we need to specify how long the uncompressed transmission will be?
  parameter int unsigned   LOG_MAX_WORDS = 24;

  // MAX_ZRLE_LEN: maximum zero runlength to encode
  parameter int unsigned   LOG_MAX_ZRLE_LEN = 4;
  parameter int unsigned   MAX_ZRLE_LEN = 2**LOG_MAX_ZRLE_LEN;
  parameter int unsigned   LOG_DATA_W = 3; // 2^3=8, 2^4=16, 2^5=32
  parameter int unsigned   DATA_W = 2**LOG_DATA_W;
  parameter int unsigned   BLOCK_SIZE = 8;
  // maximum length of an encoded symbol according to table 3.a)
  parameter int unsigned   MAX_SYMB_LEN = BLOCK_SIZE > 3+$clog2(DATA_W) ? (BLOCK_SIZE > 5+$clog2(BLOCK_SIZE) ? BLOCK_SIZE : 5+$clog2(BLOCK_SIZE)): (3+$clog2(DATA_W)> 5+$clog2(BLOCK_SIZE)? 3+$clog2(DATA_W) : 5+$clog2(BLOCK_SIZE));

  typedef enum             {
                            TWO,
                            THREE_PLUS_LOGM,
                            FIVE,
                            FIVE_PLUS_LOGN,
                            N
                            } symb_len_t;


  typedef struct packed {
    logic [0:DATA_W] [BLOCK_SIZE-2:0] dbp;
    logic [DATA_W-1:0]                base;
  } dbp_block_t;

  typedef struct packed {
    logic [MAX_SYMB_LEN-1:0] symb;
    symb_len_t            len;
    logic                 zero;
  } encoding_t;

endpackage // ebpc_pkg
