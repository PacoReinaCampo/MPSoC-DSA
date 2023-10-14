@echo off
call ../../../../../../settings64_msim.bat

gtkwave kcdsa_verify_testbench.vcd
pause
