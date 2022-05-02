library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maquinaEstados is
    port(
        clk : in std_logic;
        reset: in std_logic;
        estado_out : out std_logic
    );
end entity maquinaEstados;

architecture a_maquinaEstados of maquinaEstados is
    signal estado: std_logic;
begin
    process(clk,reset)
    begin
        if reset = '1' then
            estado <= '0';
        elsif rising_edge(clk) then
            estado <= not estado;
        end if;
        estado_out <= estado;
    end process;

end architecture;