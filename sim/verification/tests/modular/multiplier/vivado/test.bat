@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_multiplier_testbench.vcd
pause
