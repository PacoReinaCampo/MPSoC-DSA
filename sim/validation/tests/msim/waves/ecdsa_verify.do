onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /testbench_miera_pkg/MONITOR_TEST
add wave -noupdate /testbench_miera_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ECDSA VERIFY}
add wave -noupdate -divider {=========================================}

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/CLK
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/RST
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/START
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/PUBLIC_KEY_X
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/PUBLIC_KEY_Y
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/SIGNATURE_R
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/SIGNATURE_S
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/DATA_BLOCK_SIZE
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/DATA_IN_ENABLE
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/MESSAGE
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/DATA_OUT_ENABLE
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/READY
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/FAIL

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/verify_ctrl_fsm_st
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/sha_ctrl_fsm_st

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/w_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_x_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_y_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/e_enable_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/e_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_sha512
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_enable_sha512_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_sha512_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_out_enable_sha512_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_sha512
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_out_sha512_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_inverter
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_inverter_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_inverter
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_out_inverter_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_mod
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_mod_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_mod
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_out_mod_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_multiplier
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_a_multiplier_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_in_b_multiplier_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_multiplier
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/data_out_multiplier_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_point_adder
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_px_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_py_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_qx_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_qy_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_point_adder
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_out_rx_adder_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_out_ry_adder_int

add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/start_point_generator
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/key_point_generator_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_x_generator_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_in_y_generator_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/ready_point_generator
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_out_x_generator_int
add wave -noupdate /testbench_miera_top/ecdsa_verify_if/ecdsa_verify_dut/point_out_y_generator_int

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
