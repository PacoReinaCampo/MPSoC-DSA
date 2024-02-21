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

use work.peripheral_dsa_point_generator_pkg.all;

entity peripheral_dsa_point_generator_testbench is
  generic (
    -- ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_point_generator_testbench;

architecture peripheral_dsa_point_generator_testbench_architecture of peripheral_dsa_point_generator_testbench is

  component peripheral_dsa_point_generator_stimulus is
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
      ECDSA_POINT_OUT_Y_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_point_generator_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

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

begin

  -- ***************************************************************************
  -- ********************** peripheral_dsa_point_generator_stimulus *********************
  -- ***************************************************************************

  peripheral_dsa_point_generator_stimulus_i : peripheral_dsa_point_generator_stimulus
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
      ECDSA_POINT_OUT_Y_GENERATOR => point_out_y_generator_int
      );

  -- ***************************************************************************
  -- ************************** peripheral_dsa_point_generator **************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
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
  end process scalar_assertion;

end architecture peripheral_dsa_point_generator_testbench_architecture;
