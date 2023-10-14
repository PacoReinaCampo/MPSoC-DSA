@echo off
call ../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 ecdsa_inverter_testbench
ghdl -r --std=08 ecdsa_inverter_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_inverter_testbench.vcd --wave=ecdsa_inverter_testbench.ghw --stop-time=1ms
pause
