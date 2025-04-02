@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_sha256_testbench.ghw
pause
