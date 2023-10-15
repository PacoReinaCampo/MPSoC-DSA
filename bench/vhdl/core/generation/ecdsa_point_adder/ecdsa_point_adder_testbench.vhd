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

use work.ecdsa_point_adder_pkg.all;

entity ecdsa_point_adder_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end ecdsa_point_adder_testbench;

architecture ecdsa_point_adder_testbench_architecture of ecdsa_point_adder_testbench is

  component ecdsa_point_adder_stimulus is
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
      ECDSA_POINT_OUT_RY_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component ecdsa_point_adder_stimulus;

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

  signal clk : std_logic;
  signal rst : std_logic;

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

begin

  -- ***************************************************************************
  -- ************************ ecdsa_point_adder_stimulus ***********************
  -- ***************************************************************************

  ecdsa_point_adder_stimulus_i : ecdsa_point_adder_stimulus
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
      ECDSA_POINT_OUT_RY_ADDER => point_out_ry_adder_int
      );

  -- ***************************************************************************
  -- **************************** ecdsa_point_adder ****************************
  -- ***************************************************************************

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

end architecture ecdsa_point_adder_testbench_architecture;
