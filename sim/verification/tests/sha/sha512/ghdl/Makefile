all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 ecdsa_sha512_testbench
	ghdl -r --std=08 ecdsa_sha512_testbench --ieee-asserts=disable-at-0 --vcd=ecdsa_sha512_testbench.vcd --wave=ecdsa_sha512_testbench.ghw --stop-time=1ms

test:
	gtkwave ecdsa_sha512_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
