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

use work.peripheral_dsa_inverter_pkg.all;

entity peripheral_dsa_inverter_testbench is
  generic (
    -- ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_inverter_testbench;

architecture peripheral_dsa_inverter_testbench_architecture of peripheral_dsa_inverter_testbench is

  component peripheral_dsa_inverter_stimulus is
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
      -- ECDSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_INVERTER_START : out std_logic;
      ECDSA_INVERTER_READY : in  std_logic;

      -- DATA
      ECDSA_INVERTER_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_INVERTER_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_inverter_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-INVERTER
  -------------------------------------------------------

  signal start_inverter_int : std_logic;
  signal ready_inverter_int : std_logic;

  signal data_in_inverter_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_inverter_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- ************************* peripheral_dsa_inverter_stimulus *************************
  -- ***************************************************************************

  peripheral_dsa_inverter_stimulus_i : peripheral_dsa_inverter_stimulus
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
      -- ECDSA-INVERTER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_INVERTER_START => start_inverter_int,
      ECDSA_INVERTER_READY => ready_inverter_int,

      -- DATA
      ECDSA_INVERTER_DATA_IN  => data_in_inverter_int,
      ECDSA_INVERTER_DATA_OUT => data_out_inverter_int
      );

  -- ***************************************************************************
  -- ****************************** peripheral_dsa_inverter *****************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (ready_inverter_int = '1') then
        assert data_out_inverter_int = INVERTER_DATA_OUT
          report "SCALAR INVERTER: CALCULATED = " & to_string(data_out_inverter_int) & "; CORRECT = " & to_string(INVERTER_DATA_OUT)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

end architecture peripheral_dsa_inverter_testbench_architecture;
