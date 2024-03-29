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

package peripheral_dsa_sha256_pkg is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  -- SHA-256 uses 32-bit words
  constant WORD_SIZE : integer := 32;

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- array types for SHA-256
  type K_DATA is array (0 to 63) of std_logic_vector(WORD_SIZE-1 downto 0);
  type M_DATA is array (0 to 15) of std_logic_vector(WORD_SIZE-1 downto 0);
  type H_DATA is array (0 to 7) of std_logic_vector(WORD_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  -- function definitions
  function ROTR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector;
  function ROTL (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector;
  function SHR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector;
  function CH (x : std_logic_vector(WORD_SIZE-1 downto 0);
               y : std_logic_vector(WORD_SIZE-1 downto 0);
               z : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;
  function MAJ (x : std_logic_vector(WORD_SIZE-1 downto 0);
                y : std_logic_vector(WORD_SIZE-1 downto 0);
                z : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;

  function SIGMA_UCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;
  function SIGMA_UCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;
  function SIGMA_LCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;
  function SIGMA_LCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector;

end package;

package body peripheral_dsa_sha256_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function ROTR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector is
  -- result : std_logic_vector(WORD_SIZE-1 downto 0);
  begin
    -- signal result : std_logic_vector(WORD_SIZE-1 downto 0);
    return (std_logic_vector(shift_right(unsigned(a), n))) or std_logic_vector((shift_left(unsigned(a), (WORD_SIZE-n))));
  end function;

  function ROTL (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector is
  -- result : std_logic_vector(WORD_SIZE-1 downto 0);
  begin
    -- signal result : std_logic_vector(WORD_SIZE-1 downto 0);
    return (std_logic_vector(shift_left(unsigned(a), n))) or std_logic_vector((shift_right(unsigned(a), (WORD_SIZE-n))));
  end function;

  function SHR (a : std_logic_vector(WORD_SIZE-1 downto 0); n : integer)
    return std_logic_vector is
  begin
    return std_logic_vector(shift_right(unsigned(a), n));
  end function;

  function CH (x : std_logic_vector(WORD_SIZE-1 downto 0);
               y : std_logic_vector(WORD_SIZE-1 downto 0);
               z : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return (x and y) xor (not(x) and z);
  end function;

  function MAJ (x : std_logic_vector(WORD_SIZE-1 downto 0);
                y : std_logic_vector(WORD_SIZE-1 downto 0);
                z : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return (x and y) xor (x and z) xor (y and z);
  end function;

  function SIGMA_UCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return ROTR(x, 2) xor ROTR(x, 13) xor ROTR(x, 22);
  end function;

  function SIGMA_UCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return ROTR(x, 6) xor ROTR(x, 11) xor ROTR(x, 25);
  end function;

  function SIGMA_LCASE_0 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return ROTR(x, 7) xor ROTR(x, 18) xor SHR(x, 3);
  end function;

  function SIGMA_LCASE_1 (x : std_logic_vector(WORD_SIZE-1 downto 0))
    return std_logic_vector is
  begin
    return ROTR(x, 17) xor ROTR(x, 19) xor SHR(x, 10);
  end function;

end package body;