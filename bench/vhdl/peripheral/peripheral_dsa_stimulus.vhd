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

--library modelsim_lib;
--use modelsim_lib.util.all;

use work.peripheral_dsa_package.all;

entity peripheral_dsa_stimulus is
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
    -- DSA-SHA256
    -------------------------------------------------------

    -- CONTROL
    DSA_SHA256_START : out std_logic;
    DSA_SHA256_READY : in  std_logic;

    DSA_SHA256_DATA_IN_ENABLE  : out std_logic;
    DSA_SHA256_DATA_OUT_ENABLE : in  std_logic;

    -- DATA
    DSA_SHA256_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_SHA256_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_256-1);
    DSA_SHA256_DATA_OUT : in  std_logic_vector(WORD_SIZE_256*8-1 downto 0);

    -------------------------------------------------------
    -- DSA-SHA512
    -------------------------------------------------------

    -- CONTROL
    DSA_SHA512_START : out std_logic;
    DSA_SHA512_READY : in  std_logic;

    DSA_SHA512_DATA_IN_ENABLE  : out std_logic;
    DSA_SHA512_DATA_OUT_ENABLE : in  std_logic;

    -- DATA
    DSA_SHA512_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_SHA512_DATA_IN  : out std_logic_vector(0 to 16*WORD_SIZE_512-1);
    DSA_SHA512_DATA_OUT : in  std_logic_vector(WORD_SIZE_512*8-1 downto 0);

    -------------------------------------------------------
    -- DSA-ADDER
    -------------------------------------------------------

    -- CONTROL
    DSA_ADDER_START : out std_logic;
    DSA_ADDER_READY : in  std_logic;

    DSA_ADDER_OPERATION : out std_logic;

    -- DATA
    DSA_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-INVERTER
    -------------------------------------------------------

    -- CONTROL
    DSA_INVERTER_START : out std_logic;
    DSA_INVERTER_READY : in  std_logic;

    -- DATA
    DSA_INVERTER_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_INVERTER_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-MULTIPLIER
    -------------------------------------------------------

    -- CONTROL
    DSA_MULTIPLIER_START : out std_logic;
    DSA_MULTIPLIER_READY : in  std_logic;

    -- DATA
    DSA_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-POINT_ADDER
    -------------------------------------------------------

    -- CONTROL
    DSA_POINT_ADDER_START : out std_logic;
    DSA_POINT_ADDER_READY : in  std_logic;

    -- DATA
    DSA_POINT_IN_PX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_IN_PY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_IN_QX_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_IN_QY_ADDER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_RX_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_RY_ADDER : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-POINT_DOUBLER
    -------------------------------------------------------

    -- CONTROL
    DSA_POINT_DOUBLER_START : out std_logic;
    DSA_POINT_DOUBLER_READY : in  std_logic;

    -- DATA
    DSA_POINT_IN_PX_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_IN_PY_DOUBLER  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_RX_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_RY_DOUBLER : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-POINT_GENERATOR
    -------------------------------------------------------

    -- CONTROL
    DSA_POINT_GENERATOR_START : out std_logic;
    DSA_POINT_GENERATOR_READY : in  std_logic;

    -- DATA
    DSA_PRIVATE_KEY_GENERATOR : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_POINT_IN_X_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_IN_Y_GENERATOR  : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_X_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_POINT_OUT_Y_GENERATOR : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-ECDSA-SIGN
    -------------------------------------------------------

    -- CONTROL
    DSA_ECDSA_SIGN_START : out std_logic;
    DSA_ECDSA_SIGN_READY : in  std_logic;

    DSA_ECDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
    DSA_ECDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

    -- DATA
    DSA_ECDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_ECDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_ECDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_ECDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-ECDSA-VERIFY
    -------------------------------------------------------

    -- CONTROL
    DSA_ECDSA_VERIFY_START : out std_logic;
    DSA_ECDSA_VERIFY_READY : in  std_logic;

    DSA_ECDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
    DSA_ECDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

    DSA_ECDSA_VERIFY_FAIL : in std_logic;

    -- DATA
    DSA_ECDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_ECDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_ECDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_ECDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-ECDSA-TOP
    -------------------------------------------------------

    -- CONTROL
    DSA_ECDSA_TOP_START : out std_logic;
    DSA_ECDSA_TOP_READY : in  std_logic;

    DSA_ECDSA_TOP_DATA_IN_ENABLE  : out std_logic;
    DSA_ECDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

    DSA_ECDSA_TOP_MODE : out std_logic;
    DSA_ECDSA_TOP_FAIL : in  std_logic;

    -- DATA
    DSA_ECDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_ECDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_ECDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_ECDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_ECDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_ECDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_ECDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-KCDSA-SIGN
    -------------------------------------------------------

    -- CONTROL
    DSA_KCDSA_SIGN_START : out std_logic;
    DSA_KCDSA_SIGN_READY : in  std_logic;

    DSA_KCDSA_SIGN_DATA_IN_ENABLE  : out std_logic;
    DSA_KCDSA_SIGN_DATA_OUT_ENABLE : in  std_logic;

    -- DATA
    DSA_KCDSA_SIGN_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_SIGN_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_KCDSA_SIGN_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_KCDSA_SIGN_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_KCDSA_SIGN_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_SIGN_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-KCDSA-VERIFY
    -------------------------------------------------------

    -- CONTROL
    DSA_KCDSA_VERIFY_START : out std_logic;
    DSA_KCDSA_VERIFY_READY : in  std_logic;

    DSA_KCDSA_VERIFY_DATA_IN_ENABLE  : out std_logic;
    DSA_KCDSA_VERIFY_DATA_OUT_ENABLE : in  std_logic;

    DSA_KCDSA_VERIFY_FAIL : in std_logic;

    -- DATA
    DSA_KCDSA_VERIFY_PUBLIC_KEY_X : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_VERIFY_PUBLIC_KEY_Y : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_KCDSA_VERIFY_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_KCDSA_VERIFY_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_KCDSA_VERIFY_SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_VERIFY_SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0);

    -------------------------------------------------------
    -- DSA-KCDSA-TOP
    -------------------------------------------------------

    -- CONTROL
    DSA_KCDSA_TOP_START : out std_logic;
    DSA_KCDSA_TOP_READY : in  std_logic;

    DSA_KCDSA_TOP_DATA_IN_ENABLE  : out std_logic;
    DSA_KCDSA_TOP_DATA_OUT_ENABLE : in  std_logic;

    DSA_KCDSA_TOP_MODE : out std_logic;
    DSA_KCDSA_TOP_FAIL : in  std_logic;

    -- DATA
    DSA_KCDSA_TOP_PRIVATE_KEY   : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_TOP_GENERATED_KEY : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_KCDSA_TOP_PUBLIC_KEY_X_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_TOP_PUBLIC_KEY_Y_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_KCDSA_TOP_DATA_BLOCK_SIZE : out std_logic_vector(BLOCK_SIZE-1 downto 0);

    DSA_KCDSA_TOP_MESSAGE : out std_logic_vector(0 to 16*WORD_SIZE_512-1);

    DSA_KCDSA_TOP_SIGNATURE_R_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_TOP_SIGNATURE_S_CHECK : out std_logic_vector(DATA_SIZE-1 downto 0);

    DSA_KCDSA_TOP_SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
    DSA_KCDSA_TOP_SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture peripheral_dsa_stimulus_architecture of peripheral_dsa_stimulus is

  -- Block Counter
  signal i : integer := 1;
  signal j : integer := 1;

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

  DSA_SHA256_START          <= start_int;
  DSA_SHA512_START          <= start_int;
  DSA_ADDER_START           <= start_int;
  DSA_INVERTER_START        <= start_int;
  DSA_MULTIPLIER_START      <= start_int;
  DSA_POINT_ADDER_START     <= start_int;
  DSA_POINT_DOUBLER_START   <= start_int;
  DSA_POINT_GENERATOR_START <= start_int;
  DSA_ECDSA_SIGN_START            <= start_int;
  DSA_ECDSA_VERIFY_START          <= start_int;
  DSA_ECDSA_TOP_START             <= start_int;
  DSA_KCDSA_SIGN_START            <= start_int;
  DSA_KCDSA_VERIFY_START          <= start_int;
  DSA_KCDSA_TOP_START             <= start_int;

  -------------------------------------------------------
  -- STIMULUS
  -------------------------------------------------------

  main_test : process
  begin

    if (DSA_SHA256_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_SHA256_TEST          ";
      --------------------------------------------------------------

      if (DSA_SHA256_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_SHA256_CASE_1        ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_SHA256_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_SHA256_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_256_1;
        DSA_SHA256_DATA_IN         <= DATA_INPUT_256_1;

        wait for 5000 ns;

      end if;

      if (DSA_SHA256_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_SHA256_CASE_2        ";
        --------------------------------------------------------------

        -- DATA
        DSA_SHA256_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_256_2;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_SHA256_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_SHA256_DATA_IN <= DATA_INPUT_256_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_SHA256_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_SHA256_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_SHA256_DATA_IN <= DATA_INPUT_256_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_SHA256_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_SHA256_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 5000 ns;

      end if;
    end if;

    if (DSA_SHA512_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_SHA512_TEST          ";
      --------------------------------------------------------------

      if (DSA_SHA512_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_SHA512_CASE_1        ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_SHA512_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_SHA512_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_1;
        DSA_SHA512_DATA_IN         <= DATA_INPUT_512_1;

        wait for 5000 ns;

      end if;

      if (DSA_SHA512_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_SHA512_CASE_2        ";
        --------------------------------------------------------------

        -- DATA
        DSA_SHA512_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_2;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_SHA512_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_SHA512_DATA_IN <= DATA_INPUT_512_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_SHA512_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_SHA512_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_SHA512_DATA_IN <= DATA_INPUT_512_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_SHA512_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_SHA512_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 5000 ns;

      end if;
    end if;

    if (DSA_ADDER_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_ADDER_TEST           ";
      --------------------------------------------------------------

      if (DSA_ADDER_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ADDER_CASE_1         ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ADDER_OPERATION <= '0';

        -- DATA
        DSA_ADDER_DATA_A_IN <= ADDER_DATA_A_IN;
        DSA_ADDER_DATA_B_IN <= ADDER_DATA_B_IN;

        wait for 250000 ns;

      end if;

      if (DSA_SUBTRACTOR_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_SUBTRACTOR_CASE_1    ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ADDER_OPERATION <= '1';

        -- DATA
        DSA_ADDER_DATA_A_IN <= ADDER_DATA_A_IN;
        DSA_ADDER_DATA_B_IN <= ADDER_DATA_B_IN;

        wait for 250000 ns;

      end if;
    end if;

    if (DSA_INVERTER_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_INVERTER_TEST        ";
      --------------------------------------------------------------

      if (DSA_INVERTER_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_INVERTER_CASE_1      ";
        --------------------------------------------------------------

        -- DATA
        DSA_INVERTER_DATA_IN <= INVERTER_DATA_IN;

        wait for 250000 ns;

      end if;
    end if;

    if (DSA_MULTIPLIER_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_MULTIPLIER_TEST      ";
      --------------------------------------------------------------

      if (DSA_MULTIPLIER_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_MULTIPLIER_CASE_1    ";
        --------------------------------------------------------------

        -- DATA
        DSA_MULTIPLIER_DATA_A_IN <= MULTIPLIER_DATA_A_IN;
        DSA_MULTIPLIER_DATA_B_IN <= MULTIPLIER_DATA_B_IN;

        wait for 250000 ns;

      end if;
    end if;

    if (DSA_POINT_ADDER_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_P_ADDER_TEST         ";
      --------------------------------------------------------------

      if (DSA_POINT_ADDER_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_P_ADDER_CASE_1       ";
        --------------------------------------------------------------

        -- DATA
        DSA_POINT_IN_PX_ADDER <= POINT_ADDER_IN_PX;
        DSA_POINT_IN_PY_ADDER <= POINT_ADDER_IN_PY;
        DSA_POINT_IN_QX_ADDER <= POINT_ADDER_IN_QX;
        DSA_POINT_IN_QY_ADDER <= POINT_ADDER_IN_QY;

        wait for 250000 ns;

      end if;
    end if;

    if (DSA_POINT_DOUBLER_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_P_DOUBLER_TEST       ";
      --------------------------------------------------------------

      if (DSA_POINT_DOUBLER_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_P_DOUBLER_CASE_1     ";
        --------------------------------------------------------------

        -- DATA
        DSA_POINT_IN_PX_DOUBLER <= POINT_DOUBLER_IN_PX;
        DSA_POINT_IN_PY_DOUBLER <= POINT_DOUBLER_IN_PY;

        wait for 250000 ns;

      end if;
    end if;

    if (DSA_POINT_GENERATOR_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_P_GENERATOR_TEST     ";
      --------------------------------------------------------------

      if (DSA_POINT_GENERATOR_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_P_GENERATOR_CASE_1   ";
        --------------------------------------------------------------

        -- DATA
        DSA_PRIVATE_KEY_GENERATOR <= POINT_GENERATOR_PRIVATE_KEY;

        DSA_POINT_IN_X_GENERATOR <= POINT_GENERATOR_IN_X;
        DSA_POINT_IN_Y_GENERATOR <= POINT_GENERATOR_IN_Y;

        wait for 80000000 ns;

      end if;
    end if;

    if (DSA_ECDSA_SIGN_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_ECDSA_SIGN_TEST      ";
      --------------------------------------------------------------

      if (DSA_ECDSA_SIGN_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_SIGN_CASE_1    ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ECDSA_SIGN_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_ECDSA_SIGN_PRIVATE_KEY   <= SIGN_PRIVATE_KEY;
        DSA_ECDSA_SIGN_GENERATED_KEY <= SIGN_GENERATED_KEY;

        DSA_ECDSA_SIGN_DATA_BLOCK_SIZE <= SIGN_DATA_BLOCK_SIZE;
        DSA_ECDSA_SIGN_MESSAGE         <= SIGN_MESSAGE;

        wait for 200000000 ns;

      end if;

      if (DSA_ECDSA_SIGN_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_SIGN_CASE_2    ";
        --------------------------------------------------------------

        -- DATA
        DSA_ECDSA_SIGN_PRIVATE_KEY   <= SIGN_PRIVATE_KEY;
        DSA_ECDSA_SIGN_GENERATED_KEY <= SIGN_GENERATED_KEY;

        DSA_ECDSA_SIGN_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_2;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_ECDSA_SIGN_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_ECDSA_SIGN_MESSAGE <= DATA_INPUT_512_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_ECDSA_SIGN_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_ECDSA_SIGN_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_ECDSA_SIGN_MESSAGE <= DATA_INPUT_512_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_ECDSA_SIGN_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_ECDSA_SIGN_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 200000000 ns;

      end if;
    end if;

    if (DSA_ECDSA_VERIFY_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_ECDSA_VERIFY_TEST    ";
      --------------------------------------------------------------

      if (DSA_ECDSA_VERIFY_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_VERIFY_CASE_1  ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ECDSA_VERIFY_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_ECDSA_VERIFY_PUBLIC_KEY_X <= VERIFY_PUBLIC_KEY_X;
        DSA_ECDSA_VERIFY_PUBLIC_KEY_Y <= VERIFY_PUBLIC_KEY_Y;

        DSA_ECDSA_VERIFY_DATA_BLOCK_SIZE <= VERIFY_DATA_BLOCK_SIZE;
        DSA_ECDSA_VERIFY_MESSAGE         <= VERIFY_MESSAGE;

        DSA_ECDSA_VERIFY_SIGNATURE_R <= VERIFY_SIGNATURE_R;
        DSA_ECDSA_VERIFY_SIGNATURE_S <= VERIFY_SIGNATURE_S;

        wait for 200000000 ns;

      end if;

      if (DSA_ECDSA_VERIFY_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_VERIFY_CASE_2  ";
        --------------------------------------------------------------

        -- DATA
        DSA_ECDSA_VERIFY_PUBLIC_KEY_X <= VERIFY_PUBLIC_KEY_X;
        DSA_ECDSA_VERIFY_PUBLIC_KEY_Y <= VERIFY_PUBLIC_KEY_Y;

        DSA_ECDSA_VERIFY_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_2;

        DSA_ECDSA_VERIFY_SIGNATURE_R <= VERIFY_SIGNATURE_R;
        DSA_ECDSA_VERIFY_SIGNATURE_S <= VERIFY_SIGNATURE_S;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_ECDSA_VERIFY_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_ECDSA_VERIFY_MESSAGE <= DATA_INPUT_512_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_ECDSA_VERIFY_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_ECDSA_VERIFY_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_ECDSA_VERIFY_MESSAGE <= DATA_INPUT_512_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_ECDSA_VERIFY_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_ECDSA_VERIFY_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 200000000 ns;

      end if;
    end if;

    if (DSA_ECDSA_TOP_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_ECDSA_TOP_TEST       ";
      --------------------------------------------------------------

      if (DSA_ECDSA_TOP_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_TOP_CASE_1     ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ECDSA_TOP_MODE           <= '0';
        DSA_ECDSA_TOP_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_ECDSA_TOP_PRIVATE_KEY   <= TOP_PRIVATE_KEY;
        DSA_ECDSA_TOP_GENERATED_KEY <= TOP_GENERATED_KEY;

        DSA_ECDSA_TOP_PUBLIC_KEY_X_CHECK <= TOP_PUBLIC_KEY_X;
        DSA_ECDSA_TOP_PUBLIC_KEY_Y_CHECK <= TOP_PUBLIC_KEY_Y;

        DSA_ECDSA_TOP_DATA_BLOCK_SIZE <= TOP_DATA_BLOCK_SIZE;
        DSA_ECDSA_TOP_MESSAGE         <= TOP_MESSAGE;

        DSA_ECDSA_TOP_SIGNATURE_R_CHECK <= TOP_SIGNATURE_R;
        DSA_ECDSA_TOP_SIGNATURE_S_CHECK <= TOP_SIGNATURE_S;

        wait for 200000000 ns;

      end if;

      if (DSA_ECDSA_TOP_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_ECDSA_TOP_CASE_2     ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_ECDSA_TOP_MODE           <= '1';
        DSA_ECDSA_TOP_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_ECDSA_TOP_PRIVATE_KEY   <= TOP_PRIVATE_KEY;
        DSA_ECDSA_TOP_GENERATED_KEY <= TOP_GENERATED_KEY;

        DSA_ECDSA_TOP_PUBLIC_KEY_X_CHECK <= TOP_PUBLIC_KEY_X;
        DSA_ECDSA_TOP_PUBLIC_KEY_Y_CHECK <= TOP_PUBLIC_KEY_Y;

        DSA_ECDSA_TOP_DATA_BLOCK_SIZE <= TOP_DATA_BLOCK_SIZE;
        DSA_ECDSA_TOP_MESSAGE         <= DATA_INPUT_512_1;

        DSA_ECDSA_TOP_SIGNATURE_R_CHECK <= TOP_SIGNATURE_R;
        DSA_ECDSA_TOP_SIGNATURE_S_CHECK <= TOP_SIGNATURE_S;

        wait for 200000000 ns;

      end if;
    end if;

    if (DSA_KCDSA_SIGN_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_KCDSA_SIGN_TEST      ";
      --------------------------------------------------------------

      if (DSA_KCDSA_SIGN_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_SIGN_CASE_1    ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_KCDSA_SIGN_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_KCDSA_SIGN_PRIVATE_KEY   <= SIGN_PRIVATE_KEY_KCDSA;
        DSA_KCDSA_SIGN_GENERATED_KEY <= SIGN_GENERATED_KEY_KCDSA;

        DSA_KCDSA_SIGN_DATA_BLOCK_SIZE <= SIGN_DATA_BLOCK_SIZE_KCDSA;
        DSA_KCDSA_SIGN_MESSAGE         <= SIGN_MESSAGE_KCDSA;

        wait for 200000000 ns;

      end if;

      if (DSA_KCDSA_SIGN_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_SIGN_CASE_2    ";
        --------------------------------------------------------------

        -- DATA
        DSA_KCDSA_SIGN_PRIVATE_KEY   <= SIGN_PRIVATE_KEY_KCDSA;
        DSA_KCDSA_SIGN_GENERATED_KEY <= SIGN_GENERATED_KEY_KCDSA;

        DSA_KCDSA_SIGN_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_2;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_KCDSA_SIGN_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_KCDSA_SIGN_MESSAGE <= DATA_INPUT_512_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_KCDSA_SIGN_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_KCDSA_SIGN_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_KCDSA_SIGN_MESSAGE <= DATA_INPUT_512_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_KCDSA_SIGN_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_KCDSA_SIGN_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 200000000 ns;

      end if;
    end if;

    if (DSA_KCDSA_VERIFY_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_KCDSA_VERIFY_TEST    ";
      --------------------------------------------------------------

      if (DSA_KCDSA_VERIFY_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_VERIFY_CASE_1  ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_KCDSA_VERIFY_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_KCDSA_VERIFY_PUBLIC_KEY_X <= VERIFY_PUBLIC_KEY_X_KCDSA;
        DSA_KCDSA_VERIFY_PUBLIC_KEY_Y <= VERIFY_PUBLIC_KEY_Y_KCDSA;

        DSA_KCDSA_VERIFY_DATA_BLOCK_SIZE <= VERIFY_DATA_BLOCK_SIZE;
        DSA_KCDSA_VERIFY_MESSAGE         <= VERIFY_MESSAGE;

        DSA_KCDSA_VERIFY_SIGNATURE_R <= VERIFY_SIGNATURE_R_KCDSA;
        DSA_KCDSA_VERIFY_SIGNATURE_S <= VERIFY_SIGNATURE_S_KCDSA;

        wait for 200000000 ns;

      end if;

      if (DSA_KCDSA_VERIFY_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_VERIFY_CASE_2  ";
        --------------------------------------------------------------

        -- DATA
        DSA_KCDSA_VERIFY_PUBLIC_KEY_X <= VERIFY_PUBLIC_KEY_X_KCDSA;
        DSA_KCDSA_VERIFY_PUBLIC_KEY_Y <= VERIFY_PUBLIC_KEY_Y_KCDSA;

        DSA_KCDSA_VERIFY_DATA_BLOCK_SIZE <= DATA_BLOCK_SIZE_512_2;

        DSA_KCDSA_VERIFY_SIGNATURE_R <= VERIFY_SIGNATURE_R_KCDSA;
        DSA_KCDSA_VERIFY_SIGNATURE_S <= VERIFY_SIGNATURE_S_KCDSA;

        -- INITIAL CONDITIONS
        -- CONTROL
        DSA_KCDSA_VERIFY_DATA_IN_ENABLE <= '1';

        -- DATA
        DSA_KCDSA_VERIFY_MESSAGE <= DATA_INPUT_512_2(i);

        -- Block Counter
        i <= i + 1;

        loop
          if (DSA_KCDSA_VERIFY_DATA_OUT_ENABLE = '1' and i = 2) then
            -- CONTROL
            DSA_KCDSA_VERIFY_DATA_IN_ENABLE <= '1';

            -- DATA
            DSA_KCDSA_VERIFY_MESSAGE <= DATA_INPUT_512_2(i);

            -- Block Counter
            i <= i + 1;
          else
            DSA_KCDSA_VERIFY_DATA_IN_ENABLE <= '0';
          end if;

          exit when DSA_KCDSA_VERIFY_READY = '1';
          wait until rising_edge(clk_int);
        end loop;

        wait for 200000000 ns;

      end if;
    end if;

    if (DSA_KCDSA_TOP_TEST) then

      --------------------------------------------------------------
      MONITOR_TEST <= "DSA_KCDSA_TOP_TEST       ";
      --------------------------------------------------------------

      if (DSA_KCDSA_TOP_CASE_1) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_TOP_CASE_1     ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_KCDSA_TOP_MODE           <= '0';
        DSA_KCDSA_TOP_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_KCDSA_TOP_PRIVATE_KEY   <= TOP_PRIVATE_KEY_KCDSA;
        DSA_KCDSA_TOP_GENERATED_KEY <= TOP_GENERATED_KEY_KCDSA;

        DSA_KCDSA_TOP_PUBLIC_KEY_X_CHECK <= TOP_PUBLIC_KEY_X_KCDSA;
        DSA_KCDSA_TOP_PUBLIC_KEY_Y_CHECK <= TOP_PUBLIC_KEY_Y_KCDSA;

        DSA_KCDSA_TOP_DATA_BLOCK_SIZE <= TOP_DATA_BLOCK_SIZE_KCDSA;
        DSA_KCDSA_TOP_MESSAGE         <= TOP_MESSAGE_KCDSA;

        DSA_KCDSA_TOP_SIGNATURE_R_CHECK <= TOP_SIGNATURE_R_KCDSA;
        DSA_KCDSA_TOP_SIGNATURE_S_CHECK <= TOP_SIGNATURE_S_KCDSA;

        wait for 200000000 ns;

      end if;

      if (DSA_KCDSA_TOP_CASE_2) then
        --------------------------------------------------------------
        MONITOR_CASE <= "DSA_KCDSA_TOP_CASE_2     ";
        --------------------------------------------------------------

        -- CONTROL
        DSA_KCDSA_TOP_MODE           <= '1';
        DSA_KCDSA_TOP_DATA_IN_ENABLE <= '0';

        -- DATA
        DSA_KCDSA_TOP_PRIVATE_KEY   <= TOP_PRIVATE_KEY_KCDSA;
        DSA_KCDSA_TOP_GENERATED_KEY <= TOP_GENERATED_KEY_KCDSA;

        DSA_KCDSA_TOP_PUBLIC_KEY_X_CHECK <= TOP_PUBLIC_KEY_X_KCDSA;
        DSA_KCDSA_TOP_PUBLIC_KEY_Y_CHECK <= TOP_PUBLIC_KEY_Y_KCDSA;

        DSA_KCDSA_TOP_DATA_BLOCK_SIZE <= TOP_DATA_BLOCK_SIZE;
        DSA_KCDSA_TOP_MESSAGE         <= TOP_MESSAGE;

        DSA_KCDSA_TOP_SIGNATURE_R_CHECK <= TOP_SIGNATURE_R_KCDSA;
        DSA_KCDSA_TOP_SIGNATURE_S_CHECK <= TOP_SIGNATURE_S_KCDSA;

        wait for 200000000 ns;

      end if;
    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture peripheral_dsa_stimulus_architecture;
