ghdl -a --std=08 ../../../../../../rtl/vhdl/pkg/ecdsa_pkg.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/pkg/ecdsa_sha512_pkg.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/sha/ecdsa_sha512.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/ecdsa_mod.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/ecdsa_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/ecdsa_inverter.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/modular/ecdsa_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/ecdsa_point_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/ecdsa_point_doubler.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/generation/ecdsa_point_generator.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/ecdsa_sign.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/ecdsa_verify.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/ecdsa/ecdsa_top.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/kcdsa_sign.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/kcdsa_verify.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/core/kcdsa/kcdsa_top.vhd

ghdl -a --std=08 ../../../../../../bench/vhdl/core/ecdsa/ecdsa_sign/ecdsa_sign_pkg.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/core/ecdsa/ecdsa_sign/ecdsa_sign_stimulus.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/core/ecdsa/ecdsa_sign/ecdsa_adder_testbench.vhd
