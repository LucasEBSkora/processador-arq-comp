library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
  port (
    clk       : in std_logic;
    reset     : in std_logic;
    instrucao : in unsigned(14 downto 0);
    PC        : out unsigned(15 downto 0)
  );
end entity UC;

architecture a_UC of UC is
  component reg16bits 
    port( clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
  end component reg16bits;

  component maquinaEstados
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        estado : out std_logic
    );
  end component maquinaEstados;

  signal PC_entrada: unsigned(15 downto 0);
  signal PC_interno : unsigned(15 downto 0);
  
  signal estado  : std_logic;
  signal opcode  : unsigned(3 downto 0);
  
  signal wr_en_pc   : std_logic;
  signal jump_en    : std_logic; 
  
  
  constant opcode_nop  : unsigned(3 downto 0) := "0000";
  constant opcode_jump : unsigned(3 downto 0) := "1111";
begin

  PC_reg: reg16bits port map (clk => clk, rst => reset, wr_en => wr_en_pc, data_in => PC_entrada, data_out => PC_interno);
  maqEstados: maquinaEstados port map (clk => clk, reset => reset, estado => estado);

  wr_en_pc <= estado;

  opcode <= instrucao(14 downto 11);

  jump_en <= '1' when opcode = opcode_jump else
             '0'; 

  PC_entrada <= PC_interno(15 downto 11) & instrucao(10 downto 0) when jump_en = '1' else
                PC_interno + "0000000000000001";
  
  PC <= PC_interno;
  
end architecture a_UC;