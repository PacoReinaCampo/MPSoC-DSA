###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral for MPSoC                                             ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2015-2016 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

../../../../../../rtl/vhdl/pkg/peripheral_dsa_pkg.vhd
../../../../../../rtl/vhdl/pkg/peripheral_dsa_sha512_pkg.vhd
../../../../../../rtl/vhdl/core/sha/peripheral_dsa_sha512.vhd
../../../../../../rtl/vhdl/core/modular/peripheral_dsa_mod.vhd
../../../../../../rtl/vhdl/core/modular/peripheral_dsa_adder.vhd
../../../../../../rtl/vhdl/core/modular/peripheral_dsa_inverter.vhd
../../../../../../rtl/vhdl/core/modular/peripheral_dsa_multiplier.vhd
../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_adder.vhd
../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_doubler.vhd
../../../../../../rtl/vhdl/core/generation/peripheral_dsa_point_generator.vhd
../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_sign.vhd
../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_verify.vhd
../../../../../../rtl/vhdl/core/ecdsa/peripheral_dsa_ecdsa_top.vhd
../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_sign.vhd
../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_verify.vhd
../../../../../../rtl/vhdl/core/kcdsa/peripheral_dsa_kcdsa_top.vhd

../../../../../../bench/vhdl/core/ecdsa/peripheral_dsa_ecdsa_sign/peripheral_dsa_ecdsa_sign_pkg.vhd
../../../../../../bench/vhdl/core/ecdsa/peripheral_dsa_ecdsa_sign/peripheral_dsa_ecdsa_sign_stimulus.vhd
../../../../../../bench/vhdl/core/ecdsa/peripheral_dsa_ecdsa_sign/peripheral_dsa_ecdsa_sign_testbench.vhd
