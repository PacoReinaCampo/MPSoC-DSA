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

class peripheral_uvm_monitor extends uvm_monitor;
  // Virtual Interface
  virtual peripheral_design_if vif;

  // UVM analysis port
  uvm_analysis_port #(peripheral_uvm_sequence_item) item_collect_port;

  // Sequence Item method instantiation
  peripheral_uvm_sequence_item monitor_item;

  // Utility declaration
  `uvm_component_utils(peripheral_uvm_monitor)

  // Constructor
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
    monitor_item      = new();
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual peripheral_design_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Not set at top level");
    end
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
      wait (vif.RST);
      wait (vif.START);
      monitor_item.POINT_IN_PX = vif.POINT_IN_PX;
      monitor_item.POINT_IN_PY = vif.POINT_IN_PY;
      monitor_item.POINT_IN_QX = vif.POINT_IN_QX;
      monitor_item.POINT_IN_QY = vif.POINT_IN_QY;
      `uvm_info(get_type_name, $sformatf("POINT_IN_PX = %0d, POINT_IN_PY = %0d, POINT_IN_QX = %0d, POINT_IN_QY = %0d", monitor_item.POINT_IN_PX, monitor_item.POINT_IN_PY, monitor_item.POINT_IN_QX, monitor_item.POINT_IN_QY), UVM_HIGH);
      wait (vif.RST);
      wait (vif.READY);
      monitor_item.POINT_OUT_RX = vif.POINT_OUT_RX;
      monitor_item.POINT_OUT_RY = vif.POINT_OUT_RY;
      item_collect_port.write(monitor_item);
    end
  endtask
endclass
