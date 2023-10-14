@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_inverter_testbench.ghw
pause
