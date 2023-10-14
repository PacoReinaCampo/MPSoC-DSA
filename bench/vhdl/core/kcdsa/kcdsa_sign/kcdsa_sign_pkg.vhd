--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              MII/MIERA TFM                                                 --
--              ECDSA/KCDSA                                                   --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2022-2023 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;

--library unisim;
--use unisim.vcomponents.all;

--library modelsim_lib;
--use modelsim_lib.util.all;

package kcdsa_sign_pkg is

  ------------------------------------------------------------------------------
  -- TYPES
  ------------------------------------------------------------------------------

  type std_logic_matrix_2x4 is array (1 to 2) of std_logic_vector(3 downto 0);
  type std_logic_matrix_4x4 is array (1 to 4) of std_logic_vector(3 downto 0);

  type std_logic_matrix_2x128 is array (1 to 2) of std_logic_vector(127 downto 0);
  type std_logic_matrix_4x128 is array (1 to 4) of std_logic_vector(127 downto 0);
  type std_logic_matrix_6x128 is array (1 to 6) of std_logic_vector(127 downto 0);

  type std_logic_matrix_2x512 is array (1 to 2) of std_logic_vector(0 to 511);
  type std_logic_matrix_2x1024 is array (1 to 2) of std_logic_vector(0 to 1023);

  -------------------------------------------------------------------------------
  -- CONSTANTS
  -------------------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  -- GLOBAL
  constant DATA_SIZE : integer := 512;

  constant BLOCK_SIZE : integer := 4;

  -- SECP 256
  constant SECP256_P : std_logic_vector(255 downto 0) := X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F";
  constant SECP256_A : std_logic_vector(255 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
  constant SECP256_B : std_logic_vector(255 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000007";
  constant SECP256_X : std_logic_vector(255 downto 0) := X"79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  constant SECP256_Y : std_logic_vector(255 downto 0) := X"483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
  constant SECP256_N : std_logic_vector(255 downto 0) := X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141";

  -- BLACKPOOL 512
  constant BLACKPOOL512_P : std_logic_vector(511 downto 0) := X"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA703308717D4D9B009BC66842AECDA12AE6A380E62881FF2F2D82C68528AA6056583A48F3";
  constant BLACKPOOL512_A : std_logic_vector(511 downto 0) := X"7830A3318B603B89E2327145AC234CC594CBDD8D3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CA";
  constant BLACKPOOL512_B : std_logic_vector(511 downto 0) := X"3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CADC083E67984050B75EBAE5DD2809BD638016F723";
  constant BLACKPOOL512_X : std_logic_vector(511 downto 0) := X"81AEE4BDD82ED9645A21322E9C4C6A9385ED9F70B5D916C1B43B62EEF4D0098EFF3B1F78E2D0D48D50D1687B93B97D5F7C6D5047406A5E688B352209BCB9F822";
  constant BLACKPOOL512_Y : std_logic_vector(511 downto 0) := X"7DDE385D566332ECC0EABFA9CF7822FDF209F70024A57B1AA000C55B881F8111B2DCDE494A5F485E5BCA4BD88A2763AED1CA2B2FA8F0540678CD1E0F3AD80892";
  constant BLACKPOOL512_N : std_logic_vector(511 downto 0) := X"AADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA70330870553E5C414CA92619418661197FAC10471DB1D381085DDADDB58796829CA90069";

  -- ECDSA-SHA256 --
  constant WORD_SIZE_256 : integer := 32;

  -- Test Case 1
  constant DATA_BLOCK_SIZE_256_1 : std_logic_vector(BLOCK_SIZE-1 downto 0) := X"1";

  constant DATA_INPUT_256_1 : std_logic_vector(0 to 16*WORD_SIZE_256-1) := X"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";

  constant DATA_OUTPUT_256_1 : std_logic_vector(255 downto 0) := X"BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD";

  -- Test Case 2
  constant DATA_BLOCK_SIZE_256_2 : std_logic_vector(BLOCK_SIZE-1 downto 0) := X"2";

  constant DATA_INPUT_256_0_2 : std_logic_vector(0 to 16*WORD_SIZE_256-1) := X"6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000";
  constant DATA_INPUT_256_1_2 : std_logic_vector(0 to 16*WORD_SIZE_256-1) := X"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0";

  constant DATA_INPUT_256_2 : std_logic_matrix_2x512 := (DATA_INPUT_256_0_2, DATA_INPUT_256_1_2);

  constant DATA_OUTPUT_256_2 : std_logic_vector(255 downto 0) := X"248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1";

  -- ECDSA-SHA512 --
  constant WORD_SIZE_512 : integer := 64;

  -- Test Case 1
  constant DATA_BLOCK_SIZE_512_1 : std_logic_vector(BLOCK_SIZE-1 downto 0) := X"1";

  constant DATA_INPUT_512_1 : std_logic_vector(0 to 16*WORD_SIZE_512-1) := X"6162638000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";

  constant DATA_OUTPUT_512_1 : std_logic_vector(511 downto 0) := X"DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F";

  -- Test Case 2
  constant DATA_BLOCK_SIZE_512_2 : std_logic_vector(BLOCK_SIZE-1 downto 0) := X"2";

  constant DATA_INPUT_512_0_2 : std_logic_vector(0 to 16*WORD_SIZE_512-1) := X"61626364656667686263646566676869636465666768696A6465666768696A6B65666768696A6B6C666768696A6B6C6D6768696A6B6C6D6E68696A6B6C6D6E6F696A6B6C6D6E6F706A6B6C6D6E6F70716B6C6D6E6F7071726C6D6E6F707172736D6E6F70717273746E6F70717273747580000000000000000000000000000000";
  constant DATA_INPUT_512_1_2 : std_logic_vector(0 to 16*WORD_SIZE_512-1) := X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000380";

  constant DATA_INPUT_512_2 : std_logic_matrix_2x1024 := (DATA_INPUT_512_0_2, DATA_INPUT_512_1_2);

  constant DATA_OUTPUT_512_2 : std_logic_vector(511 downto 0) := X"8E959B75DAE313DA8CF4F72814FC143F8F7779C6EB9F7FA17299AEADB6889018501D289E4900F7E4331B99DEC4B5433AC7D329EEB6DD26545E96E55B874BE909";

  -- ECDSA-ADDER --

  -- Test Case 1
  constant ADDER_DATA_A_IN : std_logic_vector(DATA_SIZE-1 downto 0) := X"968585ca02542195330b93c76fe058be5b4e33b8a72c740f355b21244eb85c1555066ce4b725eba96aa5b9cbf53956a379e408bc93213b8df35dbbb042e80fb7";
  constant ADDER_DATA_B_IN : std_logic_vector(DATA_SIZE-1 downto 0) := X"237c710f6e0bcb17f32fa5b611b9f0a5acff27966ebc07ab77a4bbd790cd51682e059f9cf821eb2516bdece645d667461961737f2869ea6b975d05adb8ee9009";

  -- Adder (operation = '0')
  constant ADDER_DATA_OUT : std_logic_vector(DATA_SIZE-1 downto 0) := X"0F24592094762821E66652CF4DD04D5C3D1CCD9B621EA9ABD69C40316F52A50C05BE718113816E8BD2960587546C3D036AC37D0C8E085F7462106107A39C56CD";
  
  -- Subtractor (operation = '1')
--constant ADDER_DATA_OUT : std_logic_vector(DATA_SIZE-1 downto 0) := X"730914BA9448567D3FDBEE115E266818AE4F0C2238706C63BDB6654CBDEB0AAD2700CD47BF04008453E7CCE5AF62EF5D6082953D6AB751225C00B60289F97FAE";

  -- ECDSA-INVERTER --

  -- Test Case 1
  constant INVERTER_DATA_IN  : std_logic_vector(DATA_SIZE-1 downto 0) := X"968585ca02542195330b93c76fe058be5b4e33b8a72c740f355b21244eb85c1555066ce4b725eba96aa5b9cbf53956a379e408bc93213b8df35dbbb042e80fb7";
  constant INVERTER_DATA_OUT : std_logic_vector(DATA_SIZE-1 downto 0) := X"9b05074d6441d4e9c266978780402d12eb0b518fde9531e0f2226c5756b01a2e231f65f9c7b8b20e7ce7bdf9cd5abca2f0d51b728947830c992f76a3dbbfd2d7";

  -- ECDSA-MULTIPLIER --

  -- Test Case 1
  constant MULTIPLIER_DATA_A_IN : std_logic_vector(DATA_SIZE-1 downto 0) := X"968585ca02542195330b93c76fe058be5b4e33b8a72c740f355b21244eb85c1555066ce4b725eba96aa5b9cbf53956a379e408bc93213b8df35dbbb042e80fb7";
  constant MULTIPLIER_DATA_B_IN : std_logic_vector(DATA_SIZE-1 downto 0) := X"237c710f6e0bcb17f32fa5b611b9f0a5acff27966ebc07ab77a4bbd790cd51682e059f9cf821eb2516bdece645d667461961737f2869ea6b975d05adb8ee9009";
  constant MULTIPLIER_DATA_OUT  : std_logic_vector(DATA_SIZE-1 downto 0) := X"14b54ce2adde1e952a1dfff78fa0b248349dc215839cfa964995f6930053770dd184ba24a26015124760cc678d3a7d9536f711017182f0a8813f263c8d2b45f0";

  -- ECDSA-POINT_ADDER --

  -- Test Case 1
  constant POINT_ADDER_IN_PX  : std_logic_vector(DATA_SIZE-1 downto 0) := X"968585ca02542195330b93c76fe058be5b4e33b8a72c740f355b21244eb85c1555066ce4b725eba96aa5b9cbf53956a379e408bc93213b8df35dbbb042e80fb7";
  constant POINT_ADDER_IN_PY  : std_logic_vector(DATA_SIZE-1 downto 0) := X"237c710f6e0bcb17f32fa5b611b9f0a5acff27966ebc07ab77a4bbd790cd51682e059f9cf821eb2516bdece645d667461961737f2869ea6b975d05adb8ee9009";
  constant POINT_ADDER_IN_QX  : std_logic_vector(DATA_SIZE-1 downto 0) := X"199560dbf7945ade5d41eb9716a42619385db9d4f6c8a5fd6197c68aa3f3f14640143129495f3f8ff1d3d41c2e56651e1aeeb7b63852ba3b29aa42bc27e7f368";
  constant POINT_ADDER_IN_QY  : std_logic_vector(DATA_SIZE-1 downto 0) := X"8c6c5131418cda5d31fdfaeb24df1a5ba534300c02384e7827f992b2f81f44f574db44cc8d5608f06a4ea4a9ec0e8cbb46ac87305050eb25ce76ad002d3d9f66";
  constant POINT_ADDER_OUT_RX : std_logic_vector(DATA_SIZE-1 downto 0) := X"53f82eff94c8c8755fc47fa159e88edebc8d4bc8a24ed07c9b1c46fe0c303499d8a0ec5c46832baa808677feaa473644912b19605fad795bb6de8977b67a2dcf";
  constant POINT_ADDER_OUT_RY : std_logic_vector(DATA_SIZE-1 downto 0) := X"8f942748e67129bf65e72f87993312fcbe8f04d64d05659d1bc1f81f63da91ed72a3ca25c0cc1c2291387e0732c4cd984415fa6c76987e104e700d7ba6f83523";

  -- ECDSA-POINT_DOUBLER --

  -- Test Case 1
  constant POINT_DOUBLER_IN_PX  : std_logic_vector(DATA_SIZE-1 downto 0) := X"968585ca02542195330b93c76fe058be5b4e33b8a72c740f355b21244eb85c1555066ce4b725eba96aa5b9cbf53956a379e408bc93213b8df35dbbb042e80fb7";
  constant POINT_DOUBLER_IN_PY  : std_logic_vector(DATA_SIZE-1 downto 0) := X"237c710f6e0bcb17f32fa5b611b9f0a5acff27966ebc07ab77a4bbd790cd51682e059f9cf821eb2516bdece645d667461961737f2869ea6b975d05adb8ee9009";
  constant POINT_DOUBLER_OUT_RX : std_logic_vector(DATA_SIZE-1 downto 0) := X"0fb1a6e0f495befca9977b4e751d044554880d1ea752efcfac20ff6a0132dc13d3eab56654537f7444d4fedd1bb8fa51b9eb9362c8accc255a7cd26be6d96138";
  constant POINT_DOUBLER_OUT_RY : std_logic_vector(DATA_SIZE-1 downto 0) := X"aad5ce0e13356da98b0e9507b92e3a8fb497e73a39f7424d859d90b589457ca85e359ad163e403cf02355fa0d035d232334c9863e9ddddae9243e4d46f3cfcb9";

  -- ECDSA-POINT_GENERATOR --

  -- Test Case 1
  constant POINT_GENERATOR_PRIVATE_KEY : std_logic_vector(DATA_SIZE-1 downto 0) := X"483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b879be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798";

  constant POINT_GENERATOR_IN_X  : std_logic_vector(DATA_SIZE-1 downto 0) := X"81AEE4BDD82ED9645A21322E9C4C6A9385ED9F70B5D916C1B43B62EEF4D0098EFF3B1F78E2D0D48D50D1687B93B97D5F7C6D5047406A5E688B352209BCB9F822";
  constant POINT_GENERATOR_IN_Y  : std_logic_vector(DATA_SIZE-1 downto 0) := X"7DDE385D566332ECC0EABFA9CF7822FDF209F70024A57B1AA000C55B881F8111B2DCDE494A5F485E5BCA4BD88A2763AED1CA2B2FA8F0540678CD1E0F3AD80892";
  constant POINT_GENERATOR_OUT_X : std_logic_vector(DATA_SIZE-1 downto 0) := X"795bfae624839f52e202993651afa2f25dc0f6f83e9fce4f72592b3f05209d5e2510fc3760cd90de1d8f6b7e82bb9db340b972314a9fa95b12191e63ef40dce2";
  constant POINT_GENERATOR_OUT_Y : std_logic_vector(DATA_SIZE-1 downto 0) := X"a4e291d6b6f15b0a8060c6c9c5acdedac4b914e4944423842e0dd9be2827b9c6b24608f231d64680323ba92c811c875b587c9ca0f6697e5bbda23b84027b5424";

  -- KCDSA-SIGN --

  -- Test Case 1
  constant SIGN_PRIVATE_KEY_KCDSA   : std_logic_vector(DATA_SIZE-1 downto 0) := X"6b1565c2466dfaf5dc545a560d0aeb6f5f4a1f866de4f168562aae68e7e1e2ca6e09acf92db233e9be279d64e38f1834d546831693e7a283971cfe4e9de1ea07";
  constant SIGN_GENERATED_KEY_KCDSA : std_logic_vector(DATA_SIZE-1 downto 0) := X"483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b879be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798";

  constant SIGN_DATA_BLOCK_SIZE_KCDSA : std_logic_vector(BLOCK_SIZE-1 downto 0)   := X"1";
  constant SIGN_MESSAGE_KCDSA         : std_logic_vector(0 to 16*WORD_SIZE_512-1) := X"6162638000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
  constant SIGN_HASH_KCDSA            : std_logic_vector(DATA_SIZE-1 downto 0)    := X"ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f";

  constant SIGN_SIGNATURE_R_KCDSA : std_logic_vector(DATA_SIZE-1 downto 0) := X"90884d211e23b9b8b180bea96f91d07e7449bd8b5cd669dda187da207e63867023f109aba14f01e13fc9fa912307ff0948517c33d53841f1804f0075c18821a5";
  constant SIGN_SIGNATURE_S_KCDSA : std_logic_vector(DATA_SIZE-1 downto 0) := X"815C80530C3E941DF1C479574B2303FA7D2150F5F0008524E18A52C580F0C01AC98F7553743E2D1CB1FA22DDA0C69D6845C8A2817115DB145AC38A80F8C18732";

end kcdsa_sign_pkg;

package body kcdsa_sign_pkg is

end kcdsa_sign_pkg;
