@echo off
call ../../../../../../settings64_vivado.bat

gtkwave kcdsa_sign_testbench.vcd
pause
