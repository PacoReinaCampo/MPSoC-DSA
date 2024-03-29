# Módulo VII. Modelado con Property Specification Language

Se presentan los diseños de curva criptográfica ECDSA y KCDSA descritos en un Lenguaje de Descripción de Hardware. Las curvas criptográficas precisan de operaciones en Aritmética Modular y de Generación del Punto de la curva.

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Ejemplo: Bus AMBA4 AXI Lite FIFO

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Diseño en VHDL

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_fifo is
  generic (
    ram_width : natural;
    ram_depth : natural
  );
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- AXI input interface
    in_ready : out std_logic;
    in_valid : in std_logic;
    in_data : in std_logic_vector(ram_width-1 downto 0);

    -- AXI output interface
    out_ready : in std_logic;
    out_valid : out std_logic;
    out_data : out std_logic_vector(ram_width-1 downto 0)
  );
end axi_fifo;

architecture rtl of axi_fifo is

  -- The FIFO is full when the RAM contains ram_depth-1 elements
  type ram_type is array (0 to ram_depth-1) of std_logic_vector(in_data'range);
  signal ram : ram_type;

  -- Newest element at head, oldest element at tail
  subtype index_type is natural range ram_type'range;
  signal head : index_type;
  signal tail : index_type;
  signal count : index_type;
  signal count_p1 : index_type;

  -- Internal versions of entity signals with mode "out"
  signal in_ready_i : std_logic;
  signal out_valid_i : std_logic;

  -- True the clock cycle after a simultaneous read and write
  signal read_while_write_p1 : std_logic;

  -- Increment or wrap the index if this transaction is valid
  function next_index(
    index : index_type;
    ready : std_logic;
    valid : std_logic) return index_type is
  begin
    if ready = '1' and valid = '1' then
      if index = index_type'high then
        return index_type'low;
      else
        return index + 1;
      end if;
    end if;

    return index;
  end function;

  -- Logic for handling the head and tail signals
  procedure index_proc(
    signal clk : in std_logic;
    signal rst : in std_logic;
    signal index : inout index_type;
    signal ready : in std_logic;
    signal valid : in std_logic) is
  begin
      if rising_edge(clk) then
        if rst = '1' then
          index <= index_type'low;
        else
          index <= next_index(index, ready, valid);
        end if;
      end if;
  end procedure;

begin

  -- Copy internal signals to output
  in_ready <= in_ready_i;
  out_valid <= out_valid_i;

  -- Update head index on write
  PROC_HEAD : index_proc(clk, rst, head, in_ready_i, in_valid);

  -- Update tail index on read
  PROC_TAIL : index_proc(clk, rst, tail, out_ready, out_valid_i);

  -- Write to and read from the RAM
  PROC_RAM : process(clk)
  begin
    if rising_edge(clk) then
      ram(head) <= in_data;
      out_data <= ram(next_index(tail, out_ready, out_valid_i));
    end if;
  end process;

  -- Find the number of elements in the RAM
  PROC_COUNT : process(head, tail)
  begin
    if head < tail then
      count <= head - tail + ram_depth;
    else
      count <= head - tail;
    end if;
  end process;

  -- Delay the count by one clock cycles
  PROC_COUNT_P1 : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        count_p1 <= 0;
      else
        count_p1 <= count;
      end if;
    end if;
  end process;

  -- Set in_ready when the RAM isn't full
  PROC_IN_READY : process(count)
  begin
    if count < ram_depth-1 then
      in_ready_i <= '1';
    else
      in_ready_i <= '0';
    end if;
  end process;

  -- Detect simultaneous read and write operations
  PROC_READ_WHILE_WRITE_P1: process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        read_while_write_p1 <= '0';

      else
        read_while_write_p1 <= '0';
        if in_ready_i = '1' and in_valid = '1' and
          out_ready = '1' and out_valid_i = '1' then
          read_while_write_p1 <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Set out_valid when the RAM outputs valid data
  PROC_OUT_VALID : process(count, count_p1, read_while_write_p1)
  begin
    out_valid_i <= '1';

    -- If the RAM is empty or was empty in the prev cycle
    if count = 0 or count_p1 = 0 then
      out_valid_i <= '0';
    end if;

    -- If simultaneous read and write when almost empty
    if count = 1 and read_while_write_p1 = '1' then
      out_valid_i <= '0';
    end if;

  end process;

end architecture;
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Modelado en PSL

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
  -- set all declarations to run on clk
  default clock is rising_edge(clk);

  ----------------------------------------------------
  -- RESET HANDLING
  ----------------------------------------------------

  -- Assume reset (one clock cycle) at startup.
  f_reset : assume {rst};

  -- FIFO must be empty after any reset.
  f_after_reset_valid : assert always {rst} |=> {not out_valid};
  f_after_reset_ready : assert always {rst} |=> {in_ready};
  f_after_reset_head  : assert always {rst} |=> {count = 0};

  ----------------------------------------------------
  -- FIFO full and empty signalling
  ----------------------------------------------------

  -- Check FIFO empty
  f_empty : assert always {count = 0} |-> {not out_valid};

  -- Check FIFO full
  f_full : assert always {count = ram_depth-1} |-> {not in_ready};

  ----------------------------------------------------
  -- AXI PROTOCOL
  ----------------------------------------------------

  -- Input valid/data must be stable until accepted.
  f_in_data_stable : assume always
    {in_valid and not in_ready and not rst} |=>
    {stable(in_valid) and stable(in_data)};

  -- Output ready must be stable until new data.
  f_out_ready_stable : assume always
    {out_ready and not out_valid and not rst} |=>
    {stable(out_ready)};

  -- Output valid/data must be stable until accepted.
  f_out_data_stable : assert always
    {out_valid and not out_ready and not rst} |=>
    {stable(out_valid) and stable(out_data)};

  -- Input ready must be stable until new data.
  f_in_ready_stable : assert always
    {in_ready and not in_valid and not rst} |=>
    {stable(in_ready)};

  ----------------------------------------------------
  -- FIFO ORDERING
  ----------------------------------------------------

  -- Control signals to determine if the values have entered and/or left the FIFO
  signal f_sampled_in_d1  : std_logic := '0';
  signal f_sampled_in_d2  : std_logic := '0';
  signal f_sampled_out_d1 : std_logic := '0';
  signal f_sampled_out_d2 : std_logic := '0';

  -- Make sure d2 enters after d1.
  f_fifo_ordering_in : assume always {f_sampled_in_d2} |-> {f_sampled_in_d1};

  -- Verify the FIFO preserves ordering, i.e. d2 leaves after d1.
  f_fifo_ordering_out : assert always {f_sampled_out_d2} |-> {f_sampled_out_d1};


  -- Two random values to be pushed into the FIFO
  signal f_value_d1 : std_logic_vector(ram_width-1 downto 0);
  signal f_value_d2 : std_logic_vector(ram_width-1 downto 0);
  attribute anyconst : boolean;
  attribute anyconst of f_value_d1 : signal is true;
  attribute anyconst of f_value_d2 : signal is true;

  p_sampled : process (clk)
  begin
    if rising_edge(clk) then
      if in_valid then
        if in_data = f_value_d1 then
          f_sampled_in_d1 <= '1';
        end if;
        if in_data = f_value_d2 then
          f_sampled_in_d2 <= '1';
        end if;
      end if;

      if out_valid then
        if out_data = f_value_d1 then
          f_sampled_out_d1 <= '1';
        end if;
        if out_data = f_value_d2 then
          f_sampled_out_d2 <= '1';
        end if;
      end if;

      if rst = '1' then
        f_sampled_in_d1  <= '0';
        f_sampled_in_d2  <= '0';
        f_sampled_out_d1 <= '0';
        f_sampled_out_d2 <= '0';
      end if;
    end if;
  end process p_sampled;

  ----------------------------------------------------
  -- COVER STATEMENTS TO VERIFY REACHABILITY
  ----------------------------------------------------

  -- Make sure FIFO can transition from full to empty.
  f_full_to_empty : cover {
    rst = '1';
    rst = '0'[*];
    rst = '0' and count = ram_depth-1;
    rst = '0'[*];
    rst = '0' and count = 0};


} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Función Hash

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### SHA 256

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### SHA 512

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Aritmética Modular

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Sumador Modular

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Restador Modular

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Multiplicador Modular

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Inversor Modular

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Generación

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Sumador de Punto

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Doblador de Punto

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Generador

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Curva Elíptica Criptográfica ECDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Firma Criptográfica ECDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Verificación Criptográfica ECDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

## Curva Elíptica Criptográfica KCDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Firma Criptográfica KCDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

### Verificación Criptográfica KCDSA

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....

```psl
vunit i_axi_fifo(axi_fifo(rtl))
{
} -- vunit i_axi_fifo(axi_fifo(rtl))
```

.. ....... ........ ........ ....... .. ........... ...... .... .. ...... ..... .. ..... .... ........ ... ...... . ... .... .. ......... ........... .... .... ........ .. .... . ..... ....... .... ... ........ .... ............ .. ... ... ....... .. ...... .... ... .... ....... .. ..... ... .... ....... ... ....... ......... ..... .......... ....... ..... ....... ... ....... ... ....... ..... ..... .... . ........ .. ... ..... ......... .. ........ ..... ....... .......... .......... ... ........ .. ... ..... .. ........ ..... .......... .... ... ...... .. .....
