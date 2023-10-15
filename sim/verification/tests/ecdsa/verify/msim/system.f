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

../../../../../../rtl/vhdl/pkg/ecdsa_pkg.vhd
../../../../../../rtl/vhdl/pkg/ecdsa_sha512_pkg.vhd
../../../../../../rtl/vhdl/core/sha/ecdsa_sha512.vhd
../../../../../../rtl/vhdl/core/modular/ecdsa_mod.vhd
../../../../../../rtl/vhdl/core/modular/ecdsa_adder.vhd
../../../../../../rtl/vhdl/core/modular/ecdsa_inverter.vhd
../../../../../../rtl/vhdl/core/modular/ecdsa_multiplier.vhd
../../../../../../rtl/vhdl/core/generation/ecdsa_point_adder.vhd
../../../../../../rtl/vhdl/core/generation/ecdsa_point_doubler.vhd
../../../../../../rtl/vhdl/core/generation/ecdsa_point_generator.vhd
../../../../../../rtl/vhdl/core/ecdsa/ecdsa_sign.vhd
../../../../../../rtl/vhdl/core/ecdsa/ecdsa_verify.vhd
../../../../../../rtl/vhdl/core/ecdsa/ecdsa_top.vhd
../../../../../../rtl/vhdl/core/kcdsa/kcdsa_sign.vhd
../../../../../../rtl/vhdl/core/kcdsa/kcdsa_verify.vhd
../../../../../../rtl/vhdl/core/kcdsa/kcdsa_top.vhd

../../../../../../bench/vhdl/core/ecdsa/ecdsa_verify/ecdsa_verify_pkg.vhd
../../../../../../bench/vhdl/core/ecdsa/ecdsa_verify/ecdsa_verify_stimulus.vhd
../../../../../../bench/vhdl/core/ecdsa/ecdsa_verify/ecdsa_verify_testbench.vhd
