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
use work.ecdsa_sha256_pkg.all;

entity ecdsa_sha256 is
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
end entity;

architecture ecdsa_sha256_architecture of ecdsa_sha256 is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type sha256_ctrl_fsm_type is (
    STARTER_ST,
    INPUT_ST,
    SCHEDULER_ST,
    HASH_02a_ST,
    HASH_02b_ST,
    HASH_03_ST,
    ENDER_ST
  );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant HASH_02_COUNT_LIMIT : integer := 64;

  constant K : K_DATA := (
    X"428a2f98", X"71374491", X"b5c0fbcf", X"e9b5dba5",
    X"3956c25b", X"59f111f1", X"923f82a4", X"ab1c5ed5",
    X"d807aa98", X"12835b01", X"243185be", X"550c7dc3",
    X"72be5d74", X"80deb1fe", X"9bdc06a7", X"c19bf174",
    X"e49b69c1", X"efbe4786", X"0fc19dc6", X"240ca1cc",
    X"2de92c6f", X"4a7484aa", X"5cb0a9dc", X"76f988da",
    X"983e5152", X"a831c66d", X"b00327c8", X"bf597fc7",
    X"c6e00bf3", X"d5a79147", X"06ca6351", X"14292967",
    X"27b70a85", X"2e1b2138", X"4d2c6dfc", X"53380d13",
    X"650a7354", X"766a0abb", X"81c2c92e", X"92722c85",
    X"a2bfe8a1", X"a81a664b", X"c24b8b70", X"c76c51a3",
    X"d192e819", X"d6990624", X"f40e3585", X"106aa070",
    X"19a4c116", X"1e376c08", X"2748774c", X"34b0bcb5",
    X"391c0cb3", X"4ed8aa4a", X"5b9cca4f", X"682e6ff3",
    X"748f82ee", X"78a5636f", X"84c87814", X"8cc70208",
    X"90befffa", X"a4506ceb", X"bef9a3f7", X"c67178f2"
  );

  constant HV_INITIAL_VALUES : H_DATA := (
    X"6a09e667", X"bb67ae85", X"3c6ef372",
    X"a54ff53a", X"510e527f", X"9b05688c",
    X"1f83d9ab", X"5be0cd19"
  );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Message schedule, w(00), w(01), ...w(63) (80 64-bit words)
  signal w : K_DATA;

  signal hash_round_cnt : integer;
  signal hash_02_cnt    : integer;

  -- Temporary words
  signal t1 : std_logic_vector(WORD_SIZE-1 downto 0);
  signal t2 : std_logic_vector(WORD_SIZE-1 downto 0);

  -- Working variables, 8 64-bit words
  signal a : std_logic_vector(WORD_SIZE-1 downto 0);
  signal b : std_logic_vector(WORD_SIZE-1 downto 0);
  signal c : std_logic_vector(WORD_SIZE-1 downto 0);
  signal d : std_logic_vector(WORD_SIZE-1 downto 0);
  signal e : std_logic_vector(WORD_SIZE-1 downto 0);
  signal f : std_logic_vector(WORD_SIZE-1 downto 0);
  signal g : std_logic_vector(WORD_SIZE-1 downto 0);
  signal h : std_logic_vector(WORD_SIZE-1 downto 0);

  -- Hash values w/ initial hash values; 8 64-bit words
  signal hv : H_DATA;

  -- Message blocks, the padded message should be a multiple of 512 bits,
  signal m : M_DATA;

  -- Intermediate Message Schedule values; for use with a for-generate loop;
  signal w_int : K_DATA;

  -- Finite State Machine
  signal sha256_ctrl_fsm_st : sha256_ctrl_fsm_type;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  sha256_fsm : process (CLK, RST)
  begin
    if (RST = '0') then
      -- Assignations
      hv             <= HV_INITIAL_VALUES;
      hash_02_cnt    <= 0;
      hash_round_cnt <= 0;

      -- Data Outputs
      DATA_OUT <= (others => '0');

      -- Control Outputs
      DATA_OUT_ENABLE <= '0';
      READY           <= '0';

    elsif (rising_edge(CLK)) then
      case sha256_ctrl_fsm_st is
        when STARTER_ST => 

          if (START = '1') then
            -- Assignations
            hv             <= HV_INITIAL_VALUES;
            hash_02_cnt    <= 0;
            hash_round_cnt <= 0;

            -- FSM Control
            sha256_ctrl_fsm_st <= INPUT_ST;
          end if;

          -- Control Outputs
          READY <= '0';

        when INPUT_ST =>

          if (DATA_IN_ENABLE = '1' or hash_round_cnt = 0) then
            -- Message blocks
            for i in 0 to 15 loop
              m(i) <= DATA_IN((WORD_SIZE*i) to WORD_SIZE*(i+1)-1);
            end loop;

            -- Assignations
            a <= hv(0);
            b <= hv(1);
            c <= hv(2);
            d <= hv(3);
            e <= hv(4);
            f <= hv(5);
            g <= hv(6);
            h <= hv(7);

            -- FSM Control
            sha256_ctrl_fsm_st <= SCHEDULER_ST;
          end if;

          -- Control Outputs
          DATA_OUT_ENABLE <= '0';

        when SCHEDULER_ST =>

          -- Assignations
          w(0  to 15) <= w_int(0  to 15);
          w(16 to 31) <= w_int(16 to 31);
          w(32 to 47) <= w_int(32 to 47);
          w(48 to 63) <= w_int(48 to 63);

          -- FSM Control
          sha256_ctrl_fsm_st <= HASH_02a_ST;

        when HASH_02a_ST =>

          if (hash_02_cnt = HASH_02_COUNT_LIMIT) then
            -- Assignations
            hash_02_cnt <= 0;

            -- FSM Control
            sha256_ctrl_fsm_st <= HASH_03_ST;
          else
            -- Assignations
            t1 <= std_logic_vector(unsigned(h) + unsigned(SIGMA_UCASE_1(e)) + unsigned(CH(e, f, g)) + unsigned(K(hash_02_cnt)) + unsigned(w(hash_02_cnt)));
            t2 <= std_logic_vector(unsigned(SIGMA_UCASE_0(a)) + unsigned(MAJ(a, b, c)));

            -- FSM Control
            sha256_ctrl_fsm_st <= HASH_02b_ST;
          end if;

        when HASH_02b_ST =>

          -- Assignations
          h <= g;
          g <= f;
          f <= e;
          e <= std_logic_vector(unsigned(d) + unsigned(t1));
          d <= c;
          c <= b;
          b <= a;
          a <= std_logic_vector(unsigned(t1) + unsigned(t2));
          
          hash_02_cnt <= hash_02_cnt + 1;

          -- FSM Control
          sha256_ctrl_fsm_st <= HASH_02a_ST;

        when HASH_03_ST =>

          -- Assignations
          hv(0) <= std_logic_vector(unsigned(a) + unsigned(hv(0)));
          hv(1) <= std_logic_vector(unsigned(b) + unsigned(hv(1)));
          hv(2) <= std_logic_vector(unsigned(c) + unsigned(hv(2)));
          hv(3) <= std_logic_vector(unsigned(d) + unsigned(hv(3)));
          hv(4) <= std_logic_vector(unsigned(e) + unsigned(hv(4)));
          hv(5) <= std_logic_vector(unsigned(f) + unsigned(hv(5)));
          hv(6) <= std_logic_vector(unsigned(g) + unsigned(hv(6)));
          hv(7) <= std_logic_vector(unsigned(h) + unsigned(hv(7)));

          if (hash_round_cnt = to_integer(unsigned(DATA_BLOCK_SIZE))-1) then
            -- Assignations
            hash_round_cnt <= 0;

            -- Control Outputs
            DATA_OUT_ENABLE <= '0';

            -- FSM Control
            sha256_ctrl_fsm_st <= ENDER_ST;
          else
            -- Assignations
            hash_round_cnt <= hash_round_cnt + 1;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';

            -- FSM Control
            sha256_ctrl_fsm_st <= INPUT_ST;
          end if;

        when ENDER_ST =>

          -- Control Outputs
          READY <= '1';

          -- Data Outputs
          DATA_OUT <= hv(0) & hv(1) & hv(2) & hv(3) & hv(4) & hv(5) & hv(6) & hv(7);

          -- FSM Control
          sha256_ctrl_fsm_st <= STARTER_ST;

        when others =>
          null;
      end case;
    end if;
  end process;

  MESSAGE_SCHEDULE : for i in 0 to 63 generate
    MESSAGE_SCHEDULE_CND : if i < 16 generate
      w_int(i) <= m(i);
    else generate
      w_int(i) <= std_logic_vector(unsigned(SIGMA_LCASE_1(w_int(i-2))) + unsigned(w_int(i-7)) + unsigned(SIGMA_LCASE_0(w_int(i-15))) + unsigned(w_int(i-16)));
    end generate;
  end generate;
end architecture;