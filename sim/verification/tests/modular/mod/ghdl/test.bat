@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_modular_testbench.ghw
pause
