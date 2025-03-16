@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_top_testbench.ghw
pause
