@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_point_adder_testbench.vcd
pause
