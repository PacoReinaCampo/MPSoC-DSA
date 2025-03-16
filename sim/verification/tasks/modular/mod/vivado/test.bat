@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_modular_testbench.vcd
pause
