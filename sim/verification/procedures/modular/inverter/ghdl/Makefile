all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 peripheral_dsa_inverter_testbench
	ghdl -r --std=08 peripheral_dsa_inverter_testbench --ieee-asserts=disable-at-0 --vcd=peripheral_dsa_inverter_testbench.vcd --wave=peripheral_dsa_inverter_testbench.ghw --stop-time=1ms

test:
	gtkwave peripheral_dsa_inverter_testbench.ghw

clean:
	rm -rf *.cf *.vcd *.ghw
