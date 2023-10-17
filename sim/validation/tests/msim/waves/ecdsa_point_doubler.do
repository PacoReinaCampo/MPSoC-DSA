onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /peripheral_dsa_pkg/MONITOR_TEST
add wave -noupdate /peripheral_dsa_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ECDSA DOUBLER}
add wave -noupdate -divider {=========================================}

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/CLK
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/RST
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/START
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/POINT_IN_PX
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/POINT_IN_PY
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/READY
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/POINT_OUT_RX
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/POINT_OUT_RY

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/point_doubler_ctrl_fsm_st

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/s_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/t_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/point_rx_int

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/start_adder
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/operation_adder
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_in_a_adder_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_in_b_adder_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/ready_adder
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_out_adder_int

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/start_inverter
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_in_inverter_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/ready_inverter
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_out_inverter_int

add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/start_multiplier
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_in_a_multiplier_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_in_b_multiplier_int
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/ready_multiplier
add wave -noupdate /peripheral_dsa_testbench/ecdsa_point_doubler_if/ecdsa_point_doubler_dut/data_out_multiplier_int
  
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1042309203 ps} 0} {{Cursor 2} {7446987402 ps} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1134027470 ps} {1150214364 ps}
