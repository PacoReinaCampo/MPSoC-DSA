@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_point_doubler_testbench.vcd
pause
