@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_inverter_testbench.vcd
pause
