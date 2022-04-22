library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bancoReg is
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
end entity bancoReg;

architecture a_bancoReg of bancoReg is
  component reg16bits is
    port( clk      : in std_logic;
          rst      : in std_logic;
          wr_en    : in std_logic;
          data_in  : in unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
    );
  end component reg16bits;
  
  signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7 : std_logic;
  signal data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7: unsigned(15 downto 0);

begin
  reg1: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_1, data_in => writeData, data_out => data_out_1);
  reg2: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_2, data_in => writeData, data_out => data_out_2);
  reg3: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_3, data_in => writeData, data_out => data_out_3);
  reg4: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_4, data_in => writeData, data_out => data_out_4);
  reg5: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_5, data_in => writeData, data_out => data_out_5);
  reg6: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_6, data_in => writeData, data_out => data_out_6);
  reg7: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_7, data_in => writeData, data_out => data_out_7);
 
  wr_en_1 <= wr_en when selRegWrite = "001" else '0';
  wr_en_2 <= wr_en when selRegWrite = "010" else '0';
  wr_en_3 <= wr_en when selRegWrite = "011" else '0';
  wr_en_4 <= wr_en when selRegWrite = "100" else '0';
  wr_en_5 <= wr_en when selRegWrite = "101" else '0';
  wr_en_6 <= wr_en when selRegWrite = "110" else '0';
  wr_en_7 <= wr_en when selRegWrite = "111" else '0';

  regA <= 
    data_out_1 when selRegA = "001" else 
    data_out_2 when selRegA = "010" else 
    data_out_3 when selRegA = "011" else 
    data_out_4 when selRegA = "100" else 
    data_out_5 when selRegA = "101" else 
    data_out_6 when selRegA = "110" else 
    data_out_7 when selRegA = "111" else 
    "0000000000000000";

  regB <= 
    data_out_1 when selRegB = "001" else 
    data_out_2 when selRegB = "010" else 
    data_out_3 when selRegB = "011" else 
    data_out_4 when selRegB = "100" else 
    data_out_5 when selRegB = "101" else 
    data_out_6 when selRegB = "110" else 
    data_out_7 when selRegB = "111" else 
    "0000000000000000";

end architecture a_bancoReg;