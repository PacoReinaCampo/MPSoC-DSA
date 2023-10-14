@echo off
call ../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 ecdsa_multiplier_testbench
ghdl -r --std=08 ecdsa_multiplier_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_multiplier_testbench.vcd --wave=ecdsa_multiplier_testbench.ghw --stop-time=1ms
pause
