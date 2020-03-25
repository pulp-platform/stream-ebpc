// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module symbol_decoder
  import ebpc_pkg::*;
  (
   input logic                          clk_i,
   input logic                          rst_ni,
   input logic [DATA_W-1:0]             data_i,
   input logic [LOG_DATA_W:0]           unpacker_fill_state_i,
   output logic [LOG_DATA_W:0]          len_o,
   input logic                          data_vld_i,
   output logic                         data_rdy_o,
   output logic [DATA_W-1:0]            data_o,
   //output logic                         base_o,
   output logic                         push_o,
   output logic                         vld_o,
   input logic                          rdy_i,
   input logic                          clr_i
   );

  logic [LOG_DATA_W:0]                dbx_cnt_d, dbx_cnt_q;
  logic [LOG_DATA_W-1:0]                  zero_cnt_d, zero_cnt_q;

  logic [BLOCK_SIZE-2:0]                expander_out;
  logic                                 expander_is_dbp;
  logic [LOG_DATA_W:0]                expander_zeros;
  symb_len_t                            expander_len;

  logic [BLOCK_SIZE-2:0]                dbp_reg_d, dbp_reg_q;

  typedef enum                          {idle, dbx_decode, zeros} state_t;
  state_t                               state_d, state_q;

  function logic [$clog2(DATA_W+1)-1:0] get_shift(symb_len_t s);
    if (s == TWO)
      return 2;
    else if (s == THREE_PLUS_LOGM)
      return 3 + $clog2(DATA_W);
    else if (s == FIVE)
      return 5;
    else if (s == FIVE_PLUS_LOGN)
      return 5 + $clog2(BLOCK_SIZE-1);
    else
      return BLOCK_SIZE;
  endfunction //

  //assign data_o = base ? data_i : {dbp_reg_q, {DATA_W-BLOCK_SIZE+1{1'b0}}};

  always_comb begin : fsm
    data_rdy_o = 1'b0;
    vld_o      = 1'b0;
    state_d    = state_q;
    dbx_cnt_d  = dbx_cnt_q;
    zero_cnt_d = zero_cnt_q;
    dbp_reg_d  = dbp_reg_q;
    len_o      = get_shift(expander_len);
    push_o     = 1'b0;
    data_o = {dbp_reg_q ^ expander_out, {DATA_W-BLOCK_SIZE+1{1'b0}}};
    case (state_q)
      idle : begin
        data_o = data_i;
        len_o = DATA_W;
        if (unpacker_fill_state_i >= DATA_W && rdy_i) begin
          data_rdy_o = 1'b1;
          if (data_vld_i) begin
            push_o = 1'b1;
            state_d = dbx_decode;
          end
        end
      end
      dbx_decode : begin
        assert (rdy_i) else $warning("Assertion failed in symbol_decoder - rdy_i not high in dbx_decode state!", $time);
        if (unpacker_fill_state_i >= get_shift(expander_len)) begin
          data_rdy_o = 1'b1;
          if (data_vld_i) begin
            dbx_cnt_d = dbx_cnt_q + 1;
            push_o    = 1'b1;
            if (expander_is_dbp) begin
              dbp_reg_d = expander_out;
              data_o = expander_out;
            end else
              dbp_reg_d   = expander_out ^ dbp_reg_q;
            if (|expander_zeros) begin
              assert(dbx_cnt_q != DATA_W) else $warning("Assertion failed in symbol_decoder - dbx_cnt is DATA_W and expander_zeros !=0 in dbx_decode state!", $time);
              zero_cnt_d  = expander_zeros - 1;
              state_d     = zeros;
              data_rdy_o  = 1'b0;
            end // else: !if(dbx_cnt_q == 0)
            if (dbx_cnt_q == DATA_W) begin
              dbp_reg_d = 'd0;
              state_d   = idle;
              dbx_cnt_d = 'd0;
              vld_o     = 1'b1;
            //state_d     = last;
            end
          end // else: !if(dbx_cnt_q == 0)
        end // if (unpacker_fill_state_i >= expander_len)
      end // case: dbx_decode
      zeros : begin
        push_o    = 1'b1;
        dbx_cnt_d = dbx_cnt_q + 1;
        assert (data_vld_i) else $warning("Assertion failed in symbol_decoder - data_vld_i not 1 in zeros state!", $time);
        assert (rdy_i) else $warning("Assertion failed in symbol_decoder - rdy_i not high in zeros state!", $time);
        if (zero_cnt_q == 'd0) begin
          data_rdy_o    = 1'b1;
          if (dbx_cnt_q == DATA_W) begin
            //state_d     = last;
            dbp_reg_d = 'd0;
            state_d   = idle;
            dbx_cnt_d = 'd0;
            vld_o = 1'b1;
          end else
            state_d = dbx_decode;
        end else begin // case: zeros
          assert(dbx_cnt_q != DATA_W) else $warning("Assertion failed in symbol_decoder - dbx_cnt is DATA_W and zero_cnt !=0 ! in zeros state");
          zero_cnt_d = zero_cnt_q-1;
        end // else: !if(zero_cnt_q == 'd0)
      end // case: zeros
    endcase // case (state_qp)
    // soft clear - reset state in next cycle
    if (clr_i) begin
      dbx_cnt_d   = 'd0;
      zero_cnt_d  = 'd0;
      dbp_reg_d   = 'd0;
      state_d     = idle;
    end
  end // block: fsm_in

  expander
    expander_i(
               .data_i(data_i),
               .zeros_o(expander_zeros),
               .len_o(expander_len),
               .dbx_dbp_o(expander_out),
               .is_dbp_o(expander_is_dbp)
               );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      dbx_cnt_q   <= 'd0;
      zero_cnt_q  <= 'd0;
      dbp_reg_q   <= 'd0;
      state_q     <= idle;
    end else begin
      dbx_cnt_q  <= dbx_cnt_d;
      zero_cnt_q <= zero_cnt_d;
      dbp_reg_q  <= dbp_reg_d;
      state_q    <= state_d;
    end
  end

endmodule // symbol_decoder
