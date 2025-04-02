@echo off
call ../../../../../../settings64_msim.bat

gtkwave kcdsa_top_testbench.vcd
pause
