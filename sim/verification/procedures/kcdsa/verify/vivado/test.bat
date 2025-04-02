@echo off
call ../../../../../../settings64_vivado.bat

gtkwave kcdsa_verify_testbench.vcd
pause
