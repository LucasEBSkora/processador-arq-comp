library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity proc is
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
end entity proc;

architecture a_proc of proc is
  component ULA is
    port ( 
          entr0, entr1 : in unsigned(15 downto 0);
          sel_op : in unsigned(2 downto 0);
          saida : out unsigned(15 downto 0);
          op_zero, entr0_maior, entr0_menor : out std_logic
        );
  end component ULA;

  component bancoReg is
    port (
      clk : in std_logic;
      rst : in std_logic;
      wr_en : in std_logic;
      selRegWrite: in unsigned(2 downto 0);
      selRegA: in unsigned(2 downto 0);
      selRegB: in unsigned(2 downto 0);
      writeData : in unsigned(15 downto 0);
      regA : out unsigned(15 downto 0);
      regB : out unsigned(15 downto 0)
    );
  end component bancoReg;
  
  signal entr0ULA, entr1ULA, saidaULA : unsigned(15 downto 0);
  signal regB: unsigned(15 downto 0);

begin
  ula_inst: ULA port map(entr0 => entr0ULA, entr1 => entr1ULA, 
       sel_op => sel_op, saida => saidaULA, 
       op_zero => op_zero, entr0_maior => entr0_maior, entr0_menor => entr0_menor);
  regs: bancoReg port map(clk => clk, rst => rst, wr_en => wr_en, 
                          selRegWrite => selRegWrite, selRegA => selRegA, selRegB => selRegB,
                          writedata => saidaULA, regA => entr0ULA, regB => regB);
  
  entr1ULA <= regB           when sel_entr1_ULA = '0' else
              entradaExterna when sel_entr1_ULA = '1' else
              "0000000000000000";

  saida <= saidaULA;

end architecture a_proc;