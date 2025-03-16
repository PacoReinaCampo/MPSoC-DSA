@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_point_doubler_testbench.ghw
pause
