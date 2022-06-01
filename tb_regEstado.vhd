library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_regEstado is
end entity tb_regEstado;

architecture a_tb_regEstado of tb_regEstado is
  component regEstado is
    port(
      clk                    : in  std_logic;
      rst                    : in  std_logic;
      e_V, e_N, e_Z, e_C     : in  std_logic;
      i_V, i_N, i_Z, i_C	   : in  std_logic;
      o_V, o_N, o_Z, o_C	   : out std_logic
    );
  end component;

  constant clk_period       : time      := 100 ns;
  signal finished           : std_logic := '0';
  signal clk, rst           : std_logic;
  signal e_V, e_N, e_Z, e_C : std_logic;
  signal i_V, i_N, i_Z, i_C : std_logic;
  signal o_V, o_N, o_Z, o_C : std_logic;

  begin
    uut: regEstado port map(clk => clk, rst => rst,
                            e_V => e_V, e_N => e_N, e_Z => e_Z, e_C => e_C,
                            i_V => i_V, i_N => i_N, i_Z => i_Z, i_C => i_C,
                            o_V => o_V, o_N => o_N, o_Z => o_Z, o_C => o_C);
    
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



    testbench: process
    begin
      
      -- testando escrever um por vez:
      
      i_V <= '1';
      i_N <= '1';
      i_Z <= '1';
      i_C <= '1';
      
      e_V <= '0';
      e_N <= '0';
      e_Z <= '0';
      e_C <= '0';

      wait for clk_period*3;
      
      e_V <= '1';
      wait for clk_period;
      
      e_N <= '1';
      wait for clk_period;
      
      e_Z <= '1';
      wait for clk_period;
      
      e_C <= '1';
      wait for clk_period;

      -- escreve em todos de uma vez
      
      i_V <= '1';
      i_N <= '0';
      i_Z <= '1';
      i_C <= '0';
      wait for clk_period;

      i_V <= '0';
      i_N <= '1';
      i_Z <= '0';
      i_C <= '1';
      wait for clk_period;

      -- escreve em apenas 2
      
      e_V <= '0';
      e_N <= '1';
      e_Z <= '1';
      e_C <= '0';

      i_V <= '1';
      i_N <= '0';
      i_Z <= '1';
      i_C <= '0';
      
      wait for clk_period;

      wait;
    end process;

end architecture a_tb_regEstado;