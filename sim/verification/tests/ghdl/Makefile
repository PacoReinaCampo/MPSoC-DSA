all: build simulate

build:
	sh system.s

simulate:
	ghdl -e --std=08 testbench_miera_top
	ghdl -r --std=08 testbench_miera_top --ieee-asserts=disable-at-0 --vcd=testbench_miera_top.vcd --wave=testbench_miera_top.ghw --stop-time=1ms

simulate:
	gtkwave testbench_miera_top.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
