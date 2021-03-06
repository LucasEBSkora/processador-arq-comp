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
        0 => B"011_00_1_000000010",
        1 => B"011_01_0_000000000",
        2 => B"011_00_1_000000001",
        3 => B"011_01_0_000100000",
        4 => B"011_00_1_000000011",
        5 => B"011_01_0_000100001",
        6 => B"011_01_1_000100000",
        7 => B"111_00_0000100000",
        8 => B"101_0111_00101100",
        9 => B"011_01_1_000100000",
        10 => B"010_00_0000000001",
        11 => B"011_01_0_000100010",
        12 => B"011_01_1_000100010",
        13 => B"111_00_0000000000",
        14 => B"101_1010_00011000",
        15 => B"011_01_1_000100001",
        16 => B"011_01_0_000100011",
        17 => B"011_00_1_000000000",
        18 => B"001_01_0000100010",
        19 => B"011_10_0_000000000",
        20 => B"011_10_1_000000001",
        21 => B"011_01_0_000100100",
        22 => B"011_01_1_000100011",
        23 => B"111_00_0000000000",
        24 => B"101_1001_00000101",
        25 => B"011_01_1_000100011",
        26 => B"010_01_0000100100",
        27 => B"011_01_0_000100011",
        28 => B"110_000000010110",
        29 => B"011_01_1_000100011",
        30 => B"111_00_0000000000",
        31 => B"101_0100_00000011",
        32 => B"011_00_1_111111111",
        33 => B"011_01_0_000100010",
        34 => B"011_01_1_000100010",
        35 => B"010_00_0000000001",
        36 => B"011_01_0_000100010",
        37 => B"110_000000001100",
        38 => B"011_01_1_000100010",
        39 => B"111_00_1111111111",
        40 => B"101_0100_00001000",
        41 => B"011_01_1_000100000",
        42 => B"011_11_0_000000000",
        43 => B"011_01_1_000100001",
        44 => B"011_11_0_000000001",
        45 => B"011_01_1_000100000",
        46 => B"001_00_0000000001",
        47 => B"011_01_0_000100000",
        48 => B"011_01_1_000100001",
        49 => B"001_00_0000000001",
        50 => B"011_01_0_000100001",
        51 => B"110_000000000110",
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