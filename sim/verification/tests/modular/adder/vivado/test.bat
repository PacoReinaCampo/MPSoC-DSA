@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_adder_testbench.vcd
pause
