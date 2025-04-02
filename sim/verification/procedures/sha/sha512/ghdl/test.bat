@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_sha512_testbench.ghw
pause
