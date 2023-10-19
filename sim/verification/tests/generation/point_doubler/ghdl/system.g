ghdl -a --std=08 ../../../../../../rtl/vhdl/pkg/peripheral_dsa_pkg.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/pkg/peripheral_dsa_sha512_pkg.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/sha/peripheral_dsa_sha512.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/peripheral_dsa_mod.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/peripheral_dsa_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/peripheral_dsa_inverter.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/peripheral_dsa_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_doubler.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_generator.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_sign.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_verify.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_top.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_sign.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_verify.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_top.vhd

ghdl -a --std=08 ../../../../../../bench/vhdl/core/generation/peripheral_dsa_point_doubler/peripheral_dsa_point_doubler_pkg.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/core/generation/peripheral_dsa_point_doubler/peripheral_dsa_point_doubler_stimulus.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/core/generation/peripheral_dsa_point_doubler/peripheral_dsa_point_doubler_testbench.vhd
