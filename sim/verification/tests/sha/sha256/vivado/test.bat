@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_sha256_testbench.vcd
pause
