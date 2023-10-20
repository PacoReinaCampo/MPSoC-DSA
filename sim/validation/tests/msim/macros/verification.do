#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

###################################################################################################
# TEST SOURCES ####################################################################################
###################################################################################################

#################################################################################
# DSA_SHA256_TEST 
#################################################################################

alias run_peripheral_dsa_sha256_test {
  echo "TEST: DSA_SHA256_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_SHA256_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_SHA256_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_SHA256_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_sha256_test.wlf
}

#################################################################################
# DSA_SHA512_TEST 
#################################################################################

alias run_peripheral_dsa_sha512_test {
  echo "TEST: DSA_SHA512_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_SHA512_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_SHA512_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_SHA512_CASE_2 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_sha512_test.wlf
}

#################################################################################
# DSA_ADDER_TEST 
#################################################################################

alias run_peripheral_dsa_adder_test {
  echo "TEST: DSA_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_ADDER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_ADDER_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_ADDER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_adder_test.wlf
}

#################################################################################
# DSA_INVERTER_TEST 
#################################################################################

alias run_peripheral_dsa_inverter_test {
  echo "TEST: DSA_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_INVERTER_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_INVERTER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_inverter_test.wlf
}

#################################################################################
# DSA_MULTIPLIER_TEST 
#################################################################################

alias run_peripheral_dsa_multiplier_test {
  echo "TEST: DSA_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_MULTIPLIER_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_MULTIPLIER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_multiplier_test.wlf
}

#################################################################################
# DSA_POINT_ADDER_TEST 
#################################################################################

alias run_peripheral_dsa_point_adder_test {
  echo "TEST: DSA_POINT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_POINT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_POINT_ADDER_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_POINT_ADDER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_point_adder_test.wlf
}

#################################################################################
# DSA_POINT_DOUBLER_TEST 
#################################################################################

alias run_peripheral_dsa_point_doubler_test {
  echo "TEST: DSA_POINT_DOUBLER_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_POINT_DOUBLER_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_POINT_DOUBLER_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_POINT_DOUBLER_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_point_doubler_test.wlf
}

#################################################################################
# DSA_POINT_GENERATOR_TEST 
#################################################################################

alias run_peripheral_dsa_point_generator_test {
  echo "TEST: DSA_POINT_GENERATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_POINT_GENERATOR_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_POINT_GENERATOR_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_POINT_GENERATOR_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_point_generator_test.wlf
}

#################################################################################
# DSA_ECDSA_SIGN_TEST 
#################################################################################

alias run_peripheral_dsa_ecdsa_sign_test {
  echo "TEST: DSA_ECDSA_SIGN_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_ECDSA_SIGN_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_SIGN_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_SIGN_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_ecdsa_sign_test.wlf
}

#################################################################################
# DSA_ECDSA_VERIFY_TEST 
#################################################################################

alias run_peripheral_dsa_ecdsa_verify_test {
  echo "TEST: DSA_ECDSA_VERIFY_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_ECDSA_VERIFY_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_VERIFY_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_VERIFY_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_ecdsa_verify_test.wlf
}

#################################################################################
# DSA_ECDSA_TOP_TEST 
#################################################################################

alias run_peripheral_dsa_ecdsa_top_test {
  echo "TEST: DSA_ECDSA_TOP_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_ECDSA_TOP_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_TOP_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_ECDSA_TOP_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_ecdsa_top_test.wlf
}

#################################################################################
# DSA_KCDSA_SIGN_TEST 
#################################################################################

alias run_peripheral_dsa_kcdsa_sign_test {
  echo "TEST: DSA_KCDSA_SIGN_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_KCDSA_SIGN_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_SIGN_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_SIGN_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_kcdsa_sign_test.wlf
}

#################################################################################
# DSA_KCDSA_VERIFY_TEST 
#################################################################################

alias run_peripheral_dsa_kcdsa_verify_test {
  echo "TEST: DSA_KCDSA_VERIFY_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_KCDSA_VERIFY_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_VERIFY_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_VERIFY_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_kcdsa_verify_test.wlf
}

#################################################################################
# DSA_KCDSA_TOP_TEST 
#################################################################################

alias run_peripheral_dsa_kcdsa_top_test {
  echo "TEST: DSA_KCDSA_TOP_TEST"

  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_package.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $test_path/vhdl/peripheral/peripheral_dsa_testbench.vhd

  vsim -g /peripheral_dsa_testbench/DSA_KCDSA_TOP_TEST=true -t ps +notimingchecks -L unisim work.peripheral_dsa_testbench

  #MACROS
  add log -r sim:/peripheral_dsa_testbench/*

  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_TOP_TEST true 0
  force -freeze sim:/peripheral_dsa_package/DSA_KCDSA_TOP_CASE_1 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/peripheral_dsa_kcdsa_top_test.wlf
}

#################################################################################

alias v01 {
  run_peripheral_dsa_sha256_test
}

alias v02 {
  run_peripheral_dsa_sha512_test
}

alias v03 {
  run_peripheral_dsa_adder_test
}

alias v04 {
  run_peripheral_dsa_inverter_test
}

alias v05 {
  run_peripheral_dsa_multiplier_test
}

alias v06 {
  run_peripheral_dsa_point_adder_test
}

alias v07 {
  run_peripheral_dsa_point_doubler_test
}

alias v08 {
  run_peripheral_dsa_point_generator_test
}

alias v09 {
  run_peripheral_dsa_ecdsa_sign_test
}

alias v10 {
  run_peripheral_dsa_ecdsa_verify_test
}

alias v11 {
  run_peripheral_dsa_ecdsa_top_test
}

alias v12 {
  run_peripheral_dsa_kcdsa_sign_test
}

alias v13 {
  run_peripheral_dsa_kcdsa_verify_test
}

alias v14 {
  run_peripheral_dsa_kcdsa_top_test
}

echo "************************************************************"
echo "v01 . DSA-SHA256"
echo "v02 . DSA-SHA512"
echo "v03 . DSA-ADDER"
echo "v04 . DSA-INVERTER"
echo "v05 . DSA-MULTIPLIER"
echo "v06 . DSA-POINT_ADDER"
echo "v07 . DSA-POINT_DOUBLER"
echo "v08 . DSA-POINT_GENERATOR"
echo "v09 . DSA-ECDSA-SIGN"
echo "v10 . DSA-ECDSA-VERIFY"
echo "v11 . DSA-ECDSA-TOP"
echo "v12 . DSA-KCDSA-SIGN"
echo "v13 . DSA-KCDSA-VERIFY"
echo "v14 . DSA-KCDSA-TOP"
echo "************************************************************"
