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

-- library modelsim_lib;
-- use modelsim_lib.util.all;

use work.peripheral_dsa_mod_pkg.all;

entity peripheral_dsa_mod_stimulus is
  generic (
    -- ECDSA-SIZE
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
  port (
    -------------------------------------------------------
    -- GLOBAL
    -------------------------------------------------------

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
end entity;

architecture peripheral_dsa_mod_stimulus_architecture of peripheral_dsa_mod_stimulus is

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -------------------------------------------------------
  -- Clock
  -------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -------------------------------------------------------
  -- Reset
  -------------------------------------------------------

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for 50 ns;

    rst_int <= '1';
    wait for 1000 ms;
  end process;

  RST <= rst_int;

  -------------------------------------------------------
  -- Start
  -------------------------------------------------------

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for 50 ns;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for 1000 ms;
  end process;

  ECDSA_MOD_START <= start_int;

  -------------------------------------------------------
  -- STIMULUS
  -------------------------------------------------------

  main_test : process
  begin

    -- DATA
    ECDSA_MOD_DATA_IN <= MOD_DATA_IN;

    wait for 1 ms;

  end process main_test;

end architecture peripheral_dsa_mod_stimulus_architecture;
