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
use work.ecdsa_pkg.all;

entity kcdsa_top is
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

    MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE-1);

    SIGNATURE_R_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNATURE_S_CHECK : in std_logic_vector(DATA_SIZE-1 downto 0);

    SIGNATURE_R : out std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNATURE_S : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture kcdsa_top_architecture of kcdsa_top is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type sign_ctrl_fsm_type is (
    STARTER_ST,          -- STEP 0; START = '1';                  start_point_generator = '1';
    POINT_GENERATOR_ST,  -- STEP 1; ready_point_generator = '1';
    XOR_ST,              -- STEP 2;                               start_mod = '1';
    SUBTRACTOR_ST,       -- STEP 3; ready_mod = '1';              start_adder = '1';
    ADDER_ST,            -- STEP 4; ready_adder = '1';            start_multiplier = '1';
    ENDER_ST             -- STEP 5; ready_multiplier = '1';
  );

  type verify_ctrl_fsm_type is (
    STARTER_ST,             -- STEP 0; START = '1';                  start_point_generator = '1';
    POINT_GENERATOR_U1_ST,  -- STEP 1; ready_point_generator = '1';
    XOR_ST,                 -- STEP 2;                               start_mod = '1';
    SUBTRACTOR_ST,          -- STEP 2; ready_mod = '1';              start_point_generator = '1';
    POINT_GENERATOR_U2_ST,  -- STEP 3; ready_point_generator = '1';  start_point_adder = '1';
    POINT_ADDER_ST,         -- STEP 4; ready_point_adder = '1';
    ENDER_ST                -- STEP 5;
  );

  type sha_sign_ctrl_fsm_type is (
    STARTER_ST,     -- STEP 0; START = '1';         start_sha512 = '1';
    MESSAGE_ST,     -- STEP 1; ready_sha512 = '1';
    INPUT_ST,       -- STE9 2;                      start_sha512 = '1';
    GENERATION_ST,  -- STEP 3; ready_sha512 = '1';  start_mod = '1';
    ENDER_ST        -- STEP 4; ready_mod = '1';
  );

  type sha_verify_ctrl_fsm_type is (
    STARTER_ST,     -- STEP 0; START = '1';         start_sha512 = '1';
    MESSAGE_ST,     -- STEP 1; ready_sha512 = '1';
    GENERATION_ST,  -- STEP 2;                      start_sha512 = '1';
    ENDER_ST        -- STEP 3; ready_sha512 = '1';
  );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  constant HALF_ZERO : std_logic_vector(DATA_SIZE/2-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE/2));

  constant FORMAT_WORD : std_logic_vector(DATA_SIZE/4-1 downto 0) := x"80000000000000000000000000000000";

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal sign_ctrl_fsm_st       : sign_ctrl_fsm_type;
  signal verify_ctrl_fsm_st     : verify_ctrl_fsm_type;
  signal sha_sign_ctrl_fsm_st   : sha_sign_ctrl_fsm_type;
  signal sha_verify_ctrl_fsm_st : sha_verify_ctrl_fsm_type;

  -- Internal Signals
  signal arithmetic_enable_int : std_logic;
  signal x_int                 : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_int                 : std_logic_vector(DATA_SIZE-1 downto 0);

  signal point_x_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_y_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_enable_int : std_logic;
  signal r_int        : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_enable_int : std_logic;
  signal e_int        : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_enable_int : std_logic;
  signal v_int        : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SHA-512
  -- Control Signals
  signal start_sha512 : std_logic;
  signal ready_sha512 : std_logic;

  signal data_in_enable_sha512_int  : std_logic;
  signal data_out_enable_sha512_int : std_logic;

  -- Data Signals
  signal data_block_size_sha512_int : std_logic_vector(BLOCK_SIZE-1 downto 0);

  signal data_in_sha512_int  : std_logic_vector(0 to 16*WORD_SIZE-1);
  signal data_out_sha512_int : std_logic_vector(WORD_SIZE*8-1 downto 0);

  -- MODULO
  -- Control Signals
  signal start_mod : std_logic;
  signal ready_mod : std_logic;

  -- Data Signals
  signal data_in_mod_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_mod_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDER
  -- Control Signals
  signal start_adder : std_logic;
  signal ready_adder : std_logic;

  signal operation_adder : std_logic;

  -- Data Signals
  signal data_in_a_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_b_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MULTIPLIER
  -- Control Signals
  signal start_multiplier : std_logic;
  signal ready_multiplier : std_logic;

  -- Data Signals
  signal data_in_a_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_b_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_multiplier_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- POINT-ADDER
  -- Control Signals
  signal start_point_adder : std_logic;
  signal ready_point_adder : std_logic;

  -- Data Signals
  signal point_in_px_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qx_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qy_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- POINT-GENERATOR
  -- Control Signals
  signal start_point_generator : std_logic;
  signal ready_point_generator : std_logic;

  -- Data Signals
  signal key_point_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal point_in_x_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_y_generator_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_x_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_y_generator_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  sha_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Finite State Machine
      sha_verify_ctrl_fsm_st <= STARTER_ST;
      sha_sign_ctrl_fsm_st   <= STARTER_ST;

      -- Control Outputs
      DATA_OUT_ENABLE <= '0';

      -- Internal Signals
      r_enable_int <= '0';
      r_int        <= ZERO;
      e_enable_int <= '0';
      e_int        <= ZERO;
      v_enable_int <= '0';
      v_int        <= ZERO;

      -- SHA-512
      -- Control Signals
      start_sha512 <= '0';

      data_in_enable_sha512_int <= '0';

      -- Data Signals
      data_block_size_sha512_int <= (others => '0');

      data_in_sha512_int <= (others => '0');

      -- MODULO
      -- Control Signals
      start_mod <= '0';

      -- Data Signals
      data_in_mod_int <= ZERO;

    elsif (rising_edge(CLK)) then

      if (MODE = '1') then
        case sha_verify_ctrl_fsm_st is
          when STARTER_ST =>            -- STEP 0

            if (START = '1') then
              -- Assignation for next state
              start_sha512               <= '1';
              data_block_size_sha512_int <= DATA_BLOCK_SIZE;

              -- Assignation
              e_enable_int <= '0';
              v_enable_int <= '0';

              -- FSM Control
              sha_verify_ctrl_fsm_st <= MESSAGE_ST;
            end if;

          when MESSAGE_ST =>            -- STEP 1

            if (ready_sha512 = '1') then
              -- Assignation
              e_int        <= data_out_sha512_int;
              e_enable_int <= '1';

              -- FSM Control
              sha_verify_ctrl_fsm_st <= GENERATION_ST;
            else
              -- Assignation for next state
              start_sha512 <= '0';
            end if;

            -- Control Outputs
            DATA_OUT_ENABLE <= data_out_enable_sha512_int;

            -- Data Inputs
            data_in_sha512_int <= MESSAGE;

            -- Control Inputs
            data_in_enable_sha512_int <= DATA_IN_ENABLE;

          when GENERATION_ST =>         -- STEP 2

            if (arithmetic_enable_int = '1') then
              -- Assignation for next state
              start_sha512               <= '1';
              data_block_size_sha512_int <= std_logic_vector(to_unsigned(1, BLOCK_SIZE));
              data_in_sha512_int         <= point_x_int & FORMAT_WORD & HALF_ZERO & std_logic_vector(to_unsigned(DATA_SIZE, DATA_SIZE/4));

              -- FSM Control
              sha_verify_ctrl_fsm_st <= ENDER_ST;
            end if;

          when ENDER_ST =>              -- STEP 3

            if (ready_sha512 = '1') then
              -- Assignation
              v_int        <= data_out_sha512_int;
              v_enable_int <= '1';

              -- FSM Control
              sha_verify_ctrl_fsm_st <= STARTER_ST;
            else
              -- Assignation for next state
              start_sha512 <= '0';
            end if;

          when others =>
            -- FSM Control
            sha_verify_ctrl_fsm_st <= STARTER_ST;
        end case;
      else
        case sha_sign_ctrl_fsm_st is
          when STARTER_ST =>              -- STEP 0

            if (START = '1') then
              -- Assignation for next state
              start_sha512               <= '1';
              data_block_size_sha512_int <= DATA_BLOCK_SIZE;

              -- Assignation
              r_enable_int <= '0';

              -- FSM Control
              sha_sign_ctrl_fsm_st <= MESSAGE_ST;
            end if;

          when MESSAGE_ST =>              -- STEP 1

            if (ready_sha512 = '1') then
              -- Assignation
              e_int <= data_out_sha512_int;

              -- FSM Control
              sha_sign_ctrl_fsm_st <= INPUT_ST;
            else
              -- Assignation for next state
              start_sha512 <= '0';
            end if;

            -- Control Outputs
            DATA_OUT_ENABLE <= data_out_enable_sha512_int;

            -- Data Inputs
            data_in_sha512_int <= MESSAGE;

            -- Control Inputs
            data_in_enable_sha512_int <= DATA_IN_ENABLE;

          when INPUT_ST =>                -- STEP 2

            if (arithmetic_enable_int = '1') then
              -- Assignation for next state
              start_sha512               <= '1';
              data_block_size_sha512_int <= std_logic_vector(to_unsigned(1, BLOCK_SIZE));
              data_in_sha512_int         <= x_int & ZERO;

              -- FSM Control
              sha_sign_ctrl_fsm_st <= GENERATION_ST;
            end if;

          when GENERATION_ST =>           -- STEP 3

            if (ready_sha512 = '1') then
              -- Assignation
              start_mod       <= '1';
              data_in_mod_int <= data_out_sha512_int;

              -- FSM Control
              sha_sign_ctrl_fsm_st <= ENDER_ST;
            else
              -- Assignation for next state
              start_sha512 <= '0';
            end if;

          when ENDER_ST =>                -- STEP 4

            if (ready_mod = '1') then
              -- Assignation
              r_int        <= data_out_mod_int;
              r_enable_int <= '1';

              -- FSM Control
              sha_sign_ctrl_fsm_st <= STARTER_ST;
            else
              -- Assignation for next state
              start_mod <= '0';
            end if;

          when others =>
            -- FSM Control
            sha_sign_ctrl_fsm_st <= STARTER_ST;
        end case;
      end if;
    end if;
  end process;

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Finite State Machine
      sign_ctrl_fsm_st   <= STARTER_ST;
      verify_ctrl_fsm_st <= STARTER_ST;

      -- Data Outputs
      SIGNATURE_R <= ZERO;
      SIGNATURE_S <= ZERO;

      -- Control Outputs
      FAIL  <= '0';
      READY <= '0';

      -- Internal Signals
      arithmetic_enable_int <= '0';
      x_int                 <= ZERO;
      w_int                 <= ZERO;
      point_x_int           <= ZERO;
      point_y_int           <= ZERO;

      -- ADDER
      -- Control Signals
      start_adder <= '0';

      operation_adder <= '0';

      -- Data Signals
      data_in_a_adder_int <= ZERO;
      data_in_b_adder_int <= ZERO;

      -- MULTIPLIER
      -- Control Signals
      start_multiplier <= '0';

      -- Data Signals
      data_in_a_multiplier_int <= ZERO;
      data_in_b_multiplier_int <= ZERO;

      -- POINT-ADDER
      -- Control Signals
      start_point_adder <= '0';

      -- Data Signals
      point_in_px_adder_int <= ZERO;
      point_in_py_adder_int <= ZERO;
      point_in_qx_adder_int <= ZERO;
      point_in_qy_adder_int <= ZERO;

      -- POINT-GENERATOR
      -- Control Signals
      start_point_generator <= '0';

      -- Data Signals
      key_point_generator_int <= ZERO;

      point_in_x_generator_int <= ZERO;
      point_in_y_generator_int <= ZERO;

    elsif (rising_edge(CLK)) then

      -- VERIFY (MODE 1) --

      -- 1. FAIL := '1' when NOT r,s in [1, N-1]
      -- 2. e = SHA-512(m)                 (ecdsa_sha512)
      -- 3. w = r xor e
      -- 4. w = w - n when w >= n
      -- 5. X = s*Q + w*P                  (ecdsa_point_adder, ecdsa_point_generator)
      -- 6. v = SHA-512(x)                 (ecdsa_sha512)
      -- 7. FAIL := '1' when v != r else '0'

      if (MODE = '1') then
        case verify_ctrl_fsm_st is
          when STARTER_ST =>            -- STEP 0

            if (START = '1') then
              if (unsigned(SIGNATURE_R_CHECK) >= unsigned(ONE) and unsigned(SIGNATURE_S_CHECK) >= unsigned(ONE) and unsigned(SIGNATURE_R_CHECK) < unsigned(BLACKPOOL512_N) and unsigned(SIGNATURE_S_CHECK) < unsigned(BLACKPOOL512_N)) then
                -- Assignation for next state
                start_point_generator <= '1';

                key_point_generator_int <= SIGNATURE_S_CHECK;

                point_in_x_generator_int <= PUBLIC_KEY_X_CHECK;
                point_in_y_generator_int <= PUBLIC_KEY_Y_CHECK;

                -- Assignation
                arithmetic_enable_int <= '0';

                -- FSM Control
                verify_ctrl_fsm_st <= POINT_GENERATOR_U1_ST;
              else
                -- Control Outputs
                FAIL  <= '1';
                READY <= '1';
              end if;
            else
              -- Control Outputs
              READY <= '0';
            end if;

          when POINT_GENERATOR_U1_ST =>  -- STEP 1

            if (ready_point_generator = '1') then
              -- Assignation
              point_x_int <= point_out_x_generator_int;
              point_y_int <= point_out_y_generator_int;

              -- FSM Control
              verify_ctrl_fsm_st <= XOR_ST;
            else
              -- Assignation for next state
              start_point_generator <= '0';
            end if;

          when XOR_ST =>                -- STEP 2

            if (e_enable_int = '1') then
              -- Assignation
              w_int <= SIGNATURE_R_CHECK xor e_int;

              -- FSM Control
              verify_ctrl_fsm_st <= SUBTRACTOR_ST;
            end if;

          when SUBTRACTOR_ST =>         -- STEP 2

            if (unsigned(w_int) < unsigned(BLACKPOOL512_N)) then
              -- Assignation for next state
              start_point_generator <= '1';

              key_point_generator_int <= w_int;

              point_in_x_generator_int <= BLACKPOOL512_X;
              point_in_y_generator_int <= BLACKPOOL512_Y;

              -- FSM Control
              verify_ctrl_fsm_st <= POINT_GENERATOR_U2_ST;
            else
              -- Assignation
              w_int <= std_logic_vector(unsigned(w_int) - unsigned(BLACKPOOL512_N));
            end if;

          when POINT_GENERATOR_U2_ST =>  -- STEP 3

            if (ready_point_generator = '1') then
              -- Assignation for next state
              start_point_adder <= '1';

              point_in_px_adder_int <= point_x_int;
              point_in_py_adder_int <= point_y_int;
              point_in_qx_adder_int <= point_out_x_generator_int;
              point_in_qy_adder_int <= point_out_y_generator_int;

              -- FSM Control
              verify_ctrl_fsm_st <= POINT_ADDER_ST;
            else
              -- Assignation for next state
              start_point_generator <= '0';
            end if;

          when POINT_ADDER_ST =>        -- STEP 4

            if (ready_point_adder = '1') then
              -- Assignation
              point_x_int <= point_out_rx_adder_int;
              point_y_int <= point_out_ry_adder_int;

              arithmetic_enable_int <= '1';

              -- FSM Control
              verify_ctrl_fsm_st <= ENDER_ST;
            else
              -- Assignation for next state
              start_point_adder <= '0';
            end if;

          when ENDER_ST =>              -- STEP 6

            if (v_enable_int = '1') then
              -- Control Outputs
              if (unsigned(v_int) = unsigned(SIGNATURE_R_CHECK)) then
                FAIL <= '0';
              else
                FAIL <= '1';
              end if;

              READY <= '1';

              -- FSM Control
              verify_ctrl_fsm_st <= STARTER_ST;
            end if;

          when others =>
            -- FSM Control
            verify_ctrl_fsm_st <= STARTER_ST;
        end case;

        -- SIGN (MODE 0) --

        -- 1. k from [1, N-1]       (ecdsa_prng)
        -- 2. (x, y) = k*P          (ecdsa_point_generator)
        -- 3. r = SHA-512(x)        (ecdsa_sha512)
        -- 4. e = SHA-512(m)        (ecdsa_sha512)
        -- 5. w = r xor e
        -- 7. w = w - n when w >= n
        -- 5. s = (k - w)*d mod n   (ecdsa_adder, ecdsa_multiplier)
        -- 6. return(r,s)

      else
        case sign_ctrl_fsm_st is
          when STARTER_ST =>            -- STEP 0
            -- Control Outputs
            READY <= '0';

            if (START = '1') then
              -- Assignation for next state
              start_point_generator <= '1';

              key_point_generator_int <= GENERATED_KEY;

              point_in_x_generator_int <= BLACKPOOL512_X;
              point_in_y_generator_int <= BLACKPOOL512_Y;

              -- FSM Control
              sign_ctrl_fsm_st <= POINT_GENERATOR_ST;
            end if;

          when POINT_GENERATOR_ST =>    -- STEP 1

            if (ready_point_generator = '1') then
              -- Assignation
              x_int                 <= point_out_x_generator_int;
              arithmetic_enable_int <= '1';

              -- FSM Control
              sign_ctrl_fsm_st <= XOR_ST;
            else
              -- Assignation for next state
              start_point_generator <= '0';
            end if;

          when XOR_ST =>                -- STEP 2

            if (r_enable_int = '1') then
              -- Assignation 
              w_int <= r_int xor e_int;

              -- FSM Control
              sign_ctrl_fsm_st <= SUBTRACTOR_ST;
            end if;

          when SUBTRACTOR_ST =>                -- STEP 3

            if (unsigned(w_int) < unsigned(BLACKPOOL512_N)) then
              -- Assignation for next state
              start_adder <= '1';

              operation_adder <= '1';

              data_in_a_adder_int <= GENERATED_KEY;
              data_in_b_adder_int <= w_int;

              -- FSM Control
              sign_ctrl_fsm_st <= ADDER_ST;
            else
              -- Assignation
              w_int <= std_logic_vector(unsigned(w_int) - unsigned(BLACKPOOL512_N));
            end if;

          when ADDER_ST =>              -- STEP 4

            if (ready_adder = '1') then
              -- Assignation for next state
              start_multiplier         <= '1';
              data_in_a_multiplier_int <= data_out_adder_int;
              data_in_b_multiplier_int <= PRIVATE_KEY;

              -- FSM Control
              sign_ctrl_fsm_st <= ENDER_ST;
            else
              -- Assignation for next state
              start_adder <= '0';
            end if;

          when ENDER_ST =>              -- STEP 5

            if (ready_multiplier = '1') then
              -- Data Outputs
              SIGNATURE_R <= r_int;
              SIGNATURE_S <= data_out_multiplier_int;

              -- Control Outputs
              if (unsigned(data_out_multiplier_int) = unsigned(ZERO)) then
                FAIL <= '1';
              end if;

              READY <= '1';

              -- FSM Control
              sign_ctrl_fsm_st <= STARTER_ST;
            else
              -- Assignation for next state
              start_multiplier <= '0';
            end if;

          when others =>
            -- FSM Control
            sign_ctrl_fsm_st <= STARTER_ST;
        end case;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- SHA-512
  ------------------------------------------------------------------------------

  ecdsa_sha512_i : ecdsa_sha512
    generic map (
      BLOCK_SIZE => BLOCK_SIZE,
      WORD_SIZE  => WORD_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_sha512,
      READY => ready_sha512,

      DATA_IN_ENABLE  => data_in_enable_sha512_int,
      DATA_OUT_ENABLE => data_out_enable_sha512_int,

      -- DATA
      DATA_BLOCK_SIZE => data_block_size_sha512_int,

      DATA_IN  => data_in_sha512_int,
      DATA_OUT => data_out_sha512_int
    );

  ------------------------------------------------------------------------------
  -- Modulo
  ------------------------------------------------------------------------------

  ecdsa_mod_i : ecdsa_mod
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_mod,
      READY => ready_mod,

      -- DATA
      MODULO   => BLACKPOOL512_N,
      DATA_IN  => data_in_mod_int,
      DATA_OUT => data_out_mod_int
    );

  ------------------------------------------------------------------------------
  -- Adder
  ------------------------------------------------------------------------------

  ecdsa_adder_i : ecdsa_adder
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_adder,
      READY => ready_adder,

      OPERATION => operation_adder,

      -- DATA
      MODULO    => BLACKPOOL512_N,
      DATA_A_IN => data_in_a_adder_int,
      DATA_B_IN => data_in_b_adder_int,
      DATA_OUT  => data_out_adder_int
    );

  ------------------------------------------------------------------------------
  -- Multiplier
  ------------------------------------------------------------------------------

  ecdsa_multiplier_i : ecdsa_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_multiplier,
      READY => ready_multiplier,

      -- DATA
      MODULO    => BLACKPOOL512_N,
      DATA_A_IN => data_in_a_multiplier_int,
      DATA_B_IN => data_in_b_multiplier_int,
      DATA_OUT  => data_out_multiplier_int
    );

  ------------------------------------------------------------------------------
  -- Point-Adder
  ------------------------------------------------------------------------------

  ecdsa_point_adder_i : ecdsa_point_adder
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_point_adder,
      READY => ready_point_adder,

      -- DATA
      POINT_IN_PX  => point_in_px_adder_int,
      POINT_IN_PY  => point_in_py_adder_int,
      POINT_IN_QX  => point_in_qx_adder_int,
      POINT_IN_QY  => point_in_qy_adder_int,
      POINT_OUT_RX => point_out_rx_adder_int,
      POINT_OUT_RY => point_out_ry_adder_int
    );

  ------------------------------------------------------------------------------
  -- Point-Generator
  ------------------------------------------------------------------------------

  ecdsa_point_generator_i : ecdsa_point_generator
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_point_generator,
      READY => ready_point_generator,

      -- DATA
      PRIVATE_KEY => key_point_generator_int,

      POINT_IN_X  => point_in_x_generator_int,
      POINT_IN_Y  => point_in_y_generator_int,
      POINT_OUT_X => point_out_x_generator_int,
      POINT_OUT_Y => point_out_y_generator_int
    );

end architecture;
