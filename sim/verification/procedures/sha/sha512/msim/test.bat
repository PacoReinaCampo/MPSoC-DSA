@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_sha512_testbench.vcd
pause
