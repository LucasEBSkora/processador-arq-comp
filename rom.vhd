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
        0  => B"0011_00_100_000101",
        1  => B"0011_00_101_001000",
        2  => B"0011_00_001_000000",
        3  => B"0001_01_000000_100",
        4  => B"0001_01_000000_101",
        5  => B"0011_01_110_000001",
        6  => B"0011_01_001_000110",
        7  => B"0010_00_000000001",
        8  => B"0011_01_110_000001",
        9  => B"1111_00000010100",
        10 => B"0000_00000000000",
        11 => B"0000_00000000000",
        12 => B"0000_00000000000",
        13 => B"0000_00000000000",
        14 => B"0000_00000000000",
        15 => B"0000_00000000000",
        16 => B"0000_00000000000",
        17 => B"0000_00000000000",
        18 => B"0000_00000000000",
        19 => B"0000_00000000000",
        20 => B"0011_01_100_000_110",
        21 => B"1111_00000000011",
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