library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_UC is
end entity tb_UC;

architecture a_tb_UC of tb_UC is
  component UC
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      jump_en       : in  std_logic; 
      instrucao_in  : in  unsigned(14 downto 0);
      endereco_jump : in  unsigned(14 downto 0);
      instrucao_out : out unsigned(14 downto 0);
      estado        : out unsigned(1 downto 0);
      fetch         : out std_logic;
      decode        : out std_logic;
      execute       : out std_logic;
      PC            : out unsigned(14 downto 0)
    );
  end component UC;
  
  constant clk_period             : time      := 100 ns;
  signal   finished               : std_logic := '0';
  signal   clk, rst, jump_en      : std_logic;
  signal   instrucao_in           : unsigned(14 downto 0);
  signal   endereco_jump          : unsigned(14 downto 0);
  signal   instrucao_out          : unsigned(14 downto 0);
  signal   estado                 : unsigned(1 downto 0);
  signal   fetch, decode, execute : std_logic;
  signal   PC                     : unsigned(14 downto 0);

begin
  uut: UC port map(clk => clk, reset => rst, jump_en => jump_en, instrucao_in => instrucao_in, endereco_jump => endereco_jump,
     instrucao_out => instrucao_out, estado => estado, fetch => fetch, decode => decode, execute => execute, PC => PC);

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
    -- deixa o PC simplesmente contar
    instrucao_in <= "000000000000000";
    jump_en <= '0';
    endereco_jump <= "000000000000000"; 

    wait for clk_period*20;

    -- manda uma instrucao diferente
    instrucao_in <= "111101100100001";
    
    wait for clk_period*3;

    -- faz um pulo

    jump_en <= '1';
    endereco_jump <= "001001000110100"; 

    instrucao_in <= "000000000000000";

    wait;
  end process testbench;

end architecture a_tb_UC;