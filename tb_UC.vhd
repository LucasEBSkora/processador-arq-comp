library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_UC is
end entity tb_UC;

architecture a_tb_UC of tb_UC is
  component UC
    port (
      clk    : in std_logic;
      reset  : in std_logic;
      PC     : out unsigned(15 downto 0) 
    );
  end component UC;
  
  constant clk_period      : time      := 100 ns;
  signal finished          : std_logic := '0';
  signal clk, rst : std_logic;
  signal PC : unsigned(15 downto 0);

begin
  uut: UC port map(clk => clk, reset => rst, PC => PC);

  total_sim_time: process
  begin
    wait for 10 us;
    finished <= '1';
    wait;
  end process total_sim_time;
  
  reset_global: process
  begin
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
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


end architecture a_tb_UC;