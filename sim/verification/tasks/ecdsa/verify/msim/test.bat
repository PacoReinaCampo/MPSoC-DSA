@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_verify_testbench.vcd
pause
