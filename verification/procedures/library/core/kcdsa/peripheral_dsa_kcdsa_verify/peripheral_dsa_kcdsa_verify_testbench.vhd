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

use work.peripheral_dsa_kcdsa_verify_pkg.all;

entity peripheral_dsa_kcdsa_verify_testbench is
  generic (
    -- KCDSA-SIZE
    DATA_SIZE     : integer := 512;
    BLOCK_SIZE    : integer := 4;
    WORD_SIZE_256 : integer := 32;
    WORD_SIZE_512 : integer := 64
    );
end peripheral_dsa_kcdsa_verify_testbench;

architecture peripheral_dsa_kcdsa_verify_testbench_architecture of peripheral_dsa_kcdsa_verify_testbench is

  component peripheral_dsa_kcdsa_verify_stimulus is
    generic (
      -- KCDSA-SIZE
      BLOCK_SIZE    : integer := 4;
      WORD_SIZE_256 : integer := 32;
      WORD_SIZE_512 : integer := 64
      );
    port (
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
  end component peripheral_dsa_kcdsa_verify_stimulus;

  component peripheral_dsa_kcdsa_verify is
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

      FAIL : out std_logic;

      -- DATA
      PUBLIC_KEY_X : in std_logic_vector(DATA_SIZE-1 downto 0);
      PUBLIC_KEY_Y : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_BLOCK_SIZE : in std_logic_vector(BLOCK_SIZE-1 downto 0);

      MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE_512-1);

      SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  signal clk : std_logic;
  signal rst : std_logic;

  -------------------------------------------------------
  -- KCDSA-VERIFY
  -------------------------------------------------------

  signal start_verify_int : std_logic;
  signal ready_verify_int : std_logic;

  signal data_in_enable_verify_int  : std_logic;
  signal data_out_enable_verify_int : std_logic;

  signal fail_verify_int : std_logic;

  signal public_key_x_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal public_key_y_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_block_size_verify_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal message_verify_int : std_logic_vector(0 to 16*WORD_SIZE_512-1);

  signal signature_r_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal signature_s_verify_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -- ***************************************************************************
  -- ******************* peripheral_dsa_kcdsa_verify_stimulus ******************
  -- ***************************************************************************

  peripheral_dsa_kcdsa_verify_stimulus_i : peripheral_dsa_kcdsa_verify_stimulus
    generic map (
      -- KCDSA-SIZE
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
      -- KCDSA-VERIFY
      -------------------------------------------------------

      -- CONTROL
      KCDSA_VERIFY_START => start_verify_int,
      KCDSA_VERIFY_READY => ready_verify_int,

      KCDSA_VERIFY_DATA_IN_ENABLE  => data_in_enable_verify_int,
      KCDSA_VERIFY_DATA_OUT_ENABLE => data_out_enable_verify_int,

      KCDSA_VERIFY_FAIL => fail_verify_int,

      -- DATA
      KCDSA_VERIFY_PUBLIC_KEY_X => public_key_x_verify_int,
      KCDSA_VERIFY_PUBLIC_KEY_Y => public_key_y_verify_int,

      KCDSA_VERIFY_DATA_BLOCK_SIZE => data_block_size_verify_int,

      KCDSA_VERIFY_MESSAGE => message_verify_int,

      KCDSA_VERIFY_SIGNATURE_R => signature_r_verify_int,
      KCDSA_VERIFY_SIGNATURE_S => signature_s_verify_int
      );

  -- ***************************************************************************
  -- *********************** peripheral_dsa_kcdsa_verify ***********************
  -- ***************************************************************************

  peripheral_dsa_kcdsa_verify_dut : peripheral_dsa_kcdsa_verify
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
      START => start_verify_int,
      READY => ready_verify_int,

      DATA_IN_ENABLE  => data_in_enable_verify_int,
      DATA_OUT_ENABLE => data_out_enable_verify_int,

      FAIL => fail_verify_int,

      -- DATA
      PUBLIC_KEY_X => public_key_x_verify_int,
      PUBLIC_KEY_Y => public_key_y_verify_int,

      DATA_BLOCK_SIZE => data_block_size_verify_int,

      MESSAGE => message_verify_int,

      SIGNATURE_R => signature_r_verify_int,
      SIGNATURE_S => signature_s_verify_int
      );

  scalar_assertion : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (ready_verify_int = '1') then
        assert signature_r_verify_int = KCDSA_VERIFY_SIGNATURE_R
          report "SCALAR VERIFY: CALCULATED = " & to_string(signature_r_verify_int) & "; CORRECT = " & to_string(KCDSA_VERIFY_SIGNATURE_R)
          severity error;

        assert signature_s_verify_int = KCDSA_VERIFY_SIGNATURE_S
          report "SCALAR VERIFY: CALCULATED = " & to_string(signature_s_verify_int) & "; CORRECT = " & to_string(KCDSA_VERIFY_SIGNATURE_S)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

end architecture peripheral_dsa_kcdsa_verify_testbench_architecture;
