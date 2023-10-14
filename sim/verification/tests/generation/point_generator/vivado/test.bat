@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_sign_testbench.vcd
pause
