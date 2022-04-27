library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_proc is
end entity tb_proc;

architecture a_tb_proc of tb_proc is

  component proc is
    port (
      clk                               : in std_logic;
      rst                               : in std_logic;
      wr_en                             : in std_logic;
      sel_entr1_ULA                     : in std_logic;
      selRegWrite                       : in unsigned(2 downto 0);
      selRegA                           : in unsigned(2 downto 0);
      selRegB                           : in unsigned(2 downto 0);
      sel_op                            : in unsigned(2 downto 0);
      entradaExterna                    : in unsigned(15 downto 0);
      saida                             : out unsigned(15 downto 0);
      op_zero, entr0_maior, entr0_menor : out std_logic
    );
  end component proc;
  

  constant clk_period                          : time      := 100 ns;
  signal finished                              : std_logic := '0';
  signal clk, rst, wr_en, sel_entr1_ULA        : std_logic;
  signal selRegWrite, selRegA, selRegB, sel_op : unsigned(2 downto 0);
  signal entradaExterna, saida                 : unsigned(15 downto 0);

  begin
    uut: proc port map(clk => clk, rst => rst, wr_en => wr_en,
                       sel_entr1_ULA => sel_entr1_ULA, selRegWrite => selRegWrite, selRegA => selRegA, selRegB => selRegB, sel_op => sel_op,
                       entradaExterna => entradaExterna, saida => saida
                      );
    
    total_sim_time:
    process
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

      -- escreve em todos os registradores
      wr_en <= '1';
      sel_entr1_ULA <= '1';
      selRegA <= "000";
      selRegB <= "000";
      sel_op <= "000";
      
      selRegWrite <= "001";
      entradaExterna <= "0000000000000001";
      wait for clk_period*3;

      selRegWrite <= "010";
      entradaExterna <= "0000000000000010";
      wait for clk_period;

      selRegWrite <= "011";
      entradaExterna <= "0000000000000011";
      wait for clk_period;

      selRegWrite <= "100";
      entradaExterna <= "0000000000000100";
      wait for clk_period;

      selRegWrite <= "101";
      entradaExterna <= "0000000000000101";
      wait for clk_period;

      selRegWrite <= "110";
      entradaExterna <= "0000000000000110";
      wait for clk_period;

      selRegWrite <= "111";
      entradaExterna <= "0000000000000111";
      wait for clk_period;

      -- saída é r7 - r4 = 7 - 4 = 3, mas não escreve pq wr_en = '0'
      sel_entr1_ULA <= '0';
      wr_en <= '0';
      selRegWrite <= "011";
      selRegA <= "111";
      selRegB <= "100";
      sel_op <= "001";
      wait for clk_period;
      
      -- r5 = r7 ^ r3
      wr_en <= '1';
      selRegWrite <= "101";
      selRegA <= "111";
      selRegB <= "011";
      sel_op <= "100";
      wait for clk_period;

      wr_en <= '0';
      selRegA <= "101";
      selRegB <= "000";
      
      wait;
    end process;

end architecture a_tb_proc;