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

use work.ecdsa_mod_pkg.all;

entity ecdsa_mod_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end ecdsa_mod_testbench;

architecture ecdsa_mod_testbench_architecture of ecdsa_mod_testbench is

  component ecdsa_mod_stimulus is
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
      -- ECDSA-MOD
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MOD_START : out std_logic;
      ECDSA_MOD_READY : in  std_logic;

      -- DATA
      ECDSA_MOD_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_MOD_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component ecdsa_mod_stimulus;

  component ecdsa_mod is
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

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-MOD
  -------------------------------------------------------

  signal start_mod_int : std_logic;
  signal ready_mod_int : std_logic;

  signal data_in_mod_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_mod_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- **************************** ecdsa_mod_stimulus ***************************
  -- ***************************************************************************

  ecdsa_mod_stimulus_i : ecdsa_mod_stimulus
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
      -- ECDSA-MOD
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MOD_START => start_mod_int,
      ECDSA_MOD_READY => ready_mod_int,

      -- DATA
      ECDSA_MOD_DATA_IN  => data_in_mod_int,
      ECDSA_MOD_DATA_OUT => data_out_mod_int
      );

  -- ***************************************************************************
  -- ********************************* ecdsa_mod *******************************
  -- ***************************************************************************

  ecdsa_mod_dut : ecdsa_mod
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => clk,
      RST => rst,

      -- CONTROL
      START => start_mod_int,
      READY => ready_mod_int,

      -- DATA
      MODULO   => BLACKPOOL512_P,
      DATA_IN  => data_in_mod_int,
      DATA_OUT => data_out_mod_int
      );

end architecture ecdsa_mod_testbench_architecture;
