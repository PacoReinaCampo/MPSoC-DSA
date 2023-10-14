@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_point_adder_testbench.ghw
pause
