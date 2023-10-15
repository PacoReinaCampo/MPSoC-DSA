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

use work.ecdsa_point_doubler_pkg.all;

entity ecdsa_point_doubler_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end ecdsa_point_doubler_testbench;

architecture ecdsa_point_doubler_testbench_architecture of ecdsa_point_doubler_testbench is

  component ecdsa_point_doubler_stimulus is
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
      -- ECDSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_DOUBLER_START : out std_logic;
      ECDSA_POINT_DOUBLER_READY : in  std_logic;

      -- DATA
      ECDSA_POINT_IN_PX_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_IN_PY_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RX_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_POINT_OUT_RY_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component ecdsa_point_doubler_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-POINT_DOUBLER
  -------------------------------------------------------

  signal start_point_doubler_int : std_logic;
  signal ready_point_doubler_int : std_logic;

  signal point_in_px_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- *********************** ecdsa_point_doubler_stimulus **********************
  -- ***************************************************************************

  ecdsa_point_doubler_stimulus_i : ecdsa_point_doubler_stimulus
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
      -- ECDSA-POINT_DOUBLER
      -------------------------------------------------------

      -- CONTROL
      ECDSA_POINT_DOUBLER_START => start_point_doubler_int,
      ECDSA_POINT_DOUBLER_READY => ready_point_doubler_int,

      -- DATA
      ECDSA_POINT_IN_PX_DOUBLER  => point_in_px_doubler_int,
      ECDSA_POINT_IN_PY_DOUBLER  => point_in_py_doubler_int,
      ECDSA_POINT_OUT_RX_DOUBLER => point_out_rx_doubler_int,
      ECDSA_POINT_OUT_RY_DOUBLER => point_out_ry_doubler_int
      );

  -- ***************************************************************************
  -- *************************** ecdsa_point_doubler ***************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
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
  end process scalar_assertion;

end architecture ecdsa_point_doubler_testbench_architecture;
