library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_processador is
end entity tb_processador;

architecture a_tb_processador of tb_processador is

  component processador is
    port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      estado    : out unsigned(1 downto 0);
      PC        : out unsigned(14 downto 0);
      instrucao : out unsigned(14 downto 0);
      regA      : out unsigned(14 downto 0);
      regB      : out unsigned(14 downto 0);
      saida     : out unsigned(14 downto 0)
    );
  end component processador;
  

  constant clk_period : time      := 100 ns;
  signal finished     : std_logic := '0';
  signal clk, rst     : std_logic;
  signal estado       : unsigned(1 downto 0);
  signal PC           : unsigned(14 downto 0);
  signal instrucao : unsigned(14 downto 0);
  signal regA         : unsigned(14 downto 0);
  signal regB         : unsigned(14 downto 0);
  signal saida        : unsigned(14 downto 0);

  begin
    uut: processador port map(clk => clk, rst => rst, estado => estado, PC => PC, instrucao => instrucao, regA => regA, regB => regB, saida => saida);
    
    total_sim_time:
    process
    begin
      wait for 1 ms;
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

    clk_processadoress: process
    begin
      while finished /= '1' loop
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
      end loop;
      wait;
    end process clk_processadoress;

    -- testbench deixa o processador executar o programa: não precisa de um processo para gerenciar entradas

end architecture a_tb_processador;