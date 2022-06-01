library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
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
end entity UC;

architecture a_UC of UC is
  component reg15bits 
    port(
      clk      : in  std_logic;
      rst      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(14 downto 0);
      data_out : out unsigned(14 downto 0)
    );
  end component reg15bits;

  component maquinaEstados
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        estado : out unsigned(1 downto 0)
    );
  end component maquinaEstados;

  signal PC_entrada : unsigned(14 downto 0);
  signal PC_interno : unsigned(14 downto 0);

  signal instrucao_interno : unsigned(14 downto 0);
  
  signal estado_interno    : unsigned(1 downto 0);
  signal estado_fetch, estado_decode, estado_execute : std_logic;

  signal wr_en_pc     : std_logic;
  signal wr_en_in_reg : std_logic;
begin

  PC_reg: reg15bits port map (clk => clk, rst => reset, wr_en => wr_en_pc, data_in => PC_entrada, data_out => PC_interno);
  instrucao_reg: reg15bits port map (clk => clk, rst => reset, wr_en => wr_en_in_reg, data_in => instrucao_in, data_out => instrucao_interno);
  maqEstados: maquinaEstados port map (clk => clk, reset => reset, estado => estado_interno);

  PC_entrada <= endereco_jump when jump_en = '1' else
                PC_interno + "000000000000001";

  estado_fetch <= '1' when estado_interno = "00" else
                  '0';

  estado_decode <= '1' when estado_interno = "01" else
                  '0';

  estado_execute <= '1' when estado_interno = "10" else
                  '0';

  wr_en_pc <= estado_execute;
  wr_en_in_reg <= estado_decode;

  -- saídas
  instrucao_out <= instrucao_interno;
  estado <= estado_interno;
  fetch <= estado_fetch;
  decode <= estado_decode;
  execute <= estado_execute;
  PC <= PC_interno;
  
end architecture a_UC;
