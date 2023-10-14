@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_multiplier_testbench.ghw
pause
