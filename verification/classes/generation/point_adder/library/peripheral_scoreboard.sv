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

      if (point_doubler(transaction.POINT_IN_PX, transaction.POINT_IN_PY, transaction.POINT_OUT_RX, transaction.POINT_OUT_RY)) begin
        $display("Matched: POINT_OUT_RX = %0d, POINT_OUT_RY = %0d", transaction.POINT_OUT_RX, transaction.POINT_OUT_RY);
      end else begin
        $display("Dis-Matched: POINT_OUT_RX = %0d, POINT_OUT_RY = %0d", transaction.POINT_OUT_RX, transaction.POINT_OUT_RY);
      end
      compare_cnt++;
    end
  endtask

  function point_adder;
    input [511:0] px;
    input [511:0] py;
    input [511:0] qx;
    input [511:0] qy;

    input [511:0] x;
    input [511:0] y;

    logic [511:0] s;

    logic [511:0] rx;
    logic [511:0] ry;

    // s = (Py - Qy) / (Px - Qx)
    s = (py - qy) / (px - qx);

    // Rx = s*s - Px - Qx
    rx = (s*s - px - qx) % BLACKPOOL512_P;

    // Ry = s*(Px - Rx) - Py
    ry = (s*s - px - qx) % BLACKPOOL512_P;
    
    if ((rx == x) && (ry == y)) begin
      return 1;
    end else begin
      return 0;
    end
  endfunction

endclass
