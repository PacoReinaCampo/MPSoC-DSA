@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_verify_testbench.vcd
pause
