module bpc_buffer
  import ebpc_pkg::*;
  (
   input logic               clk_i,
   input logic               rst_ni,
   input logic [DATA_W-1:0]  data_i,
   input logic               last_i,
   input logic               vld_i,
   output logic              rdy_o,
   input logic               was_last_i,
   output logic [DATA_W-1:0] data_o,
   output logic              last_o,
   output logic              vld_o,
   input logic               rdy_i,
   output logic              full_o
   );


  typedef enum               {empty, full, last} state_t;
  state_t                    state_d, state_q;
  logic [DATA_W-1:0]         data_d, data_q;

  assign data_o = data_q;

  always_comb begin : fsm
    last_o  = 1'b0;
    rdy_o   = 1'b0;
    vld_o   = 1'b0;
    data_d  = data_q;
    state_d = state_q;
    full_o = 1'b0;

    case(state_q)
      empty : begin
        // if was_last_i is high in empty state, things are really weird (or
        // we're doing all zeros)
        assert (~was_last_i) else $warning("Assertion failed in bpc_buffer in state empty - was_last_i is high!");
        rdy_o = 1'b1;
        if (vld_i) begin
          data_d = data_i;
          if (last_i)
            state_d = last;
          else
            state_d = full;
        end
      end
      full : begin
        rdy_o = rdy_i;
        full_o = 1'b1;
        if (vld_i) begin
          vld_o = 1'b1;
          last_o = was_last_i;
          if (rdy_i) begin
            data_d = data_i;
            if (last_i)
              state_d = last;
          end
        end else if (was_last_i) begin
          last_o  = 1'b1;
          vld_o   = 1'b1;
          if (rdy_i)
            state_d = empty;
          else
            state_d = last;
        end
      end // case: full
      last : begin
        // if was_last_i is high in last state, things don't really make sense...
        assert (~was_last_i) else $warning("Assertion failed in bpc_buffer in state last - was_last_i is high!");
        vld_o  = 1'b1;
        last_o = 1'b1;
        full_o = 1'b1;
        if (rdy_i) begin
          rdy_o = 1'b1;
          if (vld_i) begin
            data_d = data_i;
            if (~last_i)
              state_d = full;
          end else
            state_d = empty;
        end
      end // case: last
    endcase // case (state_q)
  end // block: fsm

  always_ff @(posedge clk_i or negedge rst_ni) begin : sequential
    if (~rst_ni) begin
      state_q <= empty;
      data_q  <= 'd0;
    end else begin
      state_q <= state_d;
      data_q  <= data_d;
    end
  end

endmodule // bpc_buffer
