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
        0  => B"011_00_1_000000101",
        1  => B"011_01_0_000000011",
        2  => B"011_00_1_000001000",
        3  => B"011_01_0_000000100",
        4  => B"011_01_1_000000011",
        5  => B"001_01_0000000100",
        6  => B"011_01_0_000000101",
        7  => B"011_01_1_000000101",
        8  => B"010_00_0000000001",
        9  => B"011_01_0_000000101",
        10 => B"110_000000010100",
        20 => B"011_01_1_000000101",
        21 => B"011_01_0_000000011",
        22 => B"110_000000000100",
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