all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 axi_fifo_testbench
	ghdl -r --std=08 axi_fifo_testbench --ieee-asserts=disable-at-0 --vcd=axi_fifo_testbench.vcd --wave=axi_fifo_testbench.ghw --stop-time=1ms

test:
	gtkwave axi_fifo_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
