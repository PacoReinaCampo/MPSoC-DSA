@echo off
call ../../../../settings64_ghdl.bat

gtkwave axi_fifo_testbench.ghw
pause
