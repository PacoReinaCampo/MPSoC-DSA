all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_modular_testbench
	ghdl -r --std=08 ecdsa_modular_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_modular_testbench.vcd --wave=ecdsa_modular_testbench.ghw --stop-time=1ms

test:
	gtkwave ecdsa_modular_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
