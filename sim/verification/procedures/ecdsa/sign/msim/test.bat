@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_sign_testbench.vcd
pause
