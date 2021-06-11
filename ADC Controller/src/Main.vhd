library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity Main is
port(
  readyLine     : in std_logic;
  dataLine      : in std_logic;
  i_clk         : in std_logic;
  clkLine       : out std_logic);
end Main;

architecture rtl of Main is
  signal ADCResult      : std_logic_vector(40 downto 0) := (others => '0');
  signal clkLineSig     : std_logic := '0';
  signal readSig        : std_logic := '0';
begin
  generateClock : process(i_clk)
    variable clk_divider : unsigned(3 downto 0) := (others => '0');
  begin
    if(rising_edge(i_clk)) then
      clk_divider := clk_divider + 1;
    end if;
    if(clk_divider >= 4) then
      clkLineSig <= NOT clkLineSig;
      clk_divider := (others => '0');
    end if;
  end process generateClock;

  enableClock : process(readyLine, clkLineSig)
    variable pulseCounter : unsigned(5 downto 0) := (others => '0');
  begin
    if(falling_edge(clkLineSig) AND readSig = '1') then
      ADCResult(to_integer(pulseCounter)) <= dataLine;
      pulseCounter := pulseCounter + 1;
    end if;
    if(falling_edge(readyLine)) then
      readSig <= '1';
    end if;
    if(pulseCounter = 40) then
      readSig <= '0';
      pulseCounter := (others => '0');
    end if;
  end process enableClock;

  clkLine <= clkLineSig AND readSig;
end rtl;