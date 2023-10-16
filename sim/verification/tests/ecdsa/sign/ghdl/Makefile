all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_sign_testbench
	ghdl -r --std=08 ecdsa_sign_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_sign_testbench.vcd --wave=ecdsa_sign_testbench.ghw --stop-time=100ms

test:
	gtkwave ecdsa_sign_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
