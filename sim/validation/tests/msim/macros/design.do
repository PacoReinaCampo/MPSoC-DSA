#************************
# DESIGN COMPILATION
#************************

do variables.do

vlib work

###################################################################################################
# peripheral_dsa_sha256_compilation_exec
###################################################################################################

alias peripheral_dsa_sha256_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha256_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha256.vhd
}

###################################################################################################
# peripheral_dsa_sha512_compilation_exec
###################################################################################################

alias peripheral_dsa_sha512_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
}

###################################################################################################
# peripheral_dsa_adder_compilation_exec
###################################################################################################

alias peripheral_dsa_adder_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
}

###################################################################################################
# peripheral_dsa_inverter_compilation_exec
###################################################################################################

alias peripheral_dsa_inverter_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
}

###################################################################################################
# peripheral_dsa_multiplier_compilation_exec
###################################################################################################

alias peripheral_dsa_multiplier_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
}

###################################################################################################
# peripheral_dsa_point_adder_compilation_exec
###################################################################################################

alias peripheral_dsa_point_adder_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
}

###################################################################################################
# peripheral_dsa_point_doubler_compilation_exec
###################################################################################################

alias peripheral_dsa_point_doubler_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
}

###################################################################################################
# peripheral_dsa_point_generator_compilation_exec
###################################################################################################

alias peripheral_dsa_point_generator_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
}

###################################################################################################
# peripheral_dsa_ecdsa_sign_compilation_exec
###################################################################################################

alias peripheral_dsa_ecdsa_sign_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/ecdsa/peripheral_dsa_ecdsa_sign.vhd
}

###################################################################################################
# peripheral_dsa_ecdsa_verify_compilation_exec
###################################################################################################

alias peripheral_dsa_ecdsa_verify_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/ecdsa/peripheral_dsa_ecdsa_verify.vhd
}

###################################################################################################
# peripheral_dsa_ecdsa_top_compilation_exec
###################################################################################################

alias peripheral_dsa_ecdsa_top_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/ecdsa/peripheral_dsa_ecdsa_top.vhd
}

###################################################################################################
# peripheral_dsa_kcdsa_sign_compilation_exec
###################################################################################################

alias peripheral_dsa_kcdsa_sign_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_sign.vhd
}

###################################################################################################
# peripheral_dsa_kcdsa_verify_compilation_exec
###################################################################################################

alias peripheral_dsa_kcdsa_verify_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_verify.vhd
}

###################################################################################################
# peripheral_dsa_kcdsa_top_compilation_exec
###################################################################################################

alias peripheral_dsa_kcdsa_top_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/pkg/peripheral_dsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/sha/peripheral_dsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $model_path/procedures/library/core/modular/peripheral_dsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/generation/peripheral_dsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/procedures/library/core/kcdsa/peripheral_dsa_kcdsa_top.vhd
}

###################################################################################################

alias d01 {
  peripheral_dsa_sha256_compilation_exec
}

alias d02 {
  peripheral_dsa_sha512_compilation_exec
}

alias d03 {
  peripheral_dsa_adder_compilation_exec
}

alias d04 {
  peripheral_dsa_inverter_compilation_exec
}

alias d05 {
  peripheral_dsa_multiplier_compilation_exec
}

alias d06 {
  peripheral_dsa_point_adder_compilation_exec
}

alias d07 {
  peripheral_dsa_point_doubler_compilation_exec
}

alias d08 {
  peripheral_dsa_point_generator_compilation_exec
}

alias d09 {
  peripheral_dsa_ecdsa_sign_compilation_exec
}

alias d10 {
  peripheral_dsa_ecdsa_verify_compilation_exec
}

alias d11 {
  peripheral_dsa_ecdsa_top_compilation_exec
}

alias d12 {
  peripheral_dsa_kcdsa_sign_compilation_exec
}

alias d13 {
  peripheral_dsa_kcdsa_verify_compilation_exec
}

alias d14 {
  peripheral_dsa_kcdsa_top_compilation_exec
}

echo "****************************************"
echo "d01 . DSA-SHA256"
echo "d02 . DSA-SHA512"
echo "d03 . DSA-ADDER"
echo "d04 . DSA-INVERTER"
echo "d05 . DSA-MULTIPLIER"
echo "d06 . DSA-POINT_ADDER"
echo "d07 . DSA-POINT_DOUBLER"
echo "d08 . DSA-POINT_GENERATOR"
echo "d09 . DSA-ECDSA-SIGN"
echo "d10 . DSA-ECDSA-VERIFY"
echo "d11 . DSA-ECDSA-TOP"
echo "d12 . DSA-KCDSA-SIGN"
echo "d13 . DSA-KCDSA-VERIFY"
echo "d14 . DSA-KCDSA-TOP"
echo "****************************************"
