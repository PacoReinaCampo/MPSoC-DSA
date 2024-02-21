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

ghdl -a --std=08 ../../../../../../verification/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_verify/peripheral_dsa_kcdsa_verify_pkg.vhd
ghdl -a --std=08 ../../../../../../verification/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_verify/peripheral_dsa_kcdsa_verify_stimulus.vhd
ghdl -a --std=08 ../../../../../../verification/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_verify/peripheral_dsa_kcdsa_verify_testbench.vhd
