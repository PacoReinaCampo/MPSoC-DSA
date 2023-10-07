#************************
# DESIGN COMPILATION
#************************

do variables.do

vlib work

###################################################################################################
# ecdsa_sha256_compilation_exec ###################################################################
###################################################################################################

alias ecdsa_sha256_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha256_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha256.vhd
}

###################################################################################################
# ecdsa_sha512_compilation_exec ###################################################################
###################################################################################################

alias ecdsa_sha512_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
}

###################################################################################################
# ecdsa_adder_compilation_exec ####################################################################
###################################################################################################

alias ecdsa_adder_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
}

###################################################################################################
# ecdsa_inverter_compilation_exec #################################################################
###################################################################################################

alias ecdsa_inverter_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
}

###################################################################################################
# ecdsa_multiplier_compilation_exec ###############################################################
###################################################################################################

alias ecdsa_multiplier_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
}

###################################################################################################
# ecdsa_point_adder_compilation_exec ##############################################################
###################################################################################################

alias ecdsa_point_adder_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
}

###################################################################################################
# ecdsa_point_doubler_compilation_exec ############################################################
###################################################################################################

alias ecdsa_point_doubler_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
}

###################################################################################################
# ecdsa_point_generator_compilation_exec ##########################################################
###################################################################################################

alias ecdsa_point_generator_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
}

###################################################################################################
# ecdsa_sign_compilation_exec #####################################################################
###################################################################################################

alias ecdsa_sign_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/ecdsa/ecdsa_sign.vhd
}

###################################################################################################
# ecdsa_verify_compilation_exec ###################################################################
###################################################################################################

alias ecdsa_verify_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/ecdsa/ecdsa_verify.vhd
}

###################################################################################################
# ecdsa_top_compilation_exec ######################################################################
###################################################################################################

alias ecdsa_top_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/ecdsa/ecdsa_top.vhd
}

###################################################################################################
# kcdsa_sign_compilation_exec #####################################################################
###################################################################################################

alias kcdsa_sign_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/kcdsa/kcdsa_sign.vhd
}

###################################################################################################
# kcdsa_verify_compilation_exec ###################################################################
###################################################################################################

alias kcdsa_verify_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/kcdsa/kcdsa_verify.vhd
}

###################################################################################################
# kcdsa_top_compilation_exec ######################################################################
###################################################################################################

alias kcdsa_top_compilation_exec {
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/pkg/ecdsa_sha512_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/sha/ecdsa_sha512.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/definition/ecdsa_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_doubler.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/generation/ecdsa_point_generator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/vhdl/core/kcdsa/kcdsa_top.vhd
}

###################################################################################################

alias d01 {
  ecdsa_sha256_compilation_exec
}

alias d02 {
  ecdsa_sha512_compilation_exec
}

alias d03 {
  ecdsa_adder_compilation_exec
}

alias d04 {
  ecdsa_inverter_compilation_exec
}

alias d05 {
  ecdsa_multiplier_compilation_exec
}

alias d06 {
  ecdsa_point_adder_compilation_exec
}

alias d07 {
  ecdsa_point_doubler_compilation_exec
}

alias d08 {
  ecdsa_point_generator_compilation_exec
}

alias d09 {
  ecdsa_sign_compilation_exec
}

alias d10 {
  ecdsa_verify_compilation_exec
}

alias d11 {
  ecdsa_top_compilation_exec
}

alias d12 {
  kcdsa_sign_compilation_exec
}

alias d13 {
  kcdsa_verify_compilation_exec
}

alias d14 {
  kcdsa_top_compilation_exec
}

echo "****************************************"
echo "d01 . ECDSA-SHA256"
echo "d02 . ECDSA-SHA512"
echo "d03 . ECDSA-ADDER"
echo "d04 . ECDSA-INVERTER"
echo "d05 . ECDSA-MULTIPLIER"
echo "d06 . ECDSA-POINT_ADDER"
echo "d07 . ECDSA-POINT_DOUBLER"
echo "d08 . ECDSA-POINT_GENERATOR"
echo "d09 . ECDSA-SIGN"
echo "d10 . ECDSA-VERIFY"
echo "d11 . ECDSA-TOP"
echo "d12 . KCDSA-SIGN"
echo "d13 . KCDSA-VERIFY"
echo "d14 . KCDSA-TOP"
echo "****************************************"
