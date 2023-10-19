onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /peripheral_dsa_pkg/MONITOR_TEST
add wave -noupdate /peripheral_dsa_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {DSA INVERTER}
add wave -noupdate -divider {=========================================}

add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/CLK
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/RST
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/START
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/MODULO
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/DATA_IN
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/READY
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/DATA_OUT

add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/inverter_ctrl_fsm_st

add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/u_int
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/v_int

add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/x_int
add wave -noupdate /peripheral_dsa_testbench/peripheral_dsa_inverter_if/peripheral_dsa_inverter_dut/y_int
  
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
