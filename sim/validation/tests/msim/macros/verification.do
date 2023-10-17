#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

###################################################################################################
# TEST SOURCES ####################################################################################
###################################################################################################

#################################################################################
# ECDSA_SHA256_TEST 
#################################################################################

alias run_ecdsa_sha256_test {
  echo "TEST: ECDSA_SHA256_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_SHA256_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SHA256_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SHA256_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_sha256_test.wlf
}

#################################################################################
# ECDSA_SHA512_TEST 
#################################################################################

alias run_ecdsa_sha512_test {
  echo "TEST: ECDSA_SHA512_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_SHA512_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SHA512_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SHA512_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_sha512_test.wlf
}

#################################################################################
# ECDSA_ADDER_TEST 
#################################################################################

alias run_ecdsa_adder_test {
  echo "TEST: ECDSA_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_ADDER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_ADDER_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_ADDER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_adder_test.wlf
}

#################################################################################
# ECDSA_INVERTER_TEST 
#################################################################################

alias run_ecdsa_inverter_test {
  echo "TEST: ECDSA_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_INVERTER_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_INVERTER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_inverter_test.wlf
}

#################################################################################
# ECDSA_MULTIPLIER_TEST 
#################################################################################

alias run_ecdsa_multiplier_test {
  echo "TEST: ECDSA_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_MULTIPLIER_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_MULTIPLIER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_multiplier_test.wlf
}

#################################################################################
# ECDSA_POINT_ADDER_TEST 
#################################################################################

alias run_ecdsa_point_adder_test {
  echo "TEST: ECDSA_POINT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_POINT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_ADDER_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_ADDER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_point_adder_test.wlf
}

#################################################################################
# ECDSA_POINT_DOUBLER_TEST 
#################################################################################

alias run_ecdsa_point_doubler_test {
  echo "TEST: ECDSA_POINT_DOUBLER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_POINT_DOUBLER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_DOUBLER_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_DOUBLER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_point_doubler_test.wlf
}

#################################################################################
# ECDSA_POINT_GENERATOR_TEST 
#################################################################################

alias run_ecdsa_point_generator_test {
  echo "TEST: ECDSA_POINT_GENERATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_POINT_GENERATOR_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_GENERATOR_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_POINT_GENERATOR_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_point_generator_test.wlf
}

#################################################################################
# ECDSA_SIGN_TEST 
#################################################################################

alias run_ecdsa_sign_test {
  echo "TEST: ECDSA_SIGN_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_SIGN_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SIGN_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_SIGN_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_sign_test.wlf
}

#################################################################################
# ECDSA_VERIFY_TEST 
#################################################################################

alias run_ecdsa_verify_test {
  echo "TEST: ECDSA_VERIFY_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_VERIFY_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_VERIFY_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_VERIFY_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_verify_test.wlf
}

#################################################################################
# ECDSA_TOP_TEST 
#################################################################################

alias run_ecdsa_top_test {
  echo "TEST: ECDSA_TOP_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_ECDSA_TOP_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/ECDSA_TOP_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/ECDSA_TOP_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/ecdsa_top_test.wlf
}

#################################################################################
# KCDSA_SIGN_TEST 
#################################################################################

alias run_kcdsa_sign_test {
  echo "TEST: KCDSA_SIGN_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_KCDSA_SIGN_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/KCDSA_SIGN_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/KCDSA_SIGN_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/kcdsa_sign_test.wlf
}

#################################################################################
# KCDSA_VERIFY_TEST 
#################################################################################

alias run_kcdsa_verify_test {
  echo "TEST: KCDSA_VERIFY_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_KCDSA_VERIFY_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/KCDSA_VERIFY_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/KCDSA_VERIFY_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/kcdsa_verify_test.wlf
}

#################################################################################
# KCDSA_TOP_TEST 
#################################################################################

alias run_kcdsa_top_test {
  echo "TEST: KCDSA_TOP_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/C_KCDSA_TOP_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_pkg/KCDSA_TOP_TEST true 0
  force -freeze sim:/peripheral_dsa_pkg/KCDSA_TOP_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/kcdsa_top_test.wlf
}

#################################################################################

alias v01 {
  run_ecdsa_sha256_test
}

alias v02 {
  run_ecdsa_sha512_test
}

alias v03 {
  run_ecdsa_adder_test
}

alias v04 {
  run_ecdsa_inverter_test
}

alias v05 {
  run_ecdsa_multiplier_test
}

alias v06 {
  run_ecdsa_point_adder_test
}

alias v07 {
  run_ecdsa_point_doubler_test
}

alias v08 {
  run_ecdsa_point_generator_test
}

alias v09 {
  run_ecdsa_sign_test
}

alias v10 {
  run_ecdsa_verify_test
}

alias v11 {
  run_ecdsa_top_test
}

alias v12 {
  run_kcdsa_sign_test
}

alias v13 {
  run_kcdsa_verify_test
}

alias v14 {
  run_kcdsa_top_test
}

echo "************************************************************"
echo "v01 . ECDSA-SHA256"
echo "v02 . ECDSA-SHA512"
echo "v03 . ECDSA-ADDER"
echo "v04 . ECDSA-INVERTER"
echo "v05 . ECDSA-MULTIPLIER"
echo "v06 . ECDSA-POINT_ADDER"
echo "v07 . ECDSA-POINT_DOUBLER"
echo "v08 . ECDSA-POINT_GENERATOR"
echo "v09 . ECDSA-SIGN"
echo "v10 . ECDSA-VERIFY"
echo "v11 . ECDSA-TOP"
echo "v12 . KCDSA-SIGN"
echo "v13 . KCDSA-VERIFY"
echo "v14 . KCDSA-TOP"
echo "************************************************************"
