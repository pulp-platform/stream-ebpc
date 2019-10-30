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
