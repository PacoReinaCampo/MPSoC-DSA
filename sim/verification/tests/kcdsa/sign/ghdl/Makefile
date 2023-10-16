all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 kcdsa_sign_testbench
	ghdl -r --std=08 kcdsa_sign_testbench --ieee-asserts=disable-at-0 --vcd=kcdsa_sign_testbench.vcd --wave=kcdsa_sign_testbench.ghw --stop-time=100ms

test:
	gtkwave kcdsa_sign_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
