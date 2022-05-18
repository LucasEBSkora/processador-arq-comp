library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_rom is
end entity tb_rom;

architecture a_tb_rom of tb_rom is
  component rom
    port( clk    : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(14 downto 0)
    );
  end component;

  constant clk_period : time      := 100 ns;
  signal finished     : std_logic := '0';
  signal clk          : std_logic;
  signal endereco     : unsigned(6 downto 0) := "0000000";
  signal dado         : unsigned(14 downto 0);
begin
  uut: rom port map (clk => clk, endereco => endereco, dado => dado);

    total_sim_time: process
    begin
      wait for 10 us;
      finished <= '1';
      wait;
    end process total_sim_time;

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
  

    -- não precisa de nada mais complicado: vai iterando pela ROM vendo todos os endereços
    testbench: process
      begin
        while finished /= '1' loop
          wait for clk_period;
        endereco <= endereco + "0000001";
        end loop;
        wait;
    end process testbench;
  
  
end architecture a_tb_rom;