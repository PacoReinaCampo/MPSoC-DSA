@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_point_adder_testbench.vcd
pause
