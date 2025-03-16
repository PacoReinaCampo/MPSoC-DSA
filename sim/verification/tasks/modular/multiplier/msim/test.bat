@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_multiplier_testbench.vcd
pause
