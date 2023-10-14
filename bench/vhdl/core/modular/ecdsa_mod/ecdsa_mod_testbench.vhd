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

use std.textio.all;

use work.testbench_miera_pkg.all;

entity testbench_miera_top is
  generic (
    --ECDSA-FUNCTIONALITY
    C_ECDSA_SHA256_TEST          : boolean := false;
    C_ECDSA_SHA512_TEST          : boolean := false;
    C_ECDSA_ADDER_TEST           : boolean := false;
    C_ECDSA_INVERTER_TEST        : boolean := false;
    C_ECDSA_MULTIPLIER_TEST      : boolean := false;
    C_ECDSA_POINT_ADDER_TEST     : boolean := false;
    C_ECDSA_POINT_DOUBLER_TEST   : boolean := false;
    C_ECDSA_POINT_GENERATOR_TEST : boolean := false;
    C_ECDSA_SIGN_TEST            : boolean := false;
    C_ECDSA_VERIFY_TEST          : boolean := false;
    C_ECDSA_TOP_TEST             : boolean := false;
    C_KCDSA_SIGN_TEST            : boolean := false;
    C_KCDSA_VERIFY_TEST          : boolean := false;
    C_KCDSA_TOP_TEST             : boolean := false;

    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
  );
end testbench_miera_top;

architecture testbench_miera_top_architecture of testbench_miera_top is

  component testbench_miera_stimulus is
    generic (
      --ECDSA-SIZE
      BLOCK_SIZE    : integer := 4;
      WORD_SIZE_256 : integer := 32;
      WORD_SIZE_512 : integer := 64
    );
    port (
      CLK : out std_logic;
      RST : out std_logic;

      -------------------------------------------------------
      -- ECDSA-SHA256
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SHA256_START : out std_logic;
      ECDSA_SHA256_READY : in  std_logic;

      ECDSA_SHA256_DATA_IN_ENABLE  : out std_logic;
      ECDSA_SHA256_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      ECDSA_SHA256_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_SHA256_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_256-1);
      ECDSA_SHA256_DATA_OUT : in  std_logic_vector(WORD_SIZE_256*8-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-SHA512
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SHA512_START : out std_logic;
      ECDSA_SHA512_READY : in  std_logic;

      ECDSA_SHA512_DATA_IN_ENABLE  : out std_logic;
      ECDSA_SHA512_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      ECDSA_SHA512_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_SHA512_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_512-1);
      ECDSA_SHA512_DATA_OUT : in  std_logic_vector(WORD_SIZE_512*8-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_ADDER_START : out std_logic;
      ECDSA_ADDER_READY : in  std_logic;

      ECDSA_ADDER_OPERATION : out std_logic;

      -- DATA
      ECDSA_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_INVERTER_START : out std_logic;
      ECDSA_INVERTER_READY : in  std_logic;

      -- DATA
      ECDSA_INVERTER_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_INVERTER_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MULTIPLIER_START : out std_logic;
      ECDSA_MULTIPLIER_READY : in  std_logic;

      -- DATA
      ECDSA_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-POINT_ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_ADDER_START : out std_logic;
      ECDSA_POINT_ADDER_READY : in  std_logic;

      -- DATA
      ECDSA_POINT_IN_PX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_PY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_QX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_QY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RX_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RY_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_DOUBLER_START : out std_logic;
      ECDSA_POINT_DOUBLER_READY : in  std_logic;

      -- DATA
      ECDSA_POINT_IN_PX_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_PY_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RX_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RY_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-POINT_GENERATOR
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_GENERATOR_START : out std_logic;
      ECDSA_POINT_GENERATOR_READY : in  std_logic;

      -- DATA
      ECDSA_PRIVATE_KEY_GENERATOR : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_POINT_IN_X_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_Y_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_X_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_Y_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SIGN_START : out std_logic;
      ECDSA_SIGN_READY : in  std_logic;

      ECDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
      ECDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      ECDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      ECDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      ECDSA_VERIFY_START : out std_logic;
      ECDSA_VERIFY_READY : in  std_logic;

      ECDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
      ECDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

      ECDSA_VERIFY_FAIL : in std_logic;

      -- DATA
      ECDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      ECDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      ECDSA_TOP_START : out std_logic;
      ECDSA_TOP_READY : in  std_logic;

      ECDSA_TOP_DATA_IN_ENABLE  : out std_logic;
      ECDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

      ECDSA_TOP_MODE : out std_logic;
      ECDSA_TOP_FAIL : in  std_logic;

      -- DATA
      ECDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      ECDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- KCDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      KCDSA_SIGN_START : out std_logic;
      KCDSA_SIGN_READY : in  std_logic;

      KCDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
      KCDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

      -- DATA
      KCDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      KCDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      KCDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      KCDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- KCDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      KCDSA_VERIFY_START : out std_logic;
      KCDSA_VERIFY_READY : in  std_logic;

      KCDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
      KCDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

      KCDSA_VERIFY_FAIL : in std_logic;

      -- DATA
      KCDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

      KCDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      KCDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      KCDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

      -------------------------------------------------------
      -- KCDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      KCDSA_TOP_START : out std_logic;
      KCDSA_TOP_READY : in  std_logic;

      KCDSA_TOP_DATA_IN_ENABLE  : out std_logic;
      KCDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

      KCDSA_TOP_MODE : out std_logic;
      KCDSA_TOP_FAIL : in  std_logic;

      -- DATA
      KCDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      KCDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      KCDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      KCDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      KCDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      KCDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      KCDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component testbench_miera_stimulus;

  component ecdsa_sha256 is
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

  component ecdsa_sha512 is
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

  component ecdsa_adder is
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

  component ecdsa_inverter is
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

  component ecdsa_multiplier is
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

  component ecdsa_point_adder is
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

  component ecdsa_point_doubler is
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

  component ecdsa_point_generator is
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

  component ecdsa_sign is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ecdsa_verify is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ecdsa_top is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component kcdsa_sign is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component kcdsa_verify is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component kcdsa_top is
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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE_512-1);

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
  -- ECDSA-SHA256
  -------------------------------------------------------

  signal start_sha256_int : std_logic;
  signal ready_sha256_int : std_logic;

  signal data_in_enable_sha256_int  : std_logic;
  signal data_out_enable_sha256_int : std_logic;

  signal data_block_size_sha256_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal data_in_sha256_int  : std_logic_vector(0 to 16*WORD_SIZE_256-1);
  signal data_out_sha256_int : std_logic_vector(WORD_SIZE_256*8-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-SHA512
  -------------------------------------------------------

  signal start_sha512_int : std_logic;
  signal ready_sha512_int : std_logic;

  signal data_in_enable_sha512_int  : std_logic;
  signal data_out_enable_sha512_int : std_logic;

  signal data_block_size_sha512_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal data_in_sha512_int  : std_logic_vector(0 to 16*WORD_SIZE_512-1);
  signal data_out_sha512_int : std_logic_vector(WORD_SIZE_512*8-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-ADDER
  -------------------------------------------------------

  signal start_adder_int : std_logic;
  signal ready_adder_int : std_logic;

  signal operation_adder_int : std_logic;

  signal data_a_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-INVERTER
  -------------------------------------------------------

  signal start_inverter_int : std_logic;
  signal ready_inverter_int : std_logic;

  signal data_in_inverter_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_inverter_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-MULTIPLIER
  -------------------------------------------------------

  signal start_multiplier_int : std_logic;
  signal ready_multiplier_int : std_logic;

  signal data_a_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_multiplier_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-POINT_ADDER
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
  -- ECDSA-POINT_DOUBLER
  -------------------------------------------------------

  signal start_point_doubler_int : std_logic;
  signal ready_point_doubler_int : std_logic;

  signal point_in_px_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-POINT_GENERATOR
  -------------------------------------------------------

  signal start_point_generator_int : std_logic;
  signal ready_point_generator_int : std_logic;

  signal private_key_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal point_in_x_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_y_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_x_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_y_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- ECDSA-SIGN
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
  -- ECDSA-VERIFY
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
  -- ECDSA-TOP
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
  -- KCDSA-SIGN
  -------------------------------------------------------

  signal start_kcdsa_sign_int : std_logic;
  signal ready_kcdsa_sign_int : std_logic;

  signal fail_kcdsa_sign_int : std_logic;

  signal data_in_enable_kcdsa_sign_int  : std_logic;
  signal data_out_enable_kcdsa_sign_int : std_logic;
  
  signal private_key_kcdsa_sign_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_kcdsa_sign_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_kcdsa_sign_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_kcdsa_sign_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- KCDSA-VERIFY
  -------------------------------------------------------

  signal start_kcdsa_verify_int : std_logic;
  signal ready_kcdsa_verify_int : std_logic;

  signal data_in_enable_kcdsa_verify_int  : std_logic;
  signal data_out_enable_kcdsa_verify_int : std_logic;

  signal fail_kcdsa_verify_int : std_logic;

  signal public_key_x_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_kcdsa_verify_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_kcdsa_verify_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_kcdsa_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -------------------------------------------------------
  -- KCDSA-TOP
  -------------------------------------------------------

  signal start_kcdsa_top_int : std_logic;
  signal ready_kcdsa_top_int : std_logic;

  signal data_in_enable_kcdsa_top_int  : std_logic;
  signal data_out_enable_kcdsa_top_int : std_logic;

  signal mode_kcdsa_top_int : std_logic;
  signal fail_kcdsa_top_int : std_logic;

  signal private_key_kcdsa_top_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal public_key_x_check_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_check_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_kcdsa_top_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_kcdsa_top_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_check_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_check_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal signature_r_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_kcdsa_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- ************************ testbench_miera_stimulus ************************
  -- ***************************************************************************

  testbench_miera_stimulus_i : testbench_miera_stimulus
    generic map (
      --ECDSA-SIZE
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
      -- ECDSA-SHA256
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SHA256_START => start_sha256_int,
      ECDSA_SHA256_READY => ready_sha256_int,

      ECDSA_SHA256_DATA_IN_ENABLE  => data_in_enable_sha256_int,
      ECDSA_SHA256_DATA_OUT_ENABLE => data_out_enable_sha256_int,

      -- DATA
      ECDSA_SHA256_DATA_BLOCK_SIZE => data_block_size_sha256_int,

      ECDSA_SHA256_DATA_IN  => data_in_sha256_int,
      ECDSA_SHA256_DATA_OUT => data_out_sha256_int,

      -------------------------------------------------------
      -- ECDSA-SHA512
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SHA512_START => start_sha512_int,
      ECDSA_SHA512_READY => ready_sha512_int,

      ECDSA_SHA512_DATA_IN_ENABLE  => data_in_enable_sha512_int,
      ECDSA_SHA512_DATA_OUT_ENABLE => data_out_enable_sha512_int,

      -- DATA
      ECDSA_SHA512_DATA_BLOCK_SIZE => data_block_size_sha512_int,

      ECDSA_SHA512_DATA_IN  => data_in_sha512_int,
      ECDSA_SHA512_DATA_OUT => data_out_sha512_int,

      -------------------------------------------------------
      -- ECDSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_ADDER_START => start_adder_int,
      ECDSA_ADDER_READY => ready_adder_int,

      ECDSA_ADDER_OPERATION => operation_adder_int,

      -- DATA
      ECDSA_ADDER_DATA_A_IN => data_a_in_adder_int,
      ECDSA_ADDER_DATA_B_IN => data_b_in_adder_int,
      ECDSA_ADDER_DATA_OUT  => data_out_adder_int,

      -------------------------------------------------------
      -- ECDSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_INVERTER_START => start_inverter_int,
      ECDSA_INVERTER_READY => ready_inverter_int,

      -- DATA
      ECDSA_INVERTER_DATA_IN  => data_in_inverter_int,
      ECDSA_INVERTER_DATA_OUT => data_out_inverter_int,

      -------------------------------------------------------
      -- ECDSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MULTIPLIER_START => start_multiplier_int,
      ECDSA_MULTIPLIER_READY => ready_multiplier_int,

      -- DATA
      ECDSA_MULTIPLIER_DATA_A_IN => data_a_in_multiplier_int,
      ECDSA_MULTIPLIER_DATA_B_IN => data_b_in_multiplier_int,
      ECDSA_MULTIPLIER_DATA_OUT  => data_out_multiplier_int,

      -------------------------------------------------------
      -- ECDSA-POINT_ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_ADDER_START => start_point_adder_int,
      ECDSA_POINT_ADDER_READY => ready_point_adder_int,

      -- DATA
      ECDSA_POINT_IN_PX_ADDER  => point_in_px_adder_int,
      ECDSA_POINT_IN_PY_ADDER  => point_in_py_adder_int,
      ECDSA_POINT_IN_QX_ADDER  => point_in_qx_adder_int,
      ECDSA_POINT_IN_QY_ADDER  => point_in_qy_adder_int,
      ECDSA_POINT_OUT_RX_ADDER => point_out_rx_adder_int,
      ECDSA_POINT_OUT_RY_ADDER => point_out_ry_adder_int,

      -------------------------------------------------------
      -- ECDSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_DOUBLER_START => start_point_doubler_int,
      ECDSA_POINT_DOUBLER_READY => ready_point_doubler_int,

      -- DATA
      ECDSA_POINT_IN_PX_DOUBLER  => point_in_px_doubler_int,
      ECDSA_POINT_IN_PY_DOUBLER  => point_in_py_doubler_int,
      ECDSA_POINT_OUT_RX_DOUBLER => point_out_rx_doubler_int,
      ECDSA_POINT_OUT_RY_DOUBLER => point_out_ry_doubler_int,

      -------------------------------------------------------
      -- ECDSA-POINT_GENERATOR
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_GENERATOR_START => start_point_generator_int,
      ECDSA_POINT_GENERATOR_READY => ready_point_generator_int,

      -- DATA
      ECDSA_PRIVATE_KEY_GENERATOR => private_key_generator_int,

      ECDSA_POINT_IN_X_GENERATOR  => point_in_x_generator_int,
      ECDSA_POINT_IN_Y_GENERATOR  => point_in_y_generator_int,
      ECDSA_POINT_OUT_X_GENERATOR => point_out_x_generator_int,
      ECDSA_POINT_OUT_Y_GENERATOR => point_out_y_generator_int,

      -------------------------------------------------------
      -- ECDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      ECDSA_SIGN_START => start_sign_int,
      ECDSA_SIGN_READY => ready_sign_int,

      ECDSA_SIGN_DATA_IN_ENABLE  => data_in_enable_sign_int,
      ECDSA_SIGN_DATA_OUT_ENABLE => data_out_enable_sign_int,

      -- DATA
      ECDSA_SIGN_PRIVATE_KEY   => private_key_sign_int,
      ECDSA_SIGN_GENERATED_KEY => generated_key_sign_int,

      ECDSA_SIGN_DATA_BLOCK_SIZE => data_block_size_sign_int,

      ECDSA_SIGN_MESSAGE => message_sign_int,

      ECDSA_SIGN_SIGNATURE_R => signature_r_sign_int,
      ECDSA_SIGN_SIGNATURE_S => signature_s_sign_int,

      -------------------------------------------------------
      -- ECDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      ECDSA_VERIFY_START => start_verify_int,
      ECDSA_VERIFY_READY => ready_verify_int,

      ECDSA_VERIFY_DATA_IN_ENABLE  => data_in_enable_verify_int,
      ECDSA_VERIFY_DATA_OUT_ENABLE => data_out_enable_verify_int,

      ECDSA_VERIFY_FAIL => fail_verify_int,

      -- DATA
      ECDSA_VERIFY_PUBLIC_KEY_X => public_key_x_verify_int,
      ECDSA_VERIFY_PUBLIC_KEY_Y => public_key_y_verify_int,

      ECDSA_VERIFY_DATA_BLOCK_SIZE => data_block_size_verify_int,

      ECDSA_VERIFY_MESSAGE => message_verify_int,

      ECDSA_VERIFY_SIGNATURE_R => signature_r_verify_int,
      ECDSA_VERIFY_SIGNATURE_S => signature_s_verify_int,

      -------------------------------------------------------
      -- ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      ECDSA_TOP_START => start_top_int,
      ECDSA_TOP_READY => ready_top_int,

      ECDSA_TOP_DATA_IN_ENABLE  => data_in_enable_top_int,
      ECDSA_TOP_DATA_OUT_ENABLE => data_out_enable_top_int,

      ECDSA_TOP_MODE => mode_top_int,
      ECDSA_TOP_FAIL => fail_top_int,

      -- DATA
      ECDSA_TOP_PRIVATE_KEY   => private_key_top_int,
      ECDSA_TOP_GENERATED_KEY => generated_key_top_int,

      ECDSA_TOP_PUBLIC_KEY_X_CHECK => public_key_x_check_top_int,
      ECDSA_TOP_PUBLIC_KEY_Y_CHECK => public_key_y_check_top_int,

      ECDSA_TOP_DATA_BLOCK_SIZE => data_block_size_top_int,

      ECDSA_TOP_MESSAGE => message_top_int,

      ECDSA_TOP_SIGNATURE_R_CHECK => signature_r_check_top_int,
      ECDSA_TOP_SIGNATURE_S_CHECK => signature_s_check_top_int,

      ECDSA_TOP_SIGNATURE_R => signature_r_top_int,
      ECDSA_TOP_SIGNATURE_S => signature_s_top_int,

      -------------------------------------------------------
      -- KCDSA-SIGN
      -------------------------------------------------------

      -- CONTROL
      KCDSA_SIGN_START => start_kcdsa_sign_int,
      KCDSA_SIGN_READY => ready_kcdsa_sign_int,

      KCDSA_SIGN_DATA_IN_ENABLE  => data_in_enable_kcdsa_sign_int,
      KCDSA_SIGN_DATA_OUT_ENABLE => data_out_enable_kcdsa_sign_int,

      -- DATA
      KCDSA_SIGN_PRIVATE_KEY   => private_key_kcdsa_sign_int,
      KCDSA_SIGN_GENERATED_KEY => generated_key_kcdsa_sign_int,

      KCDSA_SIGN_DATA_BLOCK_SIZE => data_block_size_kcdsa_sign_int,

      KCDSA_SIGN_MESSAGE => message_kcdsa_sign_int,

      KCDSA_SIGN_SIGNATURE_R => signature_r_kcdsa_sign_int,
      KCDSA_SIGN_SIGNATURE_S => signature_s_kcdsa_sign_int,

      -------------------------------------------------------
      -- KCDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      KCDSA_VERIFY_START => start_kcdsa_verify_int,
      KCDSA_VERIFY_READY => ready_kcdsa_verify_int,

      KCDSA_VERIFY_DATA_IN_ENABLE  => data_in_enable_kcdsa_verify_int,
      KCDSA_VERIFY_DATA_OUT_ENABLE => data_out_enable_kcdsa_verify_int,

      KCDSA_VERIFY_FAIL => fail_kcdsa_verify_int,

      -- DATA
      KCDSA_VERIFY_PUBLIC_KEY_X => public_key_x_kcdsa_verify_int,
      KCDSA_VERIFY_PUBLIC_KEY_Y => public_key_y_kcdsa_verify_int,

      KCDSA_VERIFY_DATA_BLOCK_SIZE => data_block_size_kcdsa_verify_int,

      KCDSA_VERIFY_MESSAGE => message_kcdsa_verify_int,

      KCDSA_VERIFY_SIGNATURE_R => signature_r_kcdsa_verify_int,
      KCDSA_VERIFY_SIGNATURE_S => signature_s_kcdsa_verify_int,

      -------------------------------------------------------
      -- KCDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      KCDSA_TOP_START => start_kcdsa_top_int,
      KCDSA_TOP_READY => ready_kcdsa_top_int,

      KCDSA_TOP_DATA_IN_ENABLE  => data_in_enable_kcdsa_top_int,
      KCDSA_TOP_DATA_OUT_ENABLE => data_out_enable_kcdsa_top_int,

      KCDSA_TOP_MODE => mode_kcdsa_top_int,
      KCDSA_TOP_FAIL => fail_kcdsa_top_int,

      -- DATA
      KCDSA_TOP_PRIVATE_KEY   => private_key_kcdsa_top_int,
      KCDSA_TOP_GENERATED_KEY => generated_key_kcdsa_top_int,

      KCDSA_TOP_PUBLIC_KEY_X_CHECK => public_key_x_check_kcdsa_top_int,
      KCDSA_TOP_PUBLIC_KEY_Y_CHECK => public_key_y_check_kcdsa_top_int,

      KCDSA_TOP_DATA_BLOCK_SIZE => data_block_size_kcdsa_top_int,

      KCDSA_TOP_MESSAGE => message_kcdsa_top_int,

      KCDSA_TOP_SIGNATURE_R_CHECK => signature_r_check_kcdsa_top_int,
      KCDSA_TOP_SIGNATURE_S_CHECK => signature_s_check_kcdsa_top_int,

      KCDSA_TOP_SIGNATURE_R => signature_r_kcdsa_top_int,
      KCDSA_TOP_SIGNATURE_S => signature_s_kcdsa_top_int
    );

  -- ***************************************************************************
  -- ***************************** ecdsa_sha256 ********************************
  -- ***************************************************************************

  ecdsa_sha256_if : if (C_ECDSA_SHA256_TEST) generate
    ecdsa_sha256_dut : ecdsa_sha256
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
  end generate ecdsa_sha256_if;

  -- ***************************************************************************
  -- ***************************** ecdsa_sha512 ********************************
  -- ***************************************************************************

  ecdsa_sha512_if : if (C_ECDSA_SHA512_TEST) generate
    ecdsa_sha512_dut : ecdsa_sha512
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
  end generate ecdsa_sha512_if;

  -- ***************************************************************************
  -- ****************************** ecdsa_adder ********************************
  -- ***************************************************************************

  ecdsa_adder_if : if (C_ECDSA_ADDER_TEST) generate
    ecdsa_adder_dut : ecdsa_adder
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
  end generate ecdsa_adder_if;

  -- ***************************************************************************
  -- ****************************** ecdsa_inverter *****************************
  -- ***************************************************************************

  ecdsa_inverter_if : if (C_ECDSA_INVERTER_TEST) generate
    ecdsa_inverter_dut : ecdsa_inverter
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
  end generate ecdsa_inverter_if;

  -- ***************************************************************************
  -- ***************************** ecdsa_multiplier ****************************
  -- ***************************************************************************

  ecdsa_multiplier_if : if (C_ECDSA_MULTIPLIER_TEST) generate
    ecdsa_multiplier_dut : ecdsa_multiplier
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
  end generate ecdsa_multiplier_if;

  -- ***************************************************************************
  -- **************************** ecdsa_point_adder ****************************
  -- ***************************************************************************

  ecdsa_point_adder_if : if (C_ECDSA_POINT_ADDER_TEST) generate
    ecdsa_point_adder_dut : ecdsa_point_adder
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
  end generate ecdsa_point_adder_if;

  -- ***************************************************************************
  -- *************************** ecdsa_point_doubler ***************************
  -- ***************************************************************************

  ecdsa_point_doubler_if : if (C_ECDSA_POINT_DOUBLER_TEST) generate
    ecdsa_point_doubler_dut : ecdsa_point_doubler
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
  end generate ecdsa_point_doubler_if;

  -- ***************************************************************************
  -- ************************** ecdsa_point_generator **************************
  -- ***************************************************************************

  ecdsa_point_generator_if : if (C_ECDSA_POINT_GENERATOR_TEST) generate
    ecdsa_point_generator_dut : ecdsa_point_generator
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
  end generate ecdsa_point_generator_if;

  -- ***************************************************************************
  -- ******************************** ecdsa_sign *******************************
  -- ***************************************************************************

  ecdsa_sign_if : if (C_ECDSA_SIGN_TEST) generate
    ecdsa_sign_dut : ecdsa_sign
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
  end generate ecdsa_sign_if;

  -- ***************************************************************************
  -- ******************************* ecdsa_verify ******************************
  -- ***************************************************************************

  ecdsa_verify_if : if (C_ECDSA_VERIFY_TEST) generate
    ecdsa_verify_dut : ecdsa_verify
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
  end generate ecdsa_verify_if;

  -- ***************************************************************************
  -- ********************************* ecdsa_top *******************************
  -- ***************************************************************************

  ecdsa_top_if : if (C_ECDSA_TOP_TEST) generate
    ecdsa_top_dut : ecdsa_top
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
  end generate ecdsa_top_if;

  -- ***************************************************************************
  -- ******************************** kcdsa_sign *******************************
  -- ***************************************************************************

  kcdsa_sign_if : if (C_KCDSA_SIGN_TEST) generate
    kcdsa_sign_dut : kcdsa_sign
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
        START => start_kcdsa_sign_int,
        READY => ready_kcdsa_sign_int,

        FAIL => fail_kcdsa_sign_int,

        DATA_IN_ENABLE  => data_in_enable_kcdsa_sign_int,
        DATA_OUT_ENABLE => data_out_enable_kcdsa_sign_int,

        -- DATA
        PRIVATE_KEY   => private_key_kcdsa_sign_int,
        GENERATED_KEY => generated_key_kcdsa_sign_int,

        DATA_BLOCK_SIZE => data_block_size_kcdsa_sign_int,

        MESSAGE => message_kcdsa_sign_int,

        SIGNATURE_R => signature_r_kcdsa_sign_int,
        SIGNATURE_S => signature_s_kcdsa_sign_int
      );
  end generate kcdsa_sign_if;

  -- ***************************************************************************
  -- ******************************* kcdsa_verify ******************************
  -- ***************************************************************************

  kcdsa_verify_if : if (C_KCDSA_VERIFY_TEST) generate
    kcdsa_verify_dut : kcdsa_verify
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
        START => start_kcdsa_verify_int,
        READY => ready_kcdsa_verify_int,

        DATA_IN_ENABLE  => data_in_enable_kcdsa_verify_int,
        DATA_OUT_ENABLE => data_out_enable_kcdsa_verify_int,

        FAIL => fail_kcdsa_verify_int,

        -- DATA
        PUBLIC_KEY_X => public_key_x_kcdsa_verify_int,
        PUBLIC_KEY_Y => public_key_y_kcdsa_verify_int,

        DATA_BLOCK_SIZE => data_block_size_kcdsa_verify_int,

        MESSAGE => message_kcdsa_verify_int,

        SIGNATURE_R => signature_r_kcdsa_verify_int,
        SIGNATURE_S => signature_s_kcdsa_verify_int
      );
  end generate kcdsa_verify_if;

  -- ***************************************************************************
  -- ********************************* kcdsa_top *******************************
  -- ***************************************************************************

  kcdsa_top_if : if (C_KCDSA_TOP_TEST) generate
    kcdsa_top_dut : kcdsa_top
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
        START => start_kcdsa_top_int,
        READY => ready_kcdsa_top_int,

        DATA_IN_ENABLE  => data_in_enable_kcdsa_top_int,
        DATA_OUT_ENABLE => data_out_enable_kcdsa_top_int,

        MODE => mode_kcdsa_top_int,
        FAIL => fail_kcdsa_top_int,

        -- DATA
        PRIVATE_KEY   => private_key_kcdsa_top_int,
        GENERATED_KEY => generated_key_kcdsa_top_int,

        PUBLIC_KEY_X_CHECK => public_key_x_check_kcdsa_top_int,
        PUBLIC_KEY_Y_CHECK => public_key_y_check_kcdsa_top_int,

        DATA_BLOCK_SIZE => data_block_size_kcdsa_top_int,

        MESSAGE => message_kcdsa_top_int,

        SIGNATURE_R_CHECK => signature_r_check_kcdsa_top_int,
        SIGNATURE_S_CHECK => signature_s_check_kcdsa_top_int,

        SIGNATURE_R => signature_r_kcdsa_top_int,
        SIGNATURE_S => signature_s_kcdsa_top_int
      );
  end generate kcdsa_top_if;
end architecture testbench_miera_top_architecture;
