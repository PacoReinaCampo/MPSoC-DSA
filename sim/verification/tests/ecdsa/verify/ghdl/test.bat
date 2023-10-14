@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_verify_testbench.ghw
pause
