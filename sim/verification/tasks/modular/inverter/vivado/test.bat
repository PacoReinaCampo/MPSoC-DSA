@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_inverter_testbench.vcd
pause
