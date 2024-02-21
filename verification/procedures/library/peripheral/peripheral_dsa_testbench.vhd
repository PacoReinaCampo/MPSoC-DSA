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

use std.textio.all;

use work.peripheral_dsa_package.all;

entity peripheral_dsa_testbench is
  generic (
    -- ECDSA-FUNCTIONALITY
    DSA_SHA256_TEST          : boolean := false;
    DSA_SHA512_TEST          : boolean := false;
    DSA_ADDER_TEST           : boolean := false;
    DSA_INVERTER_TEST        : boolean := false;
    DSA_MULTIPLIER_TEST      : boolean := false;
    DSA_POINT_ADDER_TEST     : boolean := false;
    DSA_POINT_DOUBLER_TEST   : boolean := false;
    DSA_POINT_GENERATOR_TEST : boolean := false;
    DSA_ECDSA_SIGN_TEST            : boolean := false;
    DSA_ECDSA_VERIFY_TEST          : boolean := false;
    DSA_ECDSA_TOP_TEST             : boolean := false;
    DSA_KCDSA_SIGN_TEST            : boolean := false;
    DSA_KCDSA_VERIFY_TEST          : boolean := false;
    DSA_KCDSA_TOP_TEST             : boolean := false;

    -- ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_testbench;

architecture peripheral_dsa_testbench_architecture of peripheral_dsa_testbench is

  component peripheral_dsa_stimulus is
    generic (
      -- ECDSA-SIZE
      BLOCK_SIZE    : integer := 4;
      WORD_SIZE_256 : integer := 32;
      WORD_SIZE_512 : integer := 64
      );
    port (
      CLK : out std_logic;
      RST : out std_logic;

      -------------------------------------------------------
      -- DSA-SHA256
      -------------------------------------------------------

      -- CONTROL
      DSA_SHA256_START : out std_logic;
      DSA_SHA256_READY : in  std_logic;

      DSA_SHA256_DATA_IN_ENABLE  : out std_logic;
      DSA_SHA256_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      DSA_SHA256_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_SHA256_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_256-1);
      DSA_SHA256_DATA_OUT : in  std_logic_vector(WORD_SIZE_256*8-1 downto 0);

      -------------------------------------------------------
      -- DSA-SHA512
      -------------------------------------------------------

      -- CONTROL
      DSA_SHA512_START : out std_logic;
      DSA_SHA512_READY : in  std_logic;

      DSA_SHA512_DATA_IN_ENABLE  : out std_logic;
      DSA_SHA512_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      DSA_SHA512_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_SHA512_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_512-1);
      DSA_SHA512_DATA_OUT : in  std_logic_vector(WORD_SIZE_512*8-1 downto 0);

      -------------------------------------------------------
      -- DSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      DSA_ADDER_START : out std_logic;
      DSA_ADDER_READY : in  std_logic;

      DSA_ADDER_OPERATION : out std_logic;

      -- DATA
      DSA_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      DSA_INVERTER_START : out std_logic;
      DSA_INVERTER_READY : in  std_logic;

      -- DATA
      DSA_INVERTER_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_INVERTER_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      DSA_MULTIPLIER_START : out std_logic;
      DSA_MULTIPLIER_READY : in  std_logic;

      -- DATA
      DSA_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-POINT_ADDER
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_ADDER_START : out std_logic;
      DSA_POINT_ADDER_READY : in  std_logic;

      -- DATA
      DSA_POINT_IN_PX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_IN_PY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_IN_QX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_IN_QY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_RX_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_RY_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_DOUBLER_START : out std_logic;
      DSA_POINT_DOUBLER_READY : in  std_logic;

      -- DATA
      DSA_POINT_IN_PX_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_IN_PY_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_RX_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_RY_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-POINT_GENERATOR
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_GENERATOR_START : out std_logic;
      DSA_POINT_GENERATOR_READY : in  std_logic;

      -- DATA
      DSA_PRIVATE_KEY_GENERATOR : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_POINT_IN_X_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_IN_Y_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_X_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_POINT_OUT_Y_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-ECDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_SIGN_START : out std_logic;
      DSA_ECDSA_SIGN_READY : in  std_logic;

      DSA_ECDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
      DSA_ECDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      DSA_ECDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_ECDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_ECDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_ECDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-ECDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_VERIFY_START : out std_logic;
      DSA_ECDSA_VERIFY_READY : in  std_logic;

      DSA_ECDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
      DSA_ECDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

      DSA_ECDSA_VERIFY_FAIL : in std_logic;

      -- DATA
      DSA_ECDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_ECDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_ECDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_ECDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_TOP_START : out std_logic;
      DSA_ECDSA_TOP_READY : in  std_logic;

      DSA_ECDSA_TOP_DATA_IN_ENABLE  : out std_logic;
      DSA_ECDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

      DSA_ECDSA_TOP_MODE : out std_logic;
      DSA_ECDSA_TOP_FAIL : in  std_logic;

      -- DATA
      DSA_ECDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_ECDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_ECDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_ECDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_ECDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_ECDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_ECDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-KCDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_SIGN_START : out std_logic;
      DSA_KCDSA_SIGN_READY : in  std_logic;

      DSA_KCDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
      DSA_KCDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      DSA_KCDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_KCDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_KCDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_KCDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-KCDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_VERIFY_START : out std_logic;
      DSA_KCDSA_VERIFY_READY : in  std_logic;

      DSA_KCDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
      DSA_KCDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

      DSA_KCDSA_VERIFY_FAIL : in std_logic;

      -- DATA
      DSA_KCDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_KCDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_KCDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_KCDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- DSA-KCDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_TOP_START : out std_logic;
      DSA_KCDSA_TOP_READY : in  std_logic;

      DSA_KCDSA_TOP_DATA_IN_ENABLE  : out std_logic;
      DSA_KCDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

      DSA_KCDSA_TOP_MODE : out std_logic;
      DSA_KCDSA_TOP_FAIL : in  std_logic;

      -- DATA
      DSA_KCDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_KCDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_KCDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      DSA_KCDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      DSA_KCDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      DSA_KCDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      DSA_KCDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_stimulus;

  component peripheral_dsa_sha256 is
    generic (
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 32
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      DATA_IN  : in  std_logic_vector(0 to 16*WORD_SIZE-1);
      DATA_OUT : out std_logic_vector(WORD_SIZE*8-1 downto 0)
      );
  end component;

  component peripheral_dsa_sha512 is
    generic (
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      DATA_IN  : in  std_logic_vector(0 to 16*WORD_SIZE-1);
      DATA_OUT : out std_logic_vector(WORD_SIZE*8-1 downto 0)
      );
  end component;

  component peripheral_dsa_adder is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      -- DATA
      MODULO    : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_inverter is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      MODULO   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_multiplier is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      MODULO    : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_point_adder is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      POINT_IN_PX  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_IN_PY  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_IN_QX  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_IN_QY  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_RX : out std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_RY : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_point_doubler is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      POINT_IN_PX  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_IN_PY  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_RX : out std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_RY : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_point_generator is
    generic (
      DATA_SIZE : integer := 256
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      PRIVATE_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      POINT_IN_X  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_IN_Y  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_X : out std_logic_vector(DATA_SIZE-1 downto 0);
      POINT_OUT_Y : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_ecdsa_sign is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      FAIL : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_ecdsa_verify is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      FAIL : out std_logic;

      -- DATA
      PUBLIC_KEY_X : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_ecdsa_top is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      MODE : in  std_logic;
      FAIL : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      PUBLIC_KEY_X_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_kcdsa_sign is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      FAIL : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_kcdsa_verify is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      FAIL : out std_logic;

      -- DATA
      PUBLIC_KEY_X : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component peripheral_dsa_kcdsa_top is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      MODE : in  std_logic;
      FAIL : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      PUBLIC_KEY_X_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  --

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- DSA-SHA256
  -------------------------------------------------------

  signal start_sha256_int : std_logic;
  signal ready_sha256_int : std_logic;

  signal data_in_enable_sha256_int  : std_logic;
  signal data_out_enable_sha256_int : std_logic;

  signal data_block_size_sha256_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal data_in_sha256_int  : std_logic_vector(0 to 16*WORD_SIZE_256-1);
  signal data_out_sha256_int : std_logic_vector(WORD_SIZE_256*8-1 downto 0);

  -------------------------------------------------------
  -- DSA-SHA512
  -------------------------------------------------------

  signal start_sha512_int : std_logic;
  signal ready_sha512_int : std_logic;

  signal data_in_enable_sha512_int  : std_logic;
  signal data_out_enable_sha512_int : std_logic;

  signal data_block_size_sha512_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal data_in_sha512_int  : std_logic_vector(0 to 16*WORD_SIZE_512-1);
  signal data_out_sha512_int : std_logic_vector(WORD_SIZE_512*8-1 downto 0);

  -------------------------------------------------------
  -- DSA-ADDER
  -------------------------------------------------------

  signal start_adder_int : std_logic;
  signal ready_adder_int : std_logic;

  signal operation_adder_int : std_logic;

  signal data_a_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-INVERTER
  -------------------------------------------------------

  signal start_inverter_int : std_logic;
  signal ready_inverter_int : std_logic;

  signal data_in_inverter_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_inverter_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-MULTIPLIER
  -------------------------------------------------------

  signal start_multiplier_int : std_logic;
  signal ready_multiplier_int : std_logic;

  signal data_a_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_multiplier_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-POINT_ADDER
  -------------------------------------------------------

  signal start_point_adder_int : std_logic;
  signal ready_point_adder_int : std_logic;

  signal point_in_px_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qx_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qy_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-POINT_DOUBLER
  -------------------------------------------------------

  signal start_point_doubler_int : std_logic;
  signal ready_point_doubler_int : std_logic;

  signal point_in_px_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-POINT_GENERATOR
  -------------------------------------------------------

  signal start_point_generator_int : std_logic;
  signal ready_point_generator_int : std_logic;

  signal private_key_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal point_in_x_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_y_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_x_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_y_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-ECDSA-SIGN
  -------------------------------------------------------

  signal start_sign_int : std_logic;
  signal ready_sign_int : std_logic;

  signal fail_sign_int : std_logic;

  signal data_in_enable_sign_int  : std_logic;
  signal data_out_enable_sign_int : std_logic;

  signal private_key_sign_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_sign_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_sign_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-ECDSA-VERIFY
  -------------------------------------------------------

  signal start_verify_int : std_logic;
  signal ready_verify_int : std_logic;

  signal data_in_enable_verify_int  : std_logic;
  signal data_out_enable_verify_int : std_logic;

  signal fail_verify_int : std_logic;

  signal public_key_x_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_verify_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_verify_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-ECDSA-TOP
  -------------------------------------------------------

  signal start_top_int : std_logic;
  signal ready_top_int : std_logic;

  signal data_in_enable_top_int  : std_logic;
  signal data_out_enable_top_int : std_logic;

  signal mode_top_int : std_logic;
  signal fail_top_int : std_logic;

  signal private_key_top_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal public_key_x_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_top_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_top_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal signature_r_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-KCDSA-SIGN
  -------------------------------------------------------

  signal start_peripheral_dsa_kcdsa_sign_int : std_logic;
  signal ready_peripheral_dsa_kcdsa_sign_int : std_logic;

  signal fail_peripheral_dsa_kcdsa_sign_int : std_logic;

  signal data_in_enable_peripheral_dsa_kcdsa_sign_int  : std_logic;
  signal data_out_enable_peripheral_dsa_kcdsa_sign_int : std_logic;

  signal private_key_peripheral_dsa_kcdsa_sign_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_peripheral_dsa_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_peripheral_dsa_kcdsa_sign_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_peripheral_dsa_kcdsa_sign_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_peripheral_dsa_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_peripheral_dsa_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-KCDSA-VERIFY
  -------------------------------------------------------

  signal start_peripheral_dsa_kcdsa_verify_int : std_logic;
  signal ready_peripheral_dsa_kcdsa_verify_int : std_logic;

  signal data_in_enable_peripheral_dsa_kcdsa_verify_int  : std_logic;
  signal data_out_enable_peripheral_dsa_kcdsa_verify_int : std_logic;

  signal fail_peripheral_dsa_kcdsa_verify_int : std_logic;

  signal public_key_x_peripheral_dsa_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_peripheral_dsa_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_peripheral_dsa_kcdsa_verify_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_peripheral_dsa_kcdsa_verify_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_peripheral_dsa_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_peripheral_dsa_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- DSA-KCDSA-TOP
  -------------------------------------------------------

  signal start_peripheral_dsa_kcdsa_top_int : std_logic;
  signal ready_peripheral_dsa_kcdsa_top_int : std_logic;

  signal data_in_enable_peripheral_dsa_kcdsa_top_int  : std_logic;
  signal data_out_enable_peripheral_dsa_kcdsa_top_int : std_logic;

  signal mode_peripheral_dsa_kcdsa_top_int : std_logic;
  signal fail_peripheral_dsa_kcdsa_top_int : std_logic;

  signal private_key_peripheral_dsa_kcdsa_top_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal public_key_x_check_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_check_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_peripheral_dsa_kcdsa_top_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_peripheral_dsa_kcdsa_top_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_check_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_check_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal signature_r_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_peripheral_dsa_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- ************************ peripheral_dsa_stimulus ************************
  -- ***************************************************************************

  peripheral_dsa_stimulus_i : peripheral_dsa_stimulus
    generic map (
      -- ECDSA-SIZE
      BLOCK_SIZE    => BLOCK_SIZE,
      WORD_SIZE_256 => WORD_SIZE_256,
      WORD_SIZE_512 => WORD_SIZE_512
      )
    port map (

      -------------------------------------------------------
      -- GLOBAL
      -------------------------------------------------------

      CLK => clk,
      RST => rst,

      -------------------------------------------------------
      -- DSA-SHA256
      -------------------------------------------------------

      -- CONTROL
      DSA_SHA256_START => start_sha256_int,
      DSA_SHA256_READY => ready_sha256_int,

      DSA_SHA256_DATA_IN_ENABLE  => data_in_enable_sha256_int,
      DSA_SHA256_DATA_OUT_ENABLE => data_out_enable_sha256_int,

      -- DATA
      DSA_SHA256_DATA_BLOCK_SIZE => data_block_size_sha256_int,

      DSA_SHA256_DATA_IN  => data_in_sha256_int,
      DSA_SHA256_DATA_OUT => data_out_sha256_int,

      -------------------------------------------------------
      -- DSA-SHA512
      -------------------------------------------------------

      -- CONTROL
      DSA_SHA512_START => start_sha512_int,
      DSA_SHA512_READY => ready_sha512_int,

      DSA_SHA512_DATA_IN_ENABLE  => data_in_enable_sha512_int,
      DSA_SHA512_DATA_OUT_ENABLE => data_out_enable_sha512_int,

      -- DATA
      DSA_SHA512_DATA_BLOCK_SIZE => data_block_size_sha512_int,

      DSA_SHA512_DATA_IN  => data_in_sha512_int,
      DSA_SHA512_DATA_OUT => data_out_sha512_int,

      -------------------------------------------------------
      -- DSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      DSA_ADDER_START => start_adder_int,
      DSA_ADDER_READY => ready_adder_int,

      DSA_ADDER_OPERATION => operation_adder_int,

      -- DATA
      DSA_ADDER_DATA_A_IN => data_a_in_adder_int,
      DSA_ADDER_DATA_B_IN => data_b_in_adder_int,
      DSA_ADDER_DATA_OUT  => data_out_adder_int,

      -------------------------------------------------------
      -- DSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      DSA_INVERTER_START => start_inverter_int,
      DSA_INVERTER_READY => ready_inverter_int,

      -- DATA
      DSA_INVERTER_DATA_IN  => data_in_inverter_int,
      DSA_INVERTER_DATA_OUT => data_out_inverter_int,

      -------------------------------------------------------
      -- DSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      DSA_MULTIPLIER_START => start_multiplier_int,
      DSA_MULTIPLIER_READY => ready_multiplier_int,

      -- DATA
      DSA_MULTIPLIER_DATA_A_IN => data_a_in_multiplier_int,
      DSA_MULTIPLIER_DATA_B_IN => data_b_in_multiplier_int,
      DSA_MULTIPLIER_DATA_OUT  => data_out_multiplier_int,

      -------------------------------------------------------
      -- DSA-POINT_ADDER
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_ADDER_START => start_point_adder_int,
      DSA_POINT_ADDER_READY => ready_point_adder_int,

      -- DATA
      DSA_POINT_IN_PX_ADDER  => point_in_px_adder_int,
      DSA_POINT_IN_PY_ADDER  => point_in_py_adder_int,
      DSA_POINT_IN_QX_ADDER  => point_in_qx_adder_int,
      DSA_POINT_IN_QY_ADDER  => point_in_qy_adder_int,
      DSA_POINT_OUT_RX_ADDER => point_out_rx_adder_int,
      DSA_POINT_OUT_RY_ADDER => point_out_ry_adder_int,

      -------------------------------------------------------
      -- DSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_DOUBLER_START => start_point_doubler_int,
      DSA_POINT_DOUBLER_READY => ready_point_doubler_int,

      -- DATA
      DSA_POINT_IN_PX_DOUBLER  => point_in_px_doubler_int,
      DSA_POINT_IN_PY_DOUBLER  => point_in_py_doubler_int,
      DSA_POINT_OUT_RX_DOUBLER => point_out_rx_doubler_int,
      DSA_POINT_OUT_RY_DOUBLER => point_out_ry_doubler_int,

      -------------------------------------------------------
      -- DSA-POINT_GENERATOR
      -------------------------------------------------------

      -- CONTROL
      DSA_POINT_GENERATOR_START => start_point_generator_int,
      DSA_POINT_GENERATOR_READY => ready_point_generator_int,

      -- DATA
      DSA_PRIVATE_KEY_GENERATOR => private_key_generator_int,

      DSA_POINT_IN_X_GENERATOR  => point_in_x_generator_int,
      DSA_POINT_IN_Y_GENERATOR  => point_in_y_generator_int,
      DSA_POINT_OUT_X_GENERATOR => point_out_x_generator_int,
      DSA_POINT_OUT_Y_GENERATOR => point_out_y_generator_int,

      -------------------------------------------------------
      -- DSA-ECDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_SIGN_START => start_sign_int,
      DSA_ECDSA_SIGN_READY => ready_sign_int,

      DSA_ECDSA_SIGN_DATA_IN_ENABLE  => data_in_enable_sign_int,
      DSA_ECDSA_SIGN_DATA_OUT_ENABLE => data_out_enable_sign_int,

      -- DATA
      DSA_ECDSA_SIGN_PRIVATE_KEY   => private_key_sign_int,
      DSA_ECDSA_SIGN_GENERATED_KEY => generated_key_sign_int,

      DSA_ECDSA_SIGN_DATA_BLOCK_SIZE => data_block_size_sign_int,

      DSA_ECDSA_SIGN_MESSAGE => message_sign_int,

      DSA_ECDSA_SIGN_SIGNATURE_R => signature_r_sign_int,
      DSA_ECDSA_SIGN_SIGNATURE_S => signature_s_sign_int,

      -------------------------------------------------------
      -- DSA-ECDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_VERIFY_START => start_verify_int,
      DSA_ECDSA_VERIFY_READY => ready_verify_int,

      DSA_ECDSA_VERIFY_DATA_IN_ENABLE  => data_in_enable_verify_int,
      DSA_ECDSA_VERIFY_DATA_OUT_ENABLE => data_out_enable_verify_int,

      DSA_ECDSA_VERIFY_FAIL => fail_verify_int,

      -- DATA
      DSA_ECDSA_VERIFY_PUBLIC_KEY_X => public_key_x_verify_int,
      DSA_ECDSA_VERIFY_PUBLIC_KEY_Y => public_key_y_verify_int,

      DSA_ECDSA_VERIFY_DATA_BLOCK_SIZE => data_block_size_verify_int,

      DSA_ECDSA_VERIFY_MESSAGE => message_verify_int,

      DSA_ECDSA_VERIFY_SIGNATURE_R => signature_r_verify_int,
      DSA_ECDSA_VERIFY_SIGNATURE_S => signature_s_verify_int,

      -------------------------------------------------------
      -- DSA-ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      DSA_ECDSA_TOP_START => start_top_int,
      DSA_ECDSA_TOP_READY => ready_top_int,

      DSA_ECDSA_TOP_DATA_IN_ENABLE  => data_in_enable_top_int,
      DSA_ECDSA_TOP_DATA_OUT_ENABLE => data_out_enable_top_int,

      DSA_ECDSA_TOP_MODE => mode_top_int,
      DSA_ECDSA_TOP_FAIL => fail_top_int,

      -- DATA
      DSA_ECDSA_TOP_PRIVATE_KEY   => private_key_top_int,
      DSA_ECDSA_TOP_GENERATED_KEY => generated_key_top_int,

      DSA_ECDSA_TOP_PUBLIC_KEY_X_CHECK => public_key_x_check_top_int,
      DSA_ECDSA_TOP_PUBLIC_KEY_Y_CHECK => public_key_y_check_top_int,

      DSA_ECDSA_TOP_DATA_BLOCK_SIZE => data_block_size_top_int,

      DSA_ECDSA_TOP_MESSAGE => message_top_int,

      DSA_ECDSA_TOP_SIGNATURE_R_CHECK => signature_r_check_top_int,
      DSA_ECDSA_TOP_SIGNATURE_S_CHECK => signature_s_check_top_int,

      DSA_ECDSA_TOP_SIGNATURE_R => signature_r_top_int,
      DSA_ECDSA_TOP_SIGNATURE_S => signature_s_top_int,

      -------------------------------------------------------
      -- DSA-KCDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_SIGN_START => start_peripheral_dsa_kcdsa_sign_int,
      DSA_KCDSA_SIGN_READY => ready_peripheral_dsa_kcdsa_sign_int,

      DSA_KCDSA_SIGN_DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_sign_int,
      DSA_KCDSA_SIGN_DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_sign_int,

      -- DATA
      DSA_KCDSA_SIGN_PRIVATE_KEY   => private_key_peripheral_dsa_kcdsa_sign_int,
      DSA_KCDSA_SIGN_GENERATED_KEY => generated_key_peripheral_dsa_kcdsa_sign_int,

      DSA_KCDSA_SIGN_DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_sign_int,

      DSA_KCDSA_SIGN_MESSAGE => message_peripheral_dsa_kcdsa_sign_int,

      DSA_KCDSA_SIGN_SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_sign_int,
      DSA_KCDSA_SIGN_SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_sign_int,

      -------------------------------------------------------
      -- DSA-KCDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_VERIFY_START => start_peripheral_dsa_kcdsa_verify_int,
      DSA_KCDSA_VERIFY_READY => ready_peripheral_dsa_kcdsa_verify_int,

      DSA_KCDSA_VERIFY_DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_verify_int,
      DSA_KCDSA_VERIFY_DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_verify_int,

      DSA_KCDSA_VERIFY_FAIL => fail_peripheral_dsa_kcdsa_verify_int,

      -- DATA
      DSA_KCDSA_VERIFY_PUBLIC_KEY_X => public_key_x_peripheral_dsa_kcdsa_verify_int,
      DSA_KCDSA_VERIFY_PUBLIC_KEY_Y => public_key_y_peripheral_dsa_kcdsa_verify_int,

      DSA_KCDSA_VERIFY_DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_verify_int,

      DSA_KCDSA_VERIFY_MESSAGE => message_peripheral_dsa_kcdsa_verify_int,

      DSA_KCDSA_VERIFY_SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_verify_int,
      DSA_KCDSA_VERIFY_SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_verify_int,

      -------------------------------------------------------
      -- DSA-KCDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      DSA_KCDSA_TOP_START => start_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_READY => ready_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_MODE => mode_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_FAIL => fail_peripheral_dsa_kcdsa_top_int,

      -- DATA
      DSA_KCDSA_TOP_PRIVATE_KEY   => private_key_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_GENERATED_KEY => generated_key_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_PUBLIC_KEY_X_CHECK => public_key_x_check_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_PUBLIC_KEY_Y_CHECK => public_key_y_check_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_MESSAGE => message_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_SIGNATURE_R_CHECK => signature_r_check_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_SIGNATURE_S_CHECK => signature_s_check_peripheral_dsa_kcdsa_top_int,

      DSA_KCDSA_TOP_SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_top_int,
      DSA_KCDSA_TOP_SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_top_int
      );

  -- ***************************************************************************
  -- ************************** peripheral_dsa_sha256 **************************
  -- ***************************************************************************

  peripheral_dsa_sha256_if : if (DSA_SHA256_TEST) generate
    peripheral_dsa_sha256_dut : peripheral_dsa_sha256
      generic map (
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_256
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_sha256_int,
        READY => ready_sha256_int,

        DATA_IN_ENABLE  => data_in_enable_sha256_int,
        DATA_OUT_ENABLE => data_out_enable_sha256_int,

        -- DATA
        DATA_BLOCK_SIZE => data_block_size_sha256_int,

        DATA_IN  => data_in_sha256_int,
        DATA_OUT => data_out_sha256_int
        );

    peripheral_dsa_sha256_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_sha256_int = '1') then
          assert data_out_sha256_int = DATA_OUTPUT_256_2
            report "SCALAR SHA256: CALCULATED = " & to_string(data_out_sha256_int) & "; CORRECT = " & to_string(DATA_OUTPUT_256_2)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_sha256_assertion;
  end generate peripheral_dsa_sha256_if;

  -- ***************************************************************************
  -- ************************** peripheral_dsa_sha512 **************************
  -- ***************************************************************************

  peripheral_dsa_sha512_if : if (DSA_SHA512_TEST) generate
    peripheral_dsa_sha512_dut : peripheral_dsa_sha512
      generic map (
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_sha512_int,
        READY => ready_sha512_int,

        DATA_IN_ENABLE  => data_in_enable_sha512_int,
        DATA_OUT_ENABLE => data_out_enable_sha512_int,

        -- DATA
        DATA_BLOCK_SIZE => data_block_size_sha512_int,

        DATA_IN  => data_in_sha512_int,
        DATA_OUT => data_out_sha512_int
        );

    peripheral_dsa_sha512_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_sha512_int = '1') then
          assert data_out_sha512_int = DATA_OUTPUT_512_2
            report "SCALAR SHA512: CALCULATED = " & to_string(data_out_sha512_int) & "; CORRECT = " & to_string(DATA_OUTPUT_512_2)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_sha512_assertion;
  end generate peripheral_dsa_sha512_if;

  -- ***************************************************************************
  -- *************************** peripheral_dsa_adder **************************
  -- ***************************************************************************

  peripheral_dsa_adder_if : if (DSA_ADDER_TEST) generate
    peripheral_dsa_adder_dut : peripheral_dsa_adder
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_adder_int,
        READY => ready_adder_int,

        OPERATION => operation_adder_int,

        -- DATA
        MODULO    => BLACKPOOL512_P,
        DATA_A_IN => data_a_in_adder_int,
        DATA_B_IN => data_b_in_adder_int,
        DATA_OUT  => data_out_adder_int
        );

    peripheral_dsa_adder_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_adder_int = '1') then
          assert data_out_adder_int = ADDER_DATA_OUT
            report "SCALAR ADDER: CALCULATED = " & to_string(data_out_adder_int) & "; CORRECT = " & to_string(ADDER_DATA_OUT)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_adder_assertion;
  end generate peripheral_dsa_adder_if;

  -- ***************************************************************************
  -- ************************* peripheral_dsa_inverter *************************
  -- ***************************************************************************

  peripheral_dsa_inverter_if : if (DSA_INVERTER_TEST) generate
    peripheral_dsa_inverter_dut : peripheral_dsa_inverter
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_inverter_int,
        READY => ready_inverter_int,

        -- DATA
        MODULO   => BLACKPOOL512_P,
        DATA_IN  => data_in_inverter_int,
        DATA_OUT => data_out_inverter_int
        );

    peripheral_dsa_inverter_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_inverter_int = '1') then
          assert data_out_inverter_int = INVERTER_DATA_OUT
            report "SCALAR INVERTER: CALCULATED = " & to_string(data_out_inverter_int) & "; CORRECT = " & to_string(INVERTER_DATA_OUT)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_inverter_assertion;
  end generate peripheral_dsa_inverter_if;

  -- ***************************************************************************
  -- ************************ peripheral_dsa_multiplier ************************
  -- ***************************************************************************

  peripheral_dsa_multiplier_if : if (DSA_MULTIPLIER_TEST) generate
    peripheral_dsa_multiplier_dut : peripheral_dsa_multiplier
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_multiplier_int,
        READY => ready_multiplier_int,

        -- DATA
        MODULO    => BLACKPOOL512_P,
        DATA_A_IN => data_a_in_multiplier_int,
        DATA_B_IN => data_b_in_multiplier_int,
        DATA_OUT  => data_out_multiplier_int
        );

    peripheral_dsa_multiplier_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_multiplier_int = '1') then
          assert data_out_multiplier_int = MULTIPLIER_DATA_OUT
            report "SCALAR MULTIPLIER: CALCULATED = " & to_string(data_out_multiplier_int) & "; CORRECT = " & to_string(MULTIPLIER_DATA_OUT)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_multiplier_assertion;
  end generate peripheral_dsa_multiplier_if;

  -- ***************************************************************************
  -- ************************ peripheral_dsa_point_adder ***********************
  -- ***************************************************************************

  peripheral_dsa_point_adder_if : if (DSA_POINT_ADDER_TEST) generate
    peripheral_dsa_point_adder_dut : peripheral_dsa_point_adder
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_point_adder_int,
        READY => ready_point_adder_int,

        -- DATA
        POINT_IN_PX  => point_in_px_adder_int,
        POINT_IN_PY  => point_in_py_adder_int,
        POINT_IN_QX  => point_in_qx_adder_int,
        POINT_IN_QY  => point_in_qy_adder_int,
        POINT_OUT_RX => point_out_rx_adder_int,
        POINT_OUT_RY => point_out_ry_adder_int
        );

    peripheral_dsa_point_adder_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_point_adder_int = '1') then
          assert point_out_rx_adder_int = POINT_ADDER_OUT_RX
            report "SCALAR ADDER: CALCULATED = " & to_string(point_out_rx_adder_int) & "; CORRECT = " & to_string(POINT_ADDER_OUT_RX)
            severity error;

          assert point_out_ry_adder_int = POINT_ADDER_OUT_RY
            report "SCALAR ADDER: CALCULATED = " & to_string(point_out_ry_adder_int) & "; CORRECT = " & to_string(POINT_ADDER_OUT_RY)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_point_adder_assertion;
  end generate peripheral_dsa_point_adder_if;

  -- ***************************************************************************
  -- *********************** peripheral_dsa_point_doubler **********************
  -- ***************************************************************************

  peripheral_dsa_point_doubler_if : if (DSA_POINT_DOUBLER_TEST) generate
    peripheral_dsa_point_doubler_dut : peripheral_dsa_point_doubler
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_point_doubler_int,
        READY => ready_point_doubler_int,

        -- DATA
        POINT_IN_PX  => point_in_px_doubler_int,
        POINT_IN_PY  => point_in_py_doubler_int,
        POINT_OUT_RX => point_out_rx_doubler_int,
        POINT_OUT_RY => point_out_ry_doubler_int
        );

    peripheral_dsa_point_doubler_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_point_doubler_int = '1') then
          assert point_out_rx_doubler_int = POINT_DOUBLER_OUT_RX
            report "SCALAR DOUBLER: CALCULATED = " & to_string(point_out_rx_doubler_int) & "; CORRECT = " & to_string(POINT_DOUBLER_OUT_RX)
            severity error;

          assert point_out_ry_doubler_int = POINT_DOUBLER_OUT_RY
            report "SCALAR DOUBLER: CALCULATED = " & to_string(point_out_ry_doubler_int) & "; CORRECT = " & to_string(POINT_DOUBLER_OUT_RY)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_point_doubler_assertion;
  end generate peripheral_dsa_point_doubler_if;

  -- ***************************************************************************
  -- ********************** peripheral_dsa_point_generator *********************
  -- ***************************************************************************

  peripheral_dsa_point_generator_if : if (DSA_POINT_GENERATOR_TEST) generate
    peripheral_dsa_point_generator_dut : peripheral_dsa_point_generator
      generic map (
        DATA_SIZE => DATA_SIZE
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_point_generator_int,
        READY => ready_point_generator_int,

        -- DATA
        PRIVATE_KEY => private_key_generator_int,

        POINT_IN_X => point_in_x_generator_int,
        POINT_IN_Y => point_in_y_generator_int,

        POINT_OUT_X => point_out_x_generator_int,
        POINT_OUT_Y => point_out_y_generator_int
        );

    peripheral_dsa_point_generator_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_point_generator_int = '1') then
          assert point_out_x_generator_int = POINT_GENERATOR_OUT_X
            report "SCALAR GENERATOR: CALCULATED = " & to_string(point_out_x_generator_int) & "; CORRECT = " & to_string(POINT_GENERATOR_OUT_X)
            severity error;

          assert point_out_y_generator_int = POINT_GENERATOR_OUT_Y
            report "SCALAR GENERATOR: CALCULATED = " & to_string(point_out_y_generator_int) & "; CORRECT = " & to_string(POINT_GENERATOR_OUT_Y)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_point_generator_assertion;
  end generate peripheral_dsa_point_generator_if;

  -- ***************************************************************************
  -- ************************ peripheral_dsa_ecdsa_sign ************************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_sign_if : if (DSA_ECDSA_SIGN_TEST) generate
    peripheral_dsa_ecdsa_sign_dut : peripheral_dsa_ecdsa_sign
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_sign_int,
        READY => ready_sign_int,

        FAIL => fail_sign_int,

        DATA_IN_ENABLE  => data_in_enable_sign_int,
        DATA_OUT_ENABLE => data_out_enable_sign_int,

        -- DATA
        PRIVATE_KEY   => private_key_sign_int,
        GENERATED_KEY => generated_key_sign_int,

        DATA_BLOCK_SIZE => data_block_size_sign_int,

        MESSAGE => message_sign_int,

        SIGNATURE_R => signature_r_sign_int,
        SIGNATURE_S => signature_s_sign_int
        );

    peripheral_dsa_ecdsa_sign_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_sign_int = '1') then
          assert signature_r_sign_int = ECDSA_SIGN_SIGNATURE_R
            report "SCALAR SIGN: CALCULATED = " & to_string(signature_r_sign_int) & "; CORRECT = " & to_string(ECDSA_SIGN_SIGNATURE_R)
            severity error;

          assert signature_s_sign_int = ECDSA_SIGN_SIGNATURE_S
            report "SCALAR SIGN: CALCULATED = " & to_string(signature_s_sign_int) & "; CORRECT = " & to_string(ECDSA_SIGN_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_ecdsa_sign_assertion;
  end generate peripheral_dsa_ecdsa_sign_if;

  -- ***************************************************************************
  -- *********************** peripheral_dsa_ecdsa_verify ***********************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_verify_if : if (DSA_ECDSA_VERIFY_TEST) generate
    peripheral_dsa_ecdsa_verify_dut : peripheral_dsa_ecdsa_verify
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_verify_int,
        READY => ready_verify_int,

        DATA_IN_ENABLE  => data_in_enable_verify_int,
        DATA_OUT_ENABLE => data_out_enable_verify_int,

        FAIL => fail_verify_int,

        -- DATA
        PUBLIC_KEY_X => public_key_x_verify_int,
        PUBLIC_KEY_Y => public_key_y_verify_int,

        DATA_BLOCK_SIZE => data_block_size_verify_int,

        MESSAGE => message_verify_int,

        SIGNATURE_R => signature_r_verify_int,
        SIGNATURE_S => signature_s_verify_int
        );

    peripheral_dsa_ecdsa_verify_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_verify_int = '1') then
          assert signature_r_verify_int = ECDSA_VERIFY_SIGNATURE_R
            report "SCALAR VERIFY: CALCULATED = " & to_string(signature_r_verify_int) & "; CORRECT = " & to_string(ECDSA_VERIFY_SIGNATURE_R)
            severity error;

          assert signature_s_verify_int = ECDSA_VERIFY_SIGNATURE_S
            report "SCALAR VERIFY: CALCULATED = " & to_string(signature_s_verify_int) & "; CORRECT = " & to_string(ECDSA_VERIFY_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_ecdsa_verify_assertion;
  end generate peripheral_dsa_ecdsa_verify_if;

  -- ***************************************************************************
  -- ************************* peripheral_dsa_ecdsa_top ************************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_top_if : if (DSA_ECDSA_TOP_TEST) generate
    peripheral_dsa_ecdsa_top_dut : peripheral_dsa_ecdsa_top
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_top_int,
        READY => ready_top_int,

        DATA_IN_ENABLE  => data_in_enable_top_int,
        DATA_OUT_ENABLE => data_out_enable_top_int,

        MODE => mode_top_int,
        FAIL => fail_top_int,

        -- DATA
        PRIVATE_KEY   => private_key_top_int,
        GENERATED_KEY => generated_key_top_int,

        PUBLIC_KEY_X_CHECK => public_key_x_check_top_int,
        PUBLIC_KEY_Y_CHECK => public_key_y_check_top_int,

        DATA_BLOCK_SIZE => data_block_size_top_int,

        MESSAGE => message_top_int,

        SIGNATURE_R_CHECK => signature_r_check_top_int,
        SIGNATURE_S_CHECK => signature_s_check_top_int,

        SIGNATURE_R => signature_r_top_int,
        SIGNATURE_S => signature_s_top_int
        );

    peripheral_dsa_ecdsa_top_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_top_int = '1') then
          assert signature_r_top_int = ECDSA_TOP_SIGNATURE_R
            report "SCALAR TOP: CALCULATED = " & to_string(signature_r_top_int) & "; CORRECT = " & to_string(ECDSA_TOP_SIGNATURE_R)
            severity error;

          assert signature_s_top_int = ECDSA_TOP_SIGNATURE_S
            report "SCALAR TOP: CALCULATED = " & to_string(signature_s_top_int) & "; CORRECT = " & to_string(ECDSA_TOP_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_ecdsa_top_assertion;
  end generate peripheral_dsa_ecdsa_top_if;

  -- ***************************************************************************
  -- ************************ peripheral_dsa_kcdsa_sign ************************
  -- ***************************************************************************

  peripheral_dsa_kcdsa_sign_if : if (DSA_KCDSA_SIGN_TEST) generate
    peripheral_dsa_kcdsa_sign_dut : peripheral_dsa_kcdsa_sign
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_peripheral_dsa_kcdsa_sign_int,
        READY => ready_peripheral_dsa_kcdsa_sign_int,

        FAIL => fail_peripheral_dsa_kcdsa_sign_int,

        DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_sign_int,
        DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_sign_int,

        -- DATA
        PRIVATE_KEY   => private_key_peripheral_dsa_kcdsa_sign_int,
        GENERATED_KEY => generated_key_peripheral_dsa_kcdsa_sign_int,

        DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_sign_int,

        MESSAGE => message_peripheral_dsa_kcdsa_sign_int,

        SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_sign_int,
        SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_sign_int
        );

    peripheral_dsa_kcdsa_sign_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_peripheral_dsa_kcdsa_sign_int = '1') then
          assert signature_r_peripheral_dsa_kcdsa_sign_int = KCDSA_SIGN_SIGNATURE_R
            report "SCALAR SIGN: CALCULATED = " & to_string(signature_r_peripheral_dsa_kcdsa_sign_int) & "; CORRECT = " & to_string(KCDSA_SIGN_SIGNATURE_R)
            severity error;

          assert signature_s_peripheral_dsa_kcdsa_sign_int = KCDSA_SIGN_SIGNATURE_S
            report "SCALAR SIGN: CALCULATED = " & to_string(signature_s_peripheral_dsa_kcdsa_sign_int) & "; CORRECT = " & to_string(KCDSA_SIGN_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_kcdsa_sign_assertion;
  end generate peripheral_dsa_kcdsa_sign_if;

  -- ***************************************************************************
  -- *********************** peripheral_dsa_kcdsa_verify ***********************
  -- ***************************************************************************

  peripheral_dsa_kcdsa_verify_if : if (DSA_KCDSA_VERIFY_TEST) generate
    peripheral_dsa_kcdsa_verify_dut : peripheral_dsa_kcdsa_verify
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_peripheral_dsa_kcdsa_verify_int,
        READY => ready_peripheral_dsa_kcdsa_verify_int,

        DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_verify_int,
        DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_verify_int,

        FAIL => fail_peripheral_dsa_kcdsa_verify_int,

        -- DATA
        PUBLIC_KEY_X => public_key_x_peripheral_dsa_kcdsa_verify_int,
        PUBLIC_KEY_Y => public_key_y_peripheral_dsa_kcdsa_verify_int,

        DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_verify_int,

        MESSAGE => message_peripheral_dsa_kcdsa_verify_int,

        SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_verify_int,
        SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_verify_int
        );

    peripheral_dsa_kcdsa_verify_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_peripheral_dsa_kcdsa_verify_int = '1') then
          assert signature_r_peripheral_dsa_kcdsa_verify_int = KCDSA_VERIFY_SIGNATURE_R
            report "SCALAR VERIFY: CALCULATED = " & to_string(signature_r_peripheral_dsa_kcdsa_verify_int) & "; CORRECT = " & to_string(KCDSA_VERIFY_SIGNATURE_R)
            severity error;

          assert signature_s_peripheral_dsa_kcdsa_verify_int = KCDSA_VERIFY_SIGNATURE_S
            report "SCALAR VERIFY: CALCULATED = " & to_string(signature_s_peripheral_dsa_kcdsa_verify_int) & "; CORRECT = " & to_string(KCDSA_VERIFY_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_kcdsa_verify_assertion;
  end generate peripheral_dsa_kcdsa_verify_if;

  -- ***************************************************************************
  -- ************************* peripheral_dsa_kcdsa_top ************************
  -- ***************************************************************************

  peripheral_dsa_kcdsa_top_if : if (DSA_KCDSA_TOP_TEST) generate
    peripheral_dsa_kcdsa_top_dut : peripheral_dsa_kcdsa_top
      generic map (
        DATA_SIZE  => DATA_SIZE,
        BLOCK_SIZE => BLOCK_SIZE,
        WORD_SIZE  => WORD_SIZE_512
        )
      port map (
        -- GLOBAL
        CLK => clk,
        RST => rst,

        -- CONTROL
        START => start_peripheral_dsa_kcdsa_top_int,
        READY => ready_peripheral_dsa_kcdsa_top_int,

        DATA_IN_ENABLE  => data_in_enable_peripheral_dsa_kcdsa_top_int,
        DATA_OUT_ENABLE => data_out_enable_peripheral_dsa_kcdsa_top_int,

        MODE => mode_peripheral_dsa_kcdsa_top_int,
        FAIL => fail_peripheral_dsa_kcdsa_top_int,

        -- DATA
        PRIVATE_KEY   => private_key_peripheral_dsa_kcdsa_top_int,
        GENERATED_KEY => generated_key_peripheral_dsa_kcdsa_top_int,

        PUBLIC_KEY_X_CHECK => public_key_x_check_peripheral_dsa_kcdsa_top_int,
        PUBLIC_KEY_Y_CHECK => public_key_y_check_peripheral_dsa_kcdsa_top_int,

        DATA_BLOCK_SIZE => data_block_size_peripheral_dsa_kcdsa_top_int,

        MESSAGE => message_peripheral_dsa_kcdsa_top_int,

        SIGNATURE_R_CHECK => signature_r_check_peripheral_dsa_kcdsa_top_int,
        SIGNATURE_S_CHECK => signature_s_check_peripheral_dsa_kcdsa_top_int,

        SIGNATURE_R => signature_r_peripheral_dsa_kcdsa_top_int,
        SIGNATURE_S => signature_s_peripheral_dsa_kcdsa_top_int
        );

    peripheral_dsa_kcdsa_top_assertion : process (clk, rst)
    begin
      if rising_edge(clk) then
        if (ready_peripheral_dsa_kcdsa_top_int = '1') then
          assert signature_r_peripheral_dsa_kcdsa_top_int = KCDSA_TOP_SIGNATURE_R
            report "SCALAR TOP: CALCULATED = " & to_string(signature_r_peripheral_dsa_kcdsa_top_int) & "; CORRECT = " & to_string(KCDSA_TOP_SIGNATURE_R)
            severity error;

          assert signature_s_peripheral_dsa_kcdsa_top_int = KCDSA_TOP_SIGNATURE_S
            report "SCALAR TOP: CALCULATED = " & to_string(signature_s_peripheral_dsa_kcdsa_top_int) & "; CORRECT = " & to_string(KCDSA_TOP_SIGNATURE_S)
            severity error;
        end if;
      end if;
    end process peripheral_dsa_kcdsa_top_assertion;
  end generate peripheral_dsa_kcdsa_top_if;
end architecture peripheral_dsa_testbench_architecture;
