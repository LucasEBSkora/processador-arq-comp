library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_reg16bits is
end entity tb_reg16bits;

architecture a_tb_reg16bits of tb_reg16bits is
  component reg16bits
    port(clk : in std_logic;
      rst : in std_logic;
      wr_en : in std_logic;
      data_in : in unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;

  constant clk_period      : time      := 100 ns;
  signal finished          : std_logic := '0';
  signal clk, rst, wr_en   : std_logic;
  signal data_in, data_out : unsigned(15 downto 0);

  begin
    uut: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en, data_in => data_in, data_out => data_out);
    
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
      data_in <= "1111111111111111";
      wr_en <= '1';
      wait for clk_period;      
      data_in <= "0000000011111111";
      wr_en <= '0';
      wait for clk_period*2;
      data_in <= "0101010101010101";
      wr_en <= '1';
      wait for clk_period/4;
      data_in <= "1010101010101010";
      wr_en <= '1';
      wait;
    end process;

end architecture a_tb_reg16bits;