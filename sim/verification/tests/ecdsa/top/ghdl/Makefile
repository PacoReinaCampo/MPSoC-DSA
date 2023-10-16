all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_top_testbench
	ghdl -r --std=08 ecdsa_top_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_top_testbench.vcd --wave=ecdsa_top_testbench.ghw --stop-time=100ms

test:
	gtkwave ecdsa_top_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
