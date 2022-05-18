library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maquinaEstados is
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        estado : out unsigned (1 downto 0)
    );
end entity maquinaEstados;

architecture a_maquinaEstados of maquinaEstados is
    signal estado_interno : unsigned(1 downto 0) := "00";
begin
    process(clk,reset)
    begin
        if reset = '1' then
            estado_interno <= "00";
        elsif rising_edge(clk) then
            if estado_interno >= "10" then
                estado_interno <= "00";
            else
                estado_interno <= estado_interno+1;
            end if;
        end if;
    end process;
    
    estado <= estado_interno;
end architecture;
