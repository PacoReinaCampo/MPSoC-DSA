@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave kcdsa_verify_testbench.ghw
pause
