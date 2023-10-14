@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_point_doubler_testbench.vcd
pause
