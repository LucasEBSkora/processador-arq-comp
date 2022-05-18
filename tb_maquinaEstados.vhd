library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_maquinaEstados is
end entity tb_maquinaEstados;

architecture a_tb_maquinaEstados of tb_maquinaEstados is
    component maquinaEstados
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        estado : out unsigned(1 downto 0)
    );
end component;

constant clk_period : time      := 100 ns;
signal finished     : std_logic := '0';
signal clk          : std_logic;
signal reset        : std_logic;
signal estado       : unsigned(1 downto 0);

begin
    uut: maquinaEstados port map(clk => clk, reset => reset, estado => estado);

    total_sim_time: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process total_sim_time;
    
    reset_global: process
    begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait;
    end process;

    clk_process: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process clk_process;

    -- não precisa realmente de um processo para o teste: a máquina não tem nenhuma outra entrada, 
    -- e deve ficar iterando entre seus estados sempre


end architecture a_tb_MaquinaEstados;
