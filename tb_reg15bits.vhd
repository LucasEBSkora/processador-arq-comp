library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_reg15bits is
end entity tb_reg15bits;

architecture a_tb_reg15bits of tb_reg15bits is
  component reg15bits
    port(
      clk      : in  std_logic;
      rst      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(14 downto 0);
      data_out : out unsigned(14 downto 0)
    );
  end component;

  constant clk_period      : time      := 100 ns;
  signal finished          : std_logic := '0';
  signal clk, rst, wr_en   : std_logic;
  signal data_in, data_out : unsigned(14 downto 0);

  begin
    uut: reg15bits port map(clk => clk, rst => rst, wr_en => wr_en, data_in => data_in, data_out => data_out);
    
    total_sim_time: process
    begin
      wait for 10 us;
      finished <= '1';
      wait;
    end process total_sim_time;
    
    reset_global: process
    begin
      rst <= '0';
      wait for clk_period*2;
      rst <= '1';
      wait for clk_period;
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

    testbench: process
    begin
      -- Escreve valor qualquer
      data_in <= "111111111111111";
      wr_en <= '1';
      wait for clk_period;     
      
      -- Não escreve, pois o enable está em 0
      data_in <= "000000011111111";
      wr_en <= '0';

      -- Registrador resetado: fixo em zero
      wait for clk_period*2;
      data_in <= "101010101010101";
      wr_en <= '1';

      -- Como não pega uma borda de clock, o valor não é escrito
      wait for clk_period/4;
      data_in <= "010101010101010";
      wr_en <= '1';
      wait;
    end process;

end architecture a_tb_reg15bits;