library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk      : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado     : out unsigned(14 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(14 downto 0);
    constant conteudo_rom : mem := (
         0 => B"0011_00_100_000000",
         1 => B"0011_00_101_000000",
         2 => B"0011_01_001_000_100",
         3 => B"0001_01_000000_101",
         4 => B"0011_01_101_000_001",
         5 => B"0011_01_001_000_100",
         6 => B"0001_00_000000001",
         7 => B"0011_01_100_000_001",
         8 => B"0011_01_001_000_100",
         9 => B"0010_00_000011110",
        10  => B"1110_1010_1111000",
        11 => B"0011_01_110_000_101",
        others => (others=>'0')
    );
    
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
        dado <= conteudo_rom(to_integer(endereco));
    end if;
end process;
end architecture;