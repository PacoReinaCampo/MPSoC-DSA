@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_top_testbench.vcd
pause
