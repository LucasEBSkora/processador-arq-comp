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
  component ULA is
    port ( 
      entr0, entr1 : in  unsigned(14 downto 0);
      sel_op 			 : in  unsigned(2 downto 0);
      saida 			 : out unsigned(14 downto 0);
      V, N, Z, C	 : out std_logic
    );
  end component ULA;

  component regEstado is
    port(
      clk                    : in  std_logic;
      rst                    : in  std_logic;
      e_V, e_N, e_Z, e_C     : in  std_logic;
      i_V, i_N, i_Z, i_C	   : in  std_logic;
      o_V, o_N, o_Z, o_C	   : out std_logic
    );
  end component;

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

  component rom
    port( clk    : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado     : out unsigned(14 downto 0)
    );
  end component rom;
  
  -- sinais ULA
  signal entr0ULA, entr1ULA, saidaULA : unsigned(14 downto 0);
  signal sel_operacao                 : unsigned(2 downto 0);
  signal sel_entr0_ULA                : std_logic;
  signal sel_entr1_ULA                : unsigned(1 downto 0);
  signal i_V, i_N, i_Z, i_C           : std_logic;
  
  -- sinais registrador de estados
  signal wr_en_V, wr_en_N, wr_en_Z, wr_en_C : std_logic;
  signal V, N, Z, C                         : std_logic;

  -- sinais banco de registradores
  signal regA, regB       : unsigned(14 downto 0);
  signal selRegA, selRegB : unsigned(2 downto 0);
  signal selRegWrite      : unsigned(2 downto 0);
  signal reg_wr_en        : std_logic;

  -- sinais UC
  signal jump_en                : std_logic;
  signal saida_memoria          : unsigned(14 downto 0);
  signal endereco_jump          : unsigned(14 downto 0);
  signal reg_instrucao          : unsigned(14 downto 0);
  signal estado_interno         : unsigned(1 downto 0);
  signal fetch, decode, execute : std_logic;
  signal endereco_instrucao     : unsigned(6 downto 0);
  signal PC_interno             : unsigned(14 downto 0);

  -- sinais de decodificação de instruções
  signal opcode        : unsigned(14 downto 11);
  
  -- LD
  signal destino_ld : unsigned(2 downto 0);
  
  -- ADD, SUB, LD 
  signal sel_operando_aritmetica_ou_ld    : unsigned(1 downto 0);
  signal dado_imediato                    : unsigned(14 downto 0);
  signal sel_registrador_aritmetica_ou_ld : unsigned(2 downto 0);
  
  -- JRxx
  signal condicao_jump : unsigned(3 downto 0);
  signal offset_jump   : unsigned(14 downto 0);

  constant condicao_JRC_ULT  : unsigned(3 downto 0) := "0000";
  constant condicao_JREQ     : unsigned(3 downto 0) := "0001";
  constant condicao_JRMI     : unsigned(3 downto 0) := "0010";
  constant condicao_JRNC_UGE : unsigned(3 downto 0) := "0011";
  constant condicao_JRNE     : unsigned(3 downto 0) := "0100";
  constant condicao_JRNV     : unsigned(3 downto 0) := "0101";
  constant condicao_JRPL     : unsigned(3 downto 0) := "0110";
  constant condicao_JRSGE    : unsigned(3 downto 0) := "0111";
  constant condicao_JRSGT    : unsigned(3 downto 0) := "1000";
  constant condicao_JRSLE    : unsigned(3 downto 0) := "1001";
  constant condicao_JRSLT    : unsigned(3 downto 0) := "1010";
  constant condicao_JRUGT    : unsigned(3 downto 0) := "1011";
  constant condicao_JRULE    : unsigned(3 downto 0) := "1100";
  constant condicao_JRV      : unsigned(3 downto 0) := "1101";
  constant condicao_JRNMI    : unsigned(3 downto 0) := "1110";
  constant condicao_JRF      : unsigned(3 downto 0) := "1111";

  -- constantes para acesso aos registradores
  constant reg_Z  : unsigned(2 downto 0) := "000";
  constant reg_A  : unsigned(2 downto 0) := "001";
  constant reg_X  : unsigned(2 downto 0) := "010";
  constant reg_Y  : unsigned(2 downto 0) := "011";
  constant reg_t1 : unsigned(2 downto 0) := "100";
  constant reg_t2 : unsigned(2 downto 0) := "101";
  constant reg_t3 : unsigned(2 downto 0) := "110";
  constant reg_t4 : unsigned(2 downto 0) := "111";

  -- constantes para os opcodes
  constant opcode_nop : unsigned(3 downto 0) := "0000"; 
  constant opcode_add : unsigned(3 downto 0) := "0001";
  constant opcode_sub : unsigned(3 downto 0) := "0010";
  constant opcode_ld  : unsigned(3 downto 0) := "0011";
  constant opcode_jr  : unsigned(3 downto 0) := "1110";
  constant opcode_jp  : unsigned(3 downto 0) := "1111";
begin
  ula_inst: ULA port map(entr0 => entr0ULA, entr1 => entr1ULA, sel_op => sel_operacao, saida => saidaULA, 
                         V => i_V, N => i_N, Z => i_Z, C => i_C);
                         
  reg_estado: regEstado port map(clk => clk, rst => rst,
                                e_V => wr_en_V, e_N => wr_en_N, e_Z => wr_en_Z, e_C => wr_en_C,
                                i_V => i_V, i_N => i_N, i_Z => i_Z, i_C => i_C,
                                o_V => V, o_N => N, o_Z => Z, o_C => C);

  regs: bancoReg port map(clk => clk, rst => rst, wr_en => reg_wr_en, selRegWrite => selRegWrite, 
                          selRegA => selRegA, selRegB => selRegB, writedata => saidaULA, regA => regA, regB => regB);  
  
  uc_inst: UC port map (clk => clk, reset => rst, jump_en => jump_en, instrucao_in => saida_memoria, 
                        endereco_jump => endereco_jump, instrucao_out => reg_instrucao, estado => estado_interno, 
                        fetch => fetch, decode => decode, execute => execute, PC => PC_interno);
  
  rom_inst: rom port map (clk => clk, endereco => endereco_instrucao, dado => saida_memoria);
                    
  -- sinais ULA
  entr0ULA <= regA        when sel_entr0_ULA = '0' else
              PC_interno  when sel_entr0_ULA = '1' else
              "000000000000000";


  entr1ULA <= regB           when sel_entr1_ULA = "00" else
              dado_imediato  when sel_entr1_ULA = "01" else
              offset_jump    when sel_entr1_ULA = "10" else
              "000000000000000";
              
  sel_operacao <= "000" when opcode = opcode_add or opcode = opcode_ld or opcode = opcode_jr else
                  "001" when opcode = opcode_sub else
                  "000";

  sel_entr0_ULA <= '1' when opcode = opcode_jr else
                   '0';

  sel_entr1_ULA <= "00" when (opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld) and
                            sel_operando_aritmetica_ou_ld = "01" else -- ld funciona somando zero ao valor escolhido
                   "10" when opcode = opcode_jr else
                   "01";

  -- sinais registrador de estados
  wr_en_V <= execute when opcode = opcode_add or opcode = opcode_sub else
             '0';

  wr_en_N <= execute when opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld else
             '0';

  wr_en_Z <= execute when opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld else
             '0';
             
  wr_en_C <= execute when opcode = opcode_add or opcode = opcode_sub else
             '0';

  -- sinais banco de registradores

  selRegA <= reg_A when (opcode = opcode_add or opcode = opcode_sub) else
    "000"; -- LD sempre usa regA como zero
    
  selRegB <= sel_registrador_aritmetica_ou_ld;

  selRegWrite <= reg_A when (opcode = opcode_add or opcode = opcode_sub) else
      destino_ld when (opcode = opcode_ld) else 
       "000";
  
  reg_wr_en <= '1' when execute = '1' and (opcode = opcode_add or opcode = opcode_sub or opcode = opcode_ld) else 
               '0';

  -- sinais UC

  jump_en <= '1'                   when opcode = opcode_jp else
              C                    when opcode = opcode_jr and condicao_jump = condicao_JRC_ULT  else 
              Z                    when opcode = opcode_jr and condicao_jump = condicao_JREQ     else 
              N                    when opcode = opcode_jr and condicao_jump = condicao_JRMI     else 
              not C                when opcode = opcode_jr and condicao_jump = condicao_JRNC_UGE else 
              not Z                when opcode = opcode_jr and condicao_jump = condicao_JRNE     else 
              not V                when opcode = opcode_jr and condicao_jump = condicao_JRNV     else 
              (not Z) and (not N)  when opcode = opcode_jr and condicao_jump = condicao_JRPL     else 
              not (N xor V)        when opcode = opcode_jr and condicao_jump = condicao_JRSGE    else 
              not (Z or (N xor V)) when opcode = opcode_jr and condicao_jump = condicao_JRSGT    else 
              Z or (N xor V)       when opcode = opcode_jr and condicao_jump = condicao_JRSLE    else 
              N xor V              when opcode = opcode_jr and condicao_jump = condicao_JRSLT    else 
              (not C) and (not Z)  when opcode = opcode_jr and condicao_jump = condicao_JRUGT    else 
              C and Z              when opcode = opcode_jr and condicao_jump = condicao_JRULE    else 
              V                    when opcode = opcode_jr and condicao_jump = condicao_JRV      else 
              not N                when opcode = opcode_jr and condicao_jump = condicao_JRNMI    else 
              '0'                  when opcode = opcode_jr and condicao_jump = condicao_JRF      else 
              '0';

  endereco_jump <= PC_interno(14 downto 11) & reg_instrucao(10 downto 0) when opcode = opcode_jp else
                   saidaULA when opcode = opcode_jr else
                   "000000000000000";

  endereco_instrucao <= PC_interno(6 downto 0);

  -- sinais de decodificação de instruções

  opcode <= reg_instrucao(14 downto 11);

  -- LD
 
  destino_ld <= reg_instrucao(8 downto 6);
 
  -- ADD, SUB, LD 

  sel_operando_aritmetica_ou_ld <= reg_instrucao (10 downto 9);
  
  dado_imediato <= unsigned(resize(signed(reg_instrucao(8 downto 0)), 15)) when opcode = opcode_add or opcode = opcode_sub else
                   unsigned(resize(signed(reg_instrucao(5 downto 0)), 15)) when opcode = opcode_ld else 
                   "000000000000000";
 
  sel_registrador_aritmetica_ou_ld <= reg_instrucao(2 downto 0);

    
  -- JRxx
  condicao_jump <= reg_instrucao(10 downto 7);
  offset_jump <= unsigned(resize(signed(reg_instrucao(6 downto 0)), 15));

  -- saídas
  estado    <= estado_interno;
  PC        <= PC_interno;
  saida     <= saidaULA;
  instrucao <= reg_instrucao;
  reg1      <= entr0ULA;
  reg2      <= regB;
end architecture a_processador;