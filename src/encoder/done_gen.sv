module done_gen
  (
   input logic  clk_i,
   input logic  rst_ni,
   input logic  vld_to_znz_i,
   input logic  znz_last_i,
   input logic  bpc_idle_i,
   input logic  bpc_last_i,
   input logic  bpc_was_last_i,
   output logic blk_done_o
   );

  typedef enum  {idle, wait_for_znz_last, wait_for_znz_and_bpc_last, wait_for_znz_and_bpc_was_last, wait_for_bpc_last, wait_for_bpc_was_last} state_t;
  logic         bpc_signal_to_wait_for;
  state_t       state_d, state_q;

  always_comb begin : fsm
    state_d    = state_q;
    blk_done_o = 1'b0;
    unique case (state_q)
      idle : begin
        if (vld_to_znz_i)
          state_d = wait_for_znz_and_bpc_was_last;
      end
      wait_for_znz_and_bpc_was_last : begin
        if (~bpc_idle_i && ~znz_last_i)
          state_d = wait_for_znz_and_bpc_last;
        else if (~bpc_idle_i && znz_last_i)
          state_d = wait_for_bpc_last;
        else if (bpc_idle_i && bpc_was_last_i)
          state_d = wait_for_znz_last;
        else if (znz_last_i)
          state_d = wait_for_bpc_was_last;
      end
      wait_for_znz_and_bpc_last : begin
        if (znz_last_i && bpc_last_i) begin
          blk_done_o = 1'b1;
          state_d    = idle;
        end else if (znz_last_i)
          state_d = wait_for_bpc_last;
        else if (bpc_last_i)
          state_d = wait_for_znz_last;
      end
      wait_for_bpc_was_last : begin
        if (~bpc_idle_i)
          state_d = wait_for_bpc_last;
        else if (bpc_was_last_i) begin
          blk_done_o = 1'b1;
          state_d    = idle;
        end
      end
      wait_for_znz_last : begin
        if (znz_last_i) begin
          blk_done_o = 1'b1;
          state_d    = idle;
        end
      end
      wait_for_bpc_last : begin
        if (bpc_last_i) begin
          blk_done_o = 1'b1;
          state_d    = idle;
        end
      end
      default : begin
        state_d = idle;
      end
    endcase // unique case (state_q)
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q <= idle;
    end else begin
      state_q <= state_d;
    end
  end
endmodule
