@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_top_testbench.vcd
pause
