@echo off
call ../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 peripheral_dsa_testbench
ghdl -r --std=08 peripheral_dsa_testbench --ieee-asserts=disable-at-0 --vcd=peripheral_dsa_testbench.vcd --wave=peripheral_dsa_testbench.ghw --stop-time=1ms
pause
