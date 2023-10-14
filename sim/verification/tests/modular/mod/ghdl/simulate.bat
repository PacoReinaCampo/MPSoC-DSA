@echo off
call ../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 ecdsa_modular_testbench
ghdl -r --std=08 ecdsa_modular_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_modular_testbench.vcd --wave=ecdsa_modular_testbench.ghw --stop-time=1ms
pause
