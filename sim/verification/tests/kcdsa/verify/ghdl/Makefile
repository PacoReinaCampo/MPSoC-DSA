all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 kcdsa_verify_testbench
	ghdl -r --std=08 kcdsa_verify_testbench --ieee-asserts=disable-at-0 --vcd=kcdsa_verify_testbench.vcd --wave=kcdsa_verify_testbench.ghw --stop-time=1ms

test:
	gtkwave kcdsa_verify_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
