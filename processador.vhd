library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    estado    : out unsigned(1 downto 0);
    PC        : out unsigned(14 downto 0);
    instrucao : out unsigned(14 downto 0);
    reg1      : out unsigned(14 downto 0);
    reg2      : out unsigned(14 downto 0);
    saida     : out unsigned(14 downto 0)
  );
end entity processador;

architecture a_processador of processador is
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

  component ULA is
    port ( 
          entr0, entr1                      : in  unsigned(14 downto 0);
          sel_op                            : in  unsigned(2 downto 0);
          saida                             : out unsigned(14 downto 0);
          op_zero, entr0_maior, entr0_menor : out std_logic
        );
  end component ULA;

  component bancoReg is
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      wr_en       : in  std_logic;
      selRegWrite : in  unsigned(2 downto 0);
      selRegA     : in  unsigned(2 downto 0);
      selRegB     : in  unsigned(2 downto 0);
      writeData   : in  unsigned(14 downto 0);
      regA        : out unsigned(14 downto 0);
      regB        : out unsigned(14 downto 0)
    );
  end component bancoReg;
  
  signal entr0ULA, entr1ULA, saidaULA : unsigned(14 downto 0);
  signal regB                         : unsigned(14 downto 0);

  signal reg_wr_en                         : std_logic;
  signal sel_entr1_ULA                     : std_logic;
  signal selRegWrite                       : unsigned(2 downto 0);
  signal selRegA                           : unsigned(2 downto 0);
  signal selRegB                           : unsigned(2 downto 0);
  signal sel_operacao                      : unsigned(2 downto 0);

  signal op_zero, entr0_maior, entr0_menor : std_logic;
  
  signal endereco_instrucao : unsigned(6 downto 0);
  signal PC_interno         : unsigned(14 downto 0);
  signal saida_memoria      : unsigned(14 downto 0);

  signal estado_interno         : unsigned(1 downto 0);
  signal fetch, decode, execute : std_logic;

  signal reg_instrucao : unsigned(14 downto 0);
  signal opcode        : unsigned(14 downto 11);
  
  -- LD
  signal destino_ld : unsigned(2 downto 0);
  
  -- ADD, SUB, LD 
  signal sel_operando_aritmetica_ou_ld    : unsigned(1 downto 0);
  signal dado_imediato                    : unsigned(14 downto 0);
  signal sel_registrador_aritmetica_ou_ld : unsigned(2 downto 0);
  
  constant reg_Z  : unsigned(2 downto 0) := "000";
  constant reg_A  : unsigned(2 downto 0) := "001";
  constant reg_X  : unsigned(2 downto 0) := "010";
  constant reg_Y  : unsigned(2 downto 0) := "011";
  constant reg_t1 : unsigned(2 downto 0) := "100";
  constant reg_t2 : unsigned(2 downto 0) := "101";
  constant reg_t3 : unsigned(2 downto 0) := "110";
  constant reg_t4 : unsigned(2 downto 0) := "111";
  
  constant opcode_nop : unsigned(3 downto 0) := "0000"; 
  constant opcode_add : unsigned(3 downto 0) := "0001";
  constant opcode_sub : unsigned(3 downto 0) := "0010";
  constant opcode_ld  : unsigned(3 downto 0) := "0011";
  constant opcode_ja  : unsigned(3 downto 0) := "1111"; -- Unidade de controle faz tudo nesse caso
begin
  rom_inst: rom port map (clk => clk, endereco => endereco_instrucao, dado => saida_memoria);
  uc_inst: UC port map (clk => clk, reset => rst, instrucao_in => saida_memoria, instrucao_out => reg_instrucao, estado => estado_interno, 
                        fetch => fetch, decode => decode, execute => execute, PC => PC_interno);
  ula_inst: ULA port map(entr0 => entr0ULA, entr1 => entr1ULA, 
                         sel_op => sel_operacao, saida => saidaULA, 
                         op_zero => op_zero, entr0_maior => entr0_maior, entr0_menor => entr0_menor);
  
  regs: bancoReg port map(clk => clk, rst => rst, wr_en => reg_wr_en, 
                          selRegWrite => selRegWrite, selRegA => selRegA, selRegB => selRegB,
                          writedata => saidaULA, regA => entr0ULA, regB => regB);
  
  opcode <= reg_instrucao(14 downto 11);

  sel_operando_aritmetica_ou_ld <= reg_instrucao (10 downto 9);
  dado_imediato <= "000000" & reg_instrucao(8 downto 0) when opcode = opcode_add or opcode = opcode_sub else
                   "000000000" & reg_instrucao(5 downto 0) when opcode = opcode_ld else 
                   "000000000000000";
  destino_ld <= reg_instrucao(8 downto 6);
 
  sel_registrador_aritmetica_ou_ld <= reg_instrucao(2 downto 0);

  reg_wr_en <= '1' when execute = '1' and (opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld) else 
               '0';

  sel_entr1_ULA <= '0' when ((opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld) and sel_operando_aritmetica_ou_ld = "01") else -- ld funciona somando zero ao valor escolhido
                   '1';


  selRegWrite <= reg_A when (opcode = opcode_add or opcode = opcode_sub) else
                 destino_ld when (opcode = opcode_ld) else 
                  "000";
  selRegA <= reg_A when (opcode = opcode_add or opcode = opcode_sub) else
             "000"; -- LD sempre usa regA como zero

  selRegB <= sel_registrador_aritmetica_ou_ld;

  sel_operacao <= "000" when opcode = opcode_add or opcode = opcode_ld else
                  "001" when opcode = opcode_sub else
                  "000";

  endereco_instrucao <= PC_interno(6 downto 0);

  entr1ULA <= regB           when sel_entr1_ULA = '0' else
              dado_imediato  when sel_entr1_ULA = '1' else
              "000000000000000";
  
  estado <= estado_interno;
  PC <= PC_interno;
  saida <= saidaULA;
  instrucao <= reg_instrucao;
  reg1 <= entr0ULA;
  reg2 <= regB;
end architecture a_processador;