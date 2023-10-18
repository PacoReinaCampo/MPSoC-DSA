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
--              MPSoC-DSA                                                     --
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

package ecdsa_sha256_pkg is

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

end ecdsa_sha256_pkg;

package body ecdsa_sha256_pkg is

end ecdsa_sha256_pkg;
