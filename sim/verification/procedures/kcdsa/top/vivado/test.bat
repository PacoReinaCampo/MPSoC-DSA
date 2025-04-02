@echo off
call ../../../../../../settings64_vivado.bat

gtkwave kcdsa_top_testbench.vcd
pause
