// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module ebpc_decoder_tb;
  import hs_drv_pkg::*;
  import ebpc_pkg::*;
  
  localparam int unsigned DATA_W = 8;
  localparam int unsigned MIN_IN_WAIT_CYCLES = 0;
  localparam int unsigned MAX_IN_WAIT_CYCLES = 0;
  localparam int unsigned MIN_OUT_WAIT_CYCLES = 0;
  localparam int unsigned MAX_OUT_WAIT_CYCLES = 0;

  localparam string       NUM_WORDS_STIM_FILE = "../../simvectors/decoder/vgg16/vgg16_f0.01_bs1_nb4_ww8_num_words_input.stim";
  localparam string       BPC_STIM_FILE = "../../simvectors/decoder/vgg16/vgg16_f0.01_bs1_nb4_ww8_bpc_input.stim";
  localparam string       ZNZ_STIM_FILE = "../../simvectors/decoder/vgg16/vgg16_f0.01_bs1_nb4_ww8_znz_input.stim";

  localparam string       DATA_EXPVAL_FILE = "../../simvectors/decoder/vgg16/vgg16_f0.01_bs1_nb4_ww8_data_output.expresp";

  localparam time         CLK_PERIOD = 2.5ns;
  localparam time         RST_TIME = 10.27*CLK_PERIOD;
  localparam time         TA = 0.2*CLK_PERIOD;
  localparam time         TT = 0.8*CLK_PERIOD;

  logic                   clk;
  logic                   rst_n;

  string                  in_files[0:2];
  string                  in_names[0:2];
  string                  out_files[0:0];


  int                     in_wait [0:1][0:2];
  int                     out_wait [0:1][0:0];

  HandshakeIf_t           #(.DATA_W(LOG_MAX_WORDS)) num_words_if(.clk_i(clk));
  HandshakeIf_t           #(.DATA_W(DATA_W)) bpc_if(.clk_i(clk));
  HandshakeIf_t           #(.DATA_W(DATA_W)) znz_if(.clk_i(clk));
  HandshakeIf_t           #(.DATA_W(DATA_W)) data_out_if(.clk_i(clk));

  HandshakeDrv #(
                 .DATA_W(LOG_MAX_WORDS),
                 .TA(TA),
                 .TT(TT),
                 .MIN_WAIT(MIN_IN_WAIT_CYCLES),
                 .MAX_WAIT(MAX_IN_WAIT_CYCLES),
                 .HAS_LAST(1'b0),
                 .NAME("Num Words Input")
                 )
  num_words_drv;

  HandshakeDrv #(
                 .DATA_W(DATA_W),
                 .TA(TA),
                 .TT(TT),
                 .MIN_WAIT(MIN_IN_WAIT_CYCLES),
                 .MAX_WAIT(MAX_IN_WAIT_CYCLES),
                 .HAS_LAST(1'b0),
                 .NAME("BPC Input")
                 )
  bpc_drv;

  HandshakeDrv #(
                 .DATA_W(DATA_W),
                 .TA(TA),
                 .TT(TT),
                 .MIN_WAIT(MIN_IN_WAIT_CYCLES),
                 .MAX_WAIT(MAX_IN_WAIT_CYCLES),
                 .HAS_LAST(1'b0),
                 .NAME("ZNZ Input")
                 )
  znz_drv;

  HandshakeDrv #(
                 .DATA_W(DATA_W),
                 .TA(TA),
                 .TT(TT),
                 .MIN_WAIT(MIN_OUT_WAIT_CYCLES),
                 .MAX_WAIT(MAX_OUT_WAIT_CYCLES),
                 .HAS_LAST(1'b1),
                 .NAME("Data Output")
                 )
  out_drv;

  rst_clk_drv #(
                .CLK_PERIOD(CLK_PERIOD),
                .RST_TIME(RST_TIME)
                )
  clk_drv (
           .clk_o(clk),
           .rst_no(rst_n)
           );

  initial begin
    num_words_drv = new(num_words_if);
    num_words_drv.reset_out();
    bpc_drv = new(bpc_if);
    bpc_drv.reset_out();
    znz_drv = new(znz_if);
    znz_drv.reset_out();
    out_drv = new(data_out_if);
    out_drv.reset_in();
    #(RST_TIME*2);
    fork
      num_words_drv.feed_inputs(NUM_WORDS_STIM_FILE);
      bpc_drv.feed_inputs(BPC_STIM_FILE);
      znz_drv.feed_inputs(ZNZ_STIM_FILE);
      out_drv.read_outputs(DATA_EXPVAL_FILE);
    join
    $stop;
  end // initial begin

  ebpc_decoder dut_i (
                      .clk_i(clk),
                      .rst_ni(rst_n),
                      .num_words_i(num_words_if.data),
                      .num_words_vld_i(num_words_if.vld),
                      .num_words_rdy_o(num_words_if.rdy),
                      .bpc_i(bpc_if.data[DATA_W-1:0]),
                      .bpc_vld_i(bpc_if.vld),
                      .bpc_rdy_o(bpc_if.rdy),
                      .znz_i(znz_if.data[DATA_W-1:0]),
                      .znz_vld_i(znz_if.vld),
                      .znz_rdy_o(znz_if.rdy),
                      .data_o(data_out_if.data[DATA_W-1:0]),
                      .vld_o(data_out_if.vld),
                      .rdy_i(data_out_if.rdy)
                      );

  endmodule
