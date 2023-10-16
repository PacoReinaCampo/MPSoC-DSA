all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_verify_testbench
	ghdl -r --std=08 ecdsa_verify_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_verify_testbench.vcd --wave=ecdsa_verify_testbench.ghw --stop-time=100ms

test:
	gtkwave ecdsa_verify_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
