library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bancoReg is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    wr_en       : in  std_logic;
    selRegWrite : in  unsigned(1 downto 0);
    selReg1     : in  unsigned(1 downto 0);
    selReg2     : in  unsigned(1 downto 0);
    writeData   : in  unsigned(14 downto 0);
    reg1        : out unsigned(14 downto 0);
    reg2        : out unsigned(14 downto 0)
  );
end entity bancoReg;

architecture a_bancoReg of bancoReg is
  component reg15bits is
    port( clk      : in std_logic;
          rst      : in std_logic;
          wr_en    : in std_logic;
          data_in  : in unsigned(14 downto 0);
          data_out : out unsigned(14 downto 0)
    );
  end component reg15bits;
  
  signal wr_en_A, wr_en_X, wr_en_Y          : std_logic;
  signal data_out_A, data_out_X, data_out_Y : unsigned(14 downto 0);

begin
  reg_a: reg15bits port map(clk => clk, rst => rst, wr_en => wr_en_A, data_in => writeData, data_out => data_out_A);
  reg_x: reg15bits port map(clk => clk, rst => rst, wr_en => wr_en_X, data_in => writeData, data_out => data_out_X);
  reg_y: reg15bits port map(clk => clk, rst => rst, wr_en => wr_en_Y, data_in => writeData, data_out => data_out_Y);
 
  wr_en_A <= wr_en when selRegWrite = "01" else '0';
  wr_en_X <= wr_en when selRegWrite = "10" else '0';
  wr_en_Y <= wr_en when selRegWrite = "11" else '0';

    reg1 <= 
    data_out_A when selReg1 = "01" else 
    data_out_X when selReg1 = "10" else 
    data_out_Y when selReg1 = "11" else 
    "000000000000000";

  reg2 <= 
    data_out_A when selReg2 = "01" else 
    data_out_X when selReg2 = "10" else 
    data_out_Y when selReg2 = "11" else 
    "000000000000000";

end architecture a_bancoReg;