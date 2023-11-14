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

use work.peripheral_dsa_multiplier_pkg.all;

entity peripheral_dsa_multiplier_testbench is
  generic (
    -- ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_multiplier_testbench;

architecture peripheral_dsa_multiplier_testbench_architecture of peripheral_dsa_multiplier_testbench is

  component peripheral_dsa_multiplier_stimulus is
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
      -- ECDSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MULTIPLIER_START : out std_logic;
      ECDSA_MULTIPLIER_READY : in  std_logic;

      -- DATA
      ECDSA_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_multiplier_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-MULTIPLIER
  -------------------------------------------------------

  signal start_multiplier_int : std_logic;
  signal ready_multiplier_int : std_logic;

  signal data_a_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_multiplier_int  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- ************************ peripheral_dsa_multiplier_stimulus ************************
  -- ***************************************************************************

  peripheral_dsa_multiplier_stimulus_i : peripheral_dsa_multiplier_stimulus
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
      -- ECDSA-MULTIPLIER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_MULTIPLIER_START => start_multiplier_int,
      ECDSA_MULTIPLIER_READY => ready_multiplier_int,

      -- DATA
      ECDSA_MULTIPLIER_DATA_A_IN => data_a_in_multiplier_int,
      ECDSA_MULTIPLIER_DATA_B_IN => data_b_in_multiplier_int,
      ECDSA_MULTIPLIER_DATA_OUT  => data_out_multiplier_int
      );

  -- ***************************************************************************
  -- ***************************** peripheral_dsa_multiplier ****************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (ready_multiplier_int = '1') then
        assert data_out_multiplier_int = MULTIPLIER_DATA_OUT
          report "SCALAR MULTIPLIER: CALCULATED = " & to_string(data_out_multiplier_int) & "; CORRECT = " & to_string(MULTIPLIER_DATA_OUT)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

end architecture peripheral_dsa_multiplier_testbench_architecture;
