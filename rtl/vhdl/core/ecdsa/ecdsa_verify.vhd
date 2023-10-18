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

entity ecdsa_verify is
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

    MESSAGE : in std_logic_vector(0 to 16*WORD_SIZE-1);

    SIGNATURE_R : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNATURE_S : in std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ecdsa_verify_architecture of ecdsa_verify is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type verify_ctrl_fsm_type is (
    STARTER_ST,             -- STEP 0; START = '1';                  start_inverter = '1';
    INVERTER_ST,            -- STEP 1; ready_inverter = '1';         start_multiplier = '1';
    MULTIPLIER_U2_ST,       -- STEP 2; ready_multiplier = '1';       start_point_generator = '1';
    POINT_GENERATOR_U2_ST,  -- STEP 3; ready_point_generator = '1';  start_multiplier = '1';
    MESSAGE_ST,             -- STEP 4;                               start_multiplier = '1';
    MULTIPLIER_U1_ST,       -- STEP 5; ready_multiplier = '1';       start_point_generator = '1';
    POINT_GENERATOR_U1_ST,  -- STEP 6; ready_point_generator = '1';  start_point_adder = '1';
    POINT_ADDER_ST,         -- STEP 7; ready_point_adder = '1';
    ENDER_ST                -- STEP 8;
  );

  type sha_ctrl_fsm_type is (
    STARTER_ST,  -- STEP 0; START = '1';                  start_sha512 = '1';
    ENDER_ST     -- STEP 1; ready_sha512 = '1';
  );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal verify_ctrl_fsm_st : verify_ctrl_fsm_type;
  signal sha_ctrl_fsm_st    : sha_ctrl_fsm_type;

  -- Internal Signals
  signal w_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal point_x_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_y_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal e_enable_int : std_logic;
  signal e_int        : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SHA-512
  -- Control Signals
  signal start_sha512 : std_logic;
  signal ready_sha512 : std_logic;

  signal data_in_enable_sha512_int  : std_logic;
  signal data_out_enable_sha512_int : std_logic;

  -- Data Signals
  signal data_in_sha512_int  : std_logic_vector(0 to 16*WORD_SIZE-1);
  signal data_out_sha512_int : std_logic_vector(WORD_SIZE*8-1 downto 0);

  -- MODULO
  -- Control Signals
  signal start_mod : std_logic;
  signal ready_mod : std_logic;

  -- Data Signals
  signal data_in_mod_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_mod_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INVERTER
  -- Control Signals
  signal start_inverter : std_logic;
  signal ready_inverter : std_logic;

  -- Data Signals
  signal data_in_inverter_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_inverter_int : std_logic_vector(DATA_SIZE-1 downto 0);

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
      sha_ctrl_fsm_st <= STARTER_ST;

      -- Control Outputs
      DATA_OUT_ENABLE <= '0';

      -- Internal Signals
      e_enable_int <= '0';
      e_int        <= ZERO;

      -- SHA-512
      -- Control Signals
      start_sha512 <= '0';

      data_in_enable_sha512_int <= '0';

      -- Data Signals
      data_in_sha512_int <= (others => '0');

    elsif (rising_edge(CLK)) then

      case sha_ctrl_fsm_st is
        when STARTER_ST =>              -- STEP 0

          if (START = '1') then
            -- Assignation for next state
            start_sha512 <= '1';

            -- Assignation
            e_enable_int <= '0';

            -- FSM Control
            sha_ctrl_fsm_st <= ENDER_ST;
          end if;

        when ENDER_ST =>                -- STEP 1

          if (ready_sha512 = '1') then
            -- Assignation
            e_int        <= data_out_sha512_int;
            e_enable_int <= '1';

            -- FSM Control
            sha_ctrl_fsm_st <= STARTER_ST;
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

        when others =>
          -- FSM Control
          sha_ctrl_fsm_st <= STARTER_ST;
      end case;
    end if;
  end process;

  -- 1. FAIL := '1' when NOT r,s in [1, N-1]
  -- 2. e = SHA-512(m)                 (ecdsa_sha512)
  -- 3. w = 1/s mod n                  (ecdsa_inverter)
  -- 4. u1 = e*w mod n; u2 = r*w mod n (ecdsa_multiplier)
  -- 5. X = u1*P + u2*Q                (ecdsa_point_adder, ecdsa_point_generator)
  -- 6. FAIL := '1' when X = Infinite
  -- 7. v = x1 mod n
  -- 8. FAIL := '1' when v != r else '0'

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Finite State Machine
      verify_ctrl_fsm_st <= STARTER_ST;

      -- Control Outputs
      FAIL  <= '0';
      READY <= '0';

      -- Internal Signals
      w_int   <= ZERO;

      point_x_int <= ZERO;
      point_y_int <= ZERO;

      -- MODULO
      -- Control Signals
      start_mod <= '0';

      -- Data Signals
      data_in_mod_int <= ZERO;

      -- INVERTER
      -- Control Signals
      start_inverter <= '0';

      -- Data Signals
      data_in_inverter_int <= ZERO;

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

      case verify_ctrl_fsm_st is
        when STARTER_ST =>              -- STEP 0

          if (START = '1') then
            if (unsigned(SIGNATURE_R) >= unsigned(ONE) and unsigned(SIGNATURE_S) >= unsigned(ONE) and unsigned(SIGNATURE_R) < unsigned(BLACKPOOL512_N) and unsigned(SIGNATURE_S) < unsigned(BLACKPOOL512_N)) then
              -- Assignation
              start_inverter       <= '1';
              data_in_inverter_int <= SIGNATURE_S;

              -- FSM Control
              verify_ctrl_fsm_st <= INVERTER_ST;
            else
              -- Control Outputs
              FAIL  <= '1';
              READY <= '1';
            end if;
          else
            -- Control Outputs
            READY <= '0';
          end if;

        when INVERTER_ST =>             -- STEP 1

          if (ready_inverter = '1') then
            -- Assignation for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= SIGNATURE_R;
            data_in_b_multiplier_int <= data_out_inverter_int;

            -- Assignation
            w_int <= data_out_inverter_int;

            -- FSM Control
            verify_ctrl_fsm_st <= MULTIPLIER_U2_ST;
          else
            -- Assignation for next state
            start_inverter <= '0';
          end if;

        when MULTIPLIER_U2_ST =>        -- STEP 2

          if (ready_multiplier = '1') then
            -- Assignation for next state
            start_point_generator <= '1';

            key_point_generator_int <= data_out_multiplier_int;

            point_in_x_generator_int <= PUBLIC_KEY_X;
            point_in_y_generator_int <= PUBLIC_KEY_Y;

            -- FSM Control
            verify_ctrl_fsm_st <= POINT_GENERATOR_U2_ST;
          else
            -- Assignation for next state
            start_multiplier <= '0';
          end if;

        when POINT_GENERATOR_U2_ST =>   -- STEP 3

          if (ready_point_generator = '1') then

            -- Assignation
            point_x_int <= point_out_x_generator_int;
            point_y_int <= point_out_y_generator_int;

            -- FSM Control
            verify_ctrl_fsm_st <= MESSAGE_ST;
          else
            -- Assignation for next state
            start_point_generator <= '0';
          end if;

        when MESSAGE_ST =>              -- STEP 4

          if (e_enable_int = '1') then
            -- Assignation for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= e_int;
            data_in_b_multiplier_int <= w_int;

            -- FSM Control
            verify_ctrl_fsm_st <= MULTIPLIER_U1_ST;
          end if;

        when MULTIPLIER_U1_ST =>        -- STEP 5

          if (ready_multiplier = '1') then
            -- Assignation for next state
            start_point_generator <= '1';

            key_point_generator_int <= data_out_multiplier_int;

            point_in_x_generator_int <= BLACKPOOL512_X;
            point_in_y_generator_int <= BLACKPOOL512_Y;

            -- FSM Control
            verify_ctrl_fsm_st <= POINT_GENERATOR_U1_ST;
          else
            -- Assignation for next state
            start_multiplier <= '0';
          end if;

        when POINT_GENERATOR_U1_ST =>   -- STEP 6

          if (ready_point_generator = '1') then
            -- Assignation for next state
            start_point_adder <= '1';

            point_in_px_adder_int <= point_out_x_generator_int;
            point_in_py_adder_int <= point_out_y_generator_int;
            point_in_qx_adder_int <= point_x_int;
            point_in_qy_adder_int <= point_y_int;

            -- FSM Control
            verify_ctrl_fsm_st <= POINT_ADDER_ST;
          else
            -- Assignation for next state
            start_point_generator <= '0';
          end if;

        when POINT_ADDER_ST =>          -- STEP 7

          if (ready_point_adder = '1') then
            -- Assignation for next state
            start_mod       <= '1';
            data_in_mod_int <= point_out_rx_adder_int;

            -- FSM Control
            verify_ctrl_fsm_st <= ENDER_ST;
          else
            -- Assignation for next state
            start_point_adder <= '0';
          end if;

        when ENDER_ST =>                -- STEP 8

          if (ready_mod = '1') then
            -- Control Outputs
            if (unsigned(data_out_mod_int) = unsigned(SIGNATURE_R)) then
              FAIL <= '0';
            else
              FAIL <= '1';
            end if;

            READY <= '1';

            -- FSM Control
            verify_ctrl_fsm_st <= STARTER_ST;
          else
            -- Assignation for next state
            start_mod <= '0';
          end if;

        when others =>
          -- FSM Control
          verify_ctrl_fsm_st <= STARTER_ST;
      end case;
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
      DATA_BLOCK_SIZE => DATA_BLOCK_SIZE,

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
  -- Inverter
  ------------------------------------------------------------------------------

  ecdsa_inverter_i : ecdsa_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_inverter,
      READY => ready_inverter,

      -- DATA
      MODULO   => BLACKPOOL512_N,
      DATA_IN  => data_in_inverter_int,
      DATA_OUT => data_out_inverter_int
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
