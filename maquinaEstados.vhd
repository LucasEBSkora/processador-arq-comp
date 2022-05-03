library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maquinaEstados is
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        estado : out std_logic
    );
end entity maquinaEstados;

architecture a_maquinaEstados of maquinaEstados is
    signal estado_interno : std_logic;
begin
    process(clk,reset)
    begin
        if reset = '1' then
            estado_interno <= '0';
        elsif rising_edge(clk) then
            estado_interno <= not estado_interno;
        end if;
    end process;
    
    estado <= estado_interno;
end architecture;