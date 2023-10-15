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

--library modelsim_lib;
--use modelsim_lib.util.all;

use work.kcdsa_verify_pkg.all;

entity kcdsa_verify_stimulus is
  generic (
    --KCDSA-SIZE
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
    -- KCDSA-VERIFY
    -------------------------------------------------------

    -- CONTROL
    KCDSA_VERIFY_START : out std_logic;
    KCDSA_VERIFY_READY : in  std_logic;

    KCDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
    KCDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

    KCDSA_VERIFY_FAIL : in std_logic;

    -- DATA
    KCDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
    KCDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

    KCDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    KCDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    KCDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
    KCDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture kcdsa_verify_stimulus_architecture of kcdsa_verify_stimulus is

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

  KCDSA_VERIFY_START <= start_int;

  -------------------------------------------------------
  -- STIMULUS
  -------------------------------------------------------

  main_test : process
  begin

    -- CONTROL
    KCDSA_VERIFY_DATA_IN_ENABLE <= '0';

    -- DATA
    KCDSA_VERIFY_PUBLIC_KEY_X <= VERIFY_PUBLIC_KEY_X_KCDSA;
    KCDSA_VERIFY_PUBLIC_KEY_Y <= VERIFY_PUBLIC_KEY_Y_KCDSA;

    KCDSA_VERIFY_DATA_BLOCK_SIZE <= VERIFY_DATA_BLOCK_SIZE_KCDSA;
    KCDSA_VERIFY_MESSAGE         <= VERIFY_MESSAGE_KCDSA;

    KCDSA_VERIFY_SIGNATURE_R <= VERIFY_SIGNATURE_R_KCDSA;
    KCDSA_VERIFY_SIGNATURE_S <= VERIFY_SIGNATURE_S_KCDSA;

    wait for 1 ms;

  end process main_test;

end architecture kcdsa_verify_stimulus_architecture;
