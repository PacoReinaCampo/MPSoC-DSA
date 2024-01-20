////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

`include "peripheral_interface.sv"
`include "peripheral_test.sv"

import peripheral_dsa_pkg::*;

module peripheral_testbench;
  bit CLK;
  bit RST;
  bit START;

  // Clock declaration
  always #1 CLK = ~CLK;

  initial begin
    CLK = 0;
  end

  // Reset Generation
  initial begin
    RST = 0;
    #6;
    RST = 1;
  end

  // Start Generation
  initial begin
    START = 0;
    #999;

    repeat (10) begin
      START = 1;
      #2;

      START = 0;
      #998;
    end
  end

  // Interface instantiation
  add_if vif (
    CLK,
    RST,
    START
  );

  // DUT instantiation
  peripheral_dsa_inverter dut (
    .CLK(vif.CLK),
    .RST(vif.RST),

    .START(vif.START),
    .MODULO(vif.MODULO),
    .DATA_IN(vif.DATA_IN),

    .READY(vif.READY),
    .DATA_OUT(vif.DATA_OUT)
  );

  // Calling TestCase
  peripheral_test t1 (vif);

  initial begin
    // Enable wave dump
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
endmodule
