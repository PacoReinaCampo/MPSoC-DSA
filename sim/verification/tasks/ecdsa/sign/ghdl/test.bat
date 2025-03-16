@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_sign_testbench.ghw
pause
