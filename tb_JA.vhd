library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Esse teste basicamente só vê se as instruções JA funcionam direito.
entity tb_JA is
end entity tb_JA;

architecture tb_JA of tb_JA is
  component rom
    port( clk    : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado     : out unsigned(14 downto 0)
    );
  end component rom;

  component UC
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      instrucao_in  : in  unsigned(14 downto 0);
      instrucao_out : out unsigned(14 downto 0);
      estado        : out unsigned(1 downto 0);
      fetch         : out std_logic;
      decode        : out std_logic;
      execute       : out std_logic;
      PC            : out unsigned(14 downto 0)
    );
  end component UC;
  
  constant clk_period                : time      := 100 ns;
  signal finished                    : std_logic := '0';
  signal clk, reset                  : std_logic;
  signal instrucao_in, instrucao_out : unsigned(14 downto 0);
  signal estado                      : unsigned(1 downto 0);
  signal fetch, decode, execute      : std_logic;
  signal PC                          : unsigned(14 downto 0);
  signal endereco                    : unsigned(6 downto 0);

begin
    uut_rom : rom port map(clk => clk, endereco => endereco, dado => instrucao_in);
    uut_uc : UC port map(clk => clk, reset => reset, instrucao_in => instrucao_in, instrucao_out => instrucao_out, 
                         estado => estado, fetch => fetch, decode => decode, execute => execute, PC => PC);

    endereco <= PC(6 downto 0);

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

end architecture tb_JA;