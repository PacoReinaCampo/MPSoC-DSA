all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 peripheral_dsa_mod_testbench
	ghdl -r --std=08 peripheral_dsa_mod_testbench --ieee-asserts=disable-at-0 --vcd=peripheral_dsa_mod_testbench.vcd --wave=peripheral_dsa_mod_testbench.ghw --stop-time=1ms

test:
	gtkwave peripheral_dsa_mod_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
