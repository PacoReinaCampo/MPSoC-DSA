@echo off
call ../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 ecdsa_point_adder_testbench
ghdl -r --std=08 ecdsa_point_adder_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_point_adder_testbench.vcd --wave=ecdsa_point_adder_testbench.ghw --stop-time=1ms
pause
