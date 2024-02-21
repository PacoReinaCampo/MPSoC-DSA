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

class peripheral_uvm_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp #(peripheral_uvm_sequence_item, peripheral_uvm_scoreboard) item_collect_export;

  // Sequence Item method instantiation
  peripheral_uvm_sequence_item item_q [$];

  // Utility declaration
  `uvm_component_utils(peripheral_uvm_scoreboard)

  // Constructor
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(peripheral_uvm_sequence_item req);
    item_q.push_back(req);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    // Sequence Item method instantiation
    peripheral_uvm_sequence_item scoreboard_item;

    forever begin
      wait (item_q.size > 0);

      if (item_q.size > 0) begin
        scoreboard_item = item_q.pop_front();
        $display("----------------------------------------------------------------------------------------------------------");
        if (modular_mod(scoreboard_item.MODULO, scoreboard_item.DATA_IN, scoreboard_item.DATA_OUT)) begin
          `uvm_info(get_type_name, $sformatf("Matched: MODULO = %0d, DATA_IN = %0d, DATA_OUT = %0d", scoreboard_item.MODULO, scoreboard_item.DATA_IN, scoreboard_item.DATA_OUT), UVM_LOW);
        end else begin
          `uvm_error(get_name, $sformatf("Dis-Matched: MODULO = %0d, DATA_IN = %0d, DATA_OUT = %0d", scoreboard_item.MODULO, scoreboard_item.DATA_IN, scoreboard_item.DATA_OUT));
        end
        $display("----------------------------------------------------------------------------------------------------------");
      end
    end
  endtask

  function modular_mod;
    input [511:0] modulo;
    input [511:0] data_in;

    input [511:0] data_out;

    logic [511:0] out;

    out = data_in % modulo;
    
    if (out == data_out) begin
      return 1;
    end else begin
      return 0;
    end
  endfunction

endclass