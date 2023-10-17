onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /peripheral_dsa_pkg/MONITOR_TEST
add wave -noupdate /peripheral_dsa_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {KCDSA SIGN}
add wave -noupdate -divider {=========================================}

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/CLK
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/RST
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/START
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/PRIVATE_KEY
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/GENERATED_KEY
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/DATA_BLOCK_SIZE
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/DATA_IN_ENABLE
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/MESSAGE
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/DATA_OUT_ENABLE
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/READY
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/SIGNATURE_R
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/SIGNATURE_S
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/FAIL

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/sign_ctrl_fsm_st
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/sha_ctrl_fsm_st

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/arithmetic_enable_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/x_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/w_int

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/e_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/r_enable_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/r_int

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/start_sha512
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_block_size_sha512_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_enable_sha512_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_sha512_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_out_enable_sha512_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/ready_sha512
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_out_sha512_int

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/start_adder
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/operation_adder
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_a_adder_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_b_adder_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/ready_adder
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_out_adder_int

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/start_multiplier
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_a_multiplier_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_in_b_multiplier_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/ready_multiplier
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/data_out_multiplier_int

add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/start_point_generator
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/key_point_generator_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/point_in_x_generator_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/point_in_y_generator_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/ready_point_generator
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/point_out_x_generator_int
add wave -noupdate /peripheral_dsa_testbench/kcdsa_sign_if/kcdsa_sign_dut/point_out_y_generator_int

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
