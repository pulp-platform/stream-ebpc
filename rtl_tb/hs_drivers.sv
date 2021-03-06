// Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`timescale 1ps/1fs

package hs_drv_pkg;

class HandshakeDrv
  #(
    parameter int unsigned DATA_W = 8,
    parameter time         TA = 0ns,
    parameter time         TT = 0ns,
    parameter int unsigned MIN_WAIT = 0,
    parameter int unsigned MAX_WAIT = 2,
    parameter logic        HAS_LAST = 1'b0,
    parameter string       NAME = ""
    );
  virtual                  HandshakeIf_t #(.DATA_W(DATA_W)) vif;

  function new(virtual HandshakeIf_t #(.DATA_W(DATA_W)) vif);
    this.vif = vif;
  endfunction // new

  task automatic feed_inputs(input string file);
    automatic int cycles_to_wait;
    automatic logic [DATA_W-1:0] dat;
    automatic int fh;
    automatic logic last;
    automatic logic signed [8:0] testchar;
    fh       = $fopen(file, "r");
    if (fh == 0) begin
      $display("fh: %d", fh);
      $info("File %s does not exist - aborting read_outputs task.", file);
      return;
    end
    testchar = $fgetc(fh);
    if (testchar < 1) begin
      $info("File %s is empty - aborting feed_inputs task.", file);
      return;
    end else
      $rewind(fh);
    while (!$feof(fh)) begin
      cycles_to_wait = $urandom_range(MIN_WAIT, MAX_WAIT);
      if (HAS_LAST) begin
        $fscanf(fh, "%b %b", dat, last);
      end else begin
        $fscanf(fh, "%b", dat);
        last = 1'b0;
      end
      write_output(cycles_to_wait, dat, last);
    end
    $fclose(fh);
  endtask // feed_inputs

  task automatic read_outputs(input string file);
    automatic int cycles_to_wait;
    automatic logic [DATA_W-1:0] dat_expected, dat_actual;
    automatic int fh;
    automatic logic last_expected, last_actual;
    automatic logic signed [8:0] testchar;
    fh       = $fopen(file, "r");
    if (fh == 0) begin
      $display("fh: %d", fh);
      $info("File %s does not exist - aborting read_outputs task.", file);
      return;
    end
    testchar = $fgetc(fh);
    if (testchar < 0) begin
      $info("File %s is empty - aborting read_outputs task.", file);
      return;
    end else
      $rewind(fh);
    while (!$feof(fh)) begin
      cycles_to_wait = $urandom_range(MIN_WAIT, MAX_WAIT);
      if (HAS_LAST) begin
        $fscanf(fh, "%b %b", dat_expected, last_expected);
      end else begin
        $fscanf(fh, "%b", dat_expected);
        last_expected = 1'b0;
      end
      read_input(cycles_to_wait, dat_actual, last_actual);
      if (dat_actual != dat_expected)
        $error("Output data mismatch on interface %s - expected: %b    actual: %b", NAME, dat_expected, dat_actual);
      if ((last_expected != last_actual) && HAS_LAST)
        $error("Output last mismatch on interface %s - expected: %b    actual %b", NAME, last_expected, last_actual);
    end
    $fclose(fh);
  endtask // read_outputs

  // to be called at clock edge
  task automatic write_output(input int wait_cycles, input logic [DATA_W-1:0] dat, input logic last_in);
    vif.vld <= #TA 1'b0;
    for (int i=0; i<wait_cycles; i++)
      @(posedge vif.clk_i) ;
    vif.vld  <= #TA 1'b1;
    vif.data <= #TA dat;
    vif.last <= #TA last_in;
    #TT ;
    while (vif.rdy != 1) begin
      @(posedge vif.clk_i) ;
      #TT ;
    end
    @(posedge vif.clk_i) ;
    vif.vld <= #TA 1'b0;
  endtask // write_input

  task automatic read_input(input int wait_cycles, output logic [DATA_W-1:0] dat, output logic last_o);
    vif.rdy <= #TA 1'b0;
    for (int i=0; i<wait_cycles; i++)
      @(posedge vif.clk_i) ;
    vif.rdy <= #TA 1'b1;
    #TT ;
    while (vif.vld != 1) begin
      @(posedge vif.clk_i) ;
      #TT ;
    end
    dat = vif.data;
    last_o = vif.last;
    @(posedge vif.clk_i) ;
    vif.rdy <= #TA 1'b0;
  endtask // read_output

  task automatic reset_out();
    vif.vld  <= 1'b0;
    vif.data <= 'd0;
    vif.last <= 1'b0;
  endtask // reset_out
  
  task automatic reset_in();
    vif.rdy <= 1'b0;
  endtask // reset_in
  

endclass // HandshakeWrDrv

endpackage
