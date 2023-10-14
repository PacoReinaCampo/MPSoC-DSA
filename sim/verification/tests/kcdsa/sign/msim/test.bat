@echo off
call ../../../../../../settings64_msim.bat

gtkwave kcdsa_sign_testbench.vcd
pause
