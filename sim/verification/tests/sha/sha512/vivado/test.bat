@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_sha512_testbench.vcd
pause
