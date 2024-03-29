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

class peripheral_scoreboard;
  int compare_cnt;

  mailbox monitor_to_scoreboard;

  // Constructor
  function new(mailbox monitor_to_scoreboard);
    this.monitor_to_scoreboard = monitor_to_scoreboard;
  endfunction

  task run;
    forever begin
      // Transaction method instantiation
      peripheral_transaction transaction;

      // Create transaction method
      transaction = new();

      monitor_to_scoreboard.get(transaction);

      if (modular_multiplier(transaction.MODULO, transaction.DATA_A_IN, transaction.DATA_B_IN, transaction.DATA_OUT)) begin
        $display("Matched: MODULO = %0d, DATA_A_IN = %0d, DATA_B_IN = %0d, DATA_OUT = %0d", transaction.MODULO, transaction.DATA_A_IN, transaction.DATA_B_IN, transaction.DATA_OUT);
      end else begin
        $display("Dis-Matched: MODULO = %0d, DATA_A_IN = %0d, DATA_B_IN = %0d, DATA_OUT = %0d", transaction.MODULO, transaction.DATA_A_IN, transaction.DATA_B_IN, transaction.DATA_OUT);
      end
      compare_cnt++;
    end
  endtask

  function modular_multiplier;
    input [511:0] modulo;
    input [511:0] data_a_in;
    input [511:0] data_b_in;

    input [511:0] data_out;

    logic [511:0] out;

    out = (data_a_in * data_b_in) % modulo;
    
    if (out == data_out) begin
      return 1;
    end else begin
      return 0;
    end
  endfunction
endclass
