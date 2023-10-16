@echo off
call ../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 ecdsa_sign_testbench
ghdl -r --std=08 ecdsa_sign_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_sign_testbench.vcd --wave=ecdsa_sign_testbench.ghw --stop-time=100ms
pause
