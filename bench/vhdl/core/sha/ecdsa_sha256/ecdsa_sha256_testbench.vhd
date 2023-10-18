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

use work.ecdsa_sha256_pkg.all;

entity ecdsa_sha256_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end ecdsa_sha256_testbench;

architecture ecdsa_sha256_testbench_architecture of ecdsa_sha256_testbench is

  component ecdsa_sha256_stimulus is
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
      ECDSA_SHA256_DATA_OUT : in  std_logic_vector(WORD_SIZE_256*8-1 downto 0)
      );
  end component ecdsa_sha256_stimulus;

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

begin

  -- ***************************************************************************
  -- ************************ ecdsa_sha256_stimulus ************************
  -- ***************************************************************************

  ecdsa_sha256_stimulus_i : ecdsa_sha256_stimulus
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
      ECDSA_SHA256_DATA_OUT => data_out_sha256_int
      );

  -- ***************************************************************************
  -- ******************************* ecdsa_sha256 ******************************
  -- ***************************************************************************

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

  scalar_assertion : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (ready_sha256_int = '1') then
        assert data_out_sha256_int = DATA_OUTPUT_256_2
          report "SCALAR SHA256: CALCULATED = " & to_string(data_out_sha256_int) & "; CORRECT = " & to_string(DATA_OUTPUT_256_2)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

end architecture ecdsa_sha256_testbench_architecture;
