@echo off
call ../../../../../../settings64_vivado.bat

gtkwave ecdsa_point_generator_testbench.vcd
pause
