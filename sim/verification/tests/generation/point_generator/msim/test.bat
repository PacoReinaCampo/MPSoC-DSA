@echo off
call ../../../../../../settings64_msim.bat

gtkwave ecdsa_point_generator_testbench.vcd
pause
