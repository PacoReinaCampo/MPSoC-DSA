@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_adder_testbench.vcd
pause
