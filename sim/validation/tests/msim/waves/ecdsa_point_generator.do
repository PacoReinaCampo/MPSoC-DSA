onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /testbench_miera_pkg/MONITOR_TEST
add wave -noupdate /testbench_miera_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ECDSA GENERATOR}
add wave -noupdate -divider {=========================================}

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/CLK
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/RST
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/START
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/PRIVATE_KEY
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/POINT_IN_X
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/POINT_IN_Y
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/READY
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/POINT_OUT_X
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/POINT_OUT_Y

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_generator_ctrl_fsm_st

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_ax_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_ay_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_bx_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_by_int

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/generation_cnt

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/start_point_adder
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_px_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_py_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_qx_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_qy_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/ready_point_adder
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_out_rx_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_out_ry_adder_int

add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/start_point_doubler
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_px_doubler_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_in_py_doubler_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/ready_point_doubler
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_out_rx_doubler_int
add wave -noupdate /testbench_miera_top/ecdsa_point_generator_if/ecdsa_point_generator_dut/point_out_ry_doubler_int

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
