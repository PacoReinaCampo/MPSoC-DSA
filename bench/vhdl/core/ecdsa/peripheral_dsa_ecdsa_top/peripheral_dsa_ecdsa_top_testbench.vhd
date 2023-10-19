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

use work.peripheral_dsa_ecdsa_top_pkg.all;

entity peripheral_dsa_ecdsa_top_testbench is
  generic (
    --ECDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_ecdsa_top_testbench;

architecture peripheral_dsa_ecdsa_top_testbench_architecture of peripheral_dsa_ecdsa_top_testbench is

  component peripheral_dsa_ecdsa_top_stimulus is
    generic (
      --ECDSA-SIZE
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
      -- ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      ECDSA_TOP_START : out std_logic;
      ECDSA_TOP_READY : in  std_logic;

      ECDSA_TOP_DATA_IN_ENABLE  : out std_logic;
      ECDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

      ECDSA_TOP_MODE : out std_logic;
      ECDSA_TOP_FAIL : in  std_logic;

      -- DATA
      ECDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

      ECDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

      ECDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

      ECDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      ECDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component peripheral_dsa_ecdsa_top_stimulus;

  component peripheral_dsa_ecdsa_top is
    generic (
      DATA_SIZE  : integer := 512;
      BLOCK_SIZE : integer := 4;
      WORD_SIZE  : integer := 64
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

      MODE : in  std_logic;
      FAIL : out std_logic;

      -- DATA
      PRIVATE_KEY   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GENERATED_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

      PUBLIC_KEY_X_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

      SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- ECDSA-TOP
  -------------------------------------------------------

  signal start_top_int : std_logic;
  signal ready_top_int : std_logic;

  signal data_in_enable_top_int  : std_logic;
  signal data_out_enable_top_int : std_logic;

  signal mode_top_int : std_logic;
  signal fail_top_int : std_logic;

  signal private_key_top_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal generated_key_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal public_key_x_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_top_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_top_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_check_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal signature_r_top_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_top_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- **************************** peripheral_dsa_ecdsa_top_stimulus ***************************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_top_stimulus_i : peripheral_dsa_ecdsa_top_stimulus
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
      -- ECDSA-TOP
      -------------------------------------------------------

      -- CONTROL
      ECDSA_TOP_START => start_top_int,
      ECDSA_TOP_READY => ready_top_int,

      ECDSA_TOP_DATA_IN_ENABLE  => data_in_enable_top_int,
      ECDSA_TOP_DATA_OUT_ENABLE => data_out_enable_top_int,

      ECDSA_TOP_MODE => mode_top_int,
      ECDSA_TOP_FAIL => fail_top_int,

      -- DATA
      ECDSA_TOP_PRIVATE_KEY   => private_key_top_int,
      ECDSA_TOP_GENERATED_KEY => generated_key_top_int,

      ECDSA_TOP_PUBLIC_KEY_X_CHECK => public_key_x_check_top_int,
      ECDSA_TOP_PUBLIC_KEY_Y_CHECK => public_key_y_check_top_int,

      ECDSA_TOP_DATA_BLOCK_SIZE => data_block_size_top_int,

      ECDSA_TOP_MESSAGE => message_top_int,

      ECDSA_TOP_SIGNATURE_R_CHECK => signature_r_check_top_int,
      ECDSA_TOP_SIGNATURE_S_CHECK => signature_s_check_top_int,

      ECDSA_TOP_SIGNATURE_R => signature_r_top_int,
      ECDSA_TOP_SIGNATURE_S => signature_s_top_int
      );

  -- ***************************************************************************
  -- ********************************* peripheral_dsa_ecdsa_top *******************************
  -- ***************************************************************************

  peripheral_dsa_ecdsa_top_dut : peripheral_dsa_ecdsa_top
    generic map (
      DATA_SIZE  => DATA_SIZE,
      BLOCK_SIZE => BLOCK_SIZE,
      WORD_SIZE  => WORD_SIZE_512
      )
    port map (
      -- GLOBAL
      CLK => clk,
      RST => rst,

      -- CONTROL
      START => start_top_int,
      READY => ready_top_int,

      DATA_IN_ENABLE  => data_in_enable_top_int,
      DATA_OUT_ENABLE => data_out_enable_top_int,

      MODE => mode_top_int,
      FAIL => fail_top_int,

      -- DATA
      PRIVATE_KEY   => private_key_top_int,
      GENERATED_KEY => generated_key_top_int,

      PUBLIC_KEY_X_CHECK => public_key_x_check_top_int,
      PUBLIC_KEY_Y_CHECK => public_key_y_check_top_int,

      DATA_BLOCK_SIZE => data_block_size_top_int,

      MESSAGE => message_top_int,

      SIGNATURE_R_CHECK => signature_r_check_top_int,
      SIGNATURE_S_CHECK => signature_s_check_top_int,

      SIGNATURE_R => signature_r_top_int,
      SIGNATURE_S => signature_s_top_int
      );

  scalar_assertion : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (ready_top_int = '1') then
        assert signature_r_top_int = TOP_SIGNATURE_R
          report "SCALAR TOP: CALCULATED = " & to_string(signature_r_top_int) & "; CORRECT = " & to_string(TOP_SIGNATURE_R)
          severity error;

        assert signature_s_top_int = TOP_SIGNATURE_S
          report "SCALAR TOP: CALCULATED = " & to_string(signature_s_top_int) & "; CORRECT = " & to_string(TOP_SIGNATURE_S)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

end architecture peripheral_dsa_ecdsa_top_testbench_architecture;
