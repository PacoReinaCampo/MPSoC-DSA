@echo off
call ../../../../../../settings64_ghdl.bat

gtkwave ecdsa_point_generator_testbench.ghw
pause
