all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 kcdsa_top_testbench
	ghdl -r --std=08 kcdsa_top_testbench --ieee-asserts=disable-at-0 --vcd=kcdsa_top_testbench.vcd --wave=kcdsa_top_testbench.ghw --stop-time=100ms

test:
	gtkwave kcdsa_top_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
