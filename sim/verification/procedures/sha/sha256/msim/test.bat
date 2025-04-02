@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_sha256_testbench.vcd
pause
