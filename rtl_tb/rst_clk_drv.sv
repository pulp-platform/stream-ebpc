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
    clk_o  = 1'b0;
    rst_no = 1'b0;
    #RST_TIME rst_no = 1'b1;
  end

  always
    #(CLK_PERIOD/2) clk_o = ~clk_o;

endmodule // rst_clk_drv
