all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_adder_testbench
	ghdl -r --std=08 ecdsa_adder_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_adder_testbench.vcd --wave=ecdsa_adder_testbench.ghw --stop-time=1ms

test:
	gtkwave ecdsa_adder_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
