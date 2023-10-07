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

package ecdsa_pkg is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type std_logic_matrix_256x8 is array (0 to 255) of std_logic_vector(7 downto 0);

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

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

  component ecdsa_mod is
    generic (
      DATA_SIZE : integer := 512
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
  end component ecdsa_mod;

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

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

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

      DATA_IN_ENABLE  : in  std_logic;
      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

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

      MESSAGE : in  std_logic_vector(0 to 16*WORD_SIZE-1);

      SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

end package;
