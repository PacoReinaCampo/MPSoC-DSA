onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /testbench_miera_pkg/MONITOR_TEST
add wave -noupdate /testbench_miera_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ECDSA SHA512}
add wave -noupdate -divider {=========================================}

add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/CLK
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/RST
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/START
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/DATA_BLOCK_SIZE
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/DATA_IN_ENABLE
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/DATA_IN
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/DATA_OUT_ENABLE
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/READY
add wave -noupdate /testbench_miera_top/ecdsa_sha512_if/ecdsa_sha512_dut/DATA_OUT

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
