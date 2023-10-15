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

use work.ecdsa_adder_pkg.all;

entity ecdsa_adder_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end ecdsa_adder_testbench;

architecture ecdsa_adder_testbench_architecture of ecdsa_adder_testbench is

  component ecdsa_adder_stimulus is
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
      -- ECDSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_ADDER_START : out std_logic;
      ECDSA_ADDER_READY : in  std_logic;

      ECDSA_ADDER_OPERATION : out std_logic;

      -- DATA
      ECDSA_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component ecdsa_adder_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-ADDER
  -------------------------------------------------------

  signal start_adder_int : std_logic;
  signal ready_adder_int : std_logic;

  signal operation_adder_int : std_logic;

  signal data_a_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- *************************** ecdsa_adder_stimulus **************************
  -- ***************************************************************************

  ecdsa_adder_stimulus_i : ecdsa_adder_stimulus
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
      -- ECDSA-ADDER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_ADDER_START => start_adder_int,
      ECDSA_ADDER_READY => ready_adder_int,

      ECDSA_ADDER_OPERATION => operation_adder_int,

      -- DATA
      ECDSA_ADDER_DATA_A_IN => data_a_in_adder_int,
      ECDSA_ADDER_DATA_B_IN => data_b_in_adder_int,
      ECDSA_ADDER_DATA_OUT  => data_out_adder_int
      );

  -- ***************************************************************************
  -- ****************************** ecdsa_adder ********************************
  -- ***************************************************************************

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

end architecture ecdsa_adder_testbench_architecture;
