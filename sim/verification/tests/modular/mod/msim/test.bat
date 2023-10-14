@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_modular_testbench.vcd
pause
