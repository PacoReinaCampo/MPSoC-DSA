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

use work.peripheral_dsa_ecdsa_sign_pkg.all;

entity peripheral_dsa_ecdsa_sign_testbench is
  generic (
    -- ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_ecdsa_sign_testbench;

architecture peripheral_dsa_ecdsa_sign_testbench_architecture of peripheral_dsa_ecdsa_sign_testbench is

  component peripheral_dsa_ecdsa_sign_stimulus is
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
      ECDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_ecdsa_sign_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

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

begin

  -- ***************************************************************************
  -- ******************** peripheral_dsa_ecdsa_sign_stimulus *******************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_sign_stimulus_i : peripheral_dsa_ecdsa_sign_stimulus
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
      ECDSA_SIGN_SIGNATURE_S => signature_s_sign_int
      );

  -- ***************************************************************************
  -- ************************ peripheral_dsa_ecdsa_sign ************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
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
  end process scalar_assertion;

end architecture peripheral_dsa_ecdsa_sign_testbench_architecture;
