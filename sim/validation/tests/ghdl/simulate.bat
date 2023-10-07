@echo off
call ../../ ../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 testbench_miera_top
ghdl -r --std=08 testbench_miera_top --ieee-asserts=disable-at-0 --vcd=testbench_miera_top.vcd --wave=testbench_miera_top.ghw --stop-time=1ms
pause
