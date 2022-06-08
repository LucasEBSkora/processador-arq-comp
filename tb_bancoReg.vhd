library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_bancoReg is
end entity tb_bancoReg;

architecture a_tb_bancoReg of tb_bancoReg is
  component bancoReg
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
  end component;

  constant clk_period                  : time      := 100 ns;
  signal finished                      : std_logic := '0';
  signal clk, rst, wr_en               : std_logic;
  signal selRegWrite, selReg1, selReg2 : unsigned(1 downto 0);
  signal writeData, reg1, reg2         : unsigned(14 downto 0);

  begin
    uut: bancoReg port map(clk => clk, rst => rst, wr_en => wr_en,
                           selRegWrite => selRegWrite, selReg1 => selReg1, selReg2 => selReg2,
                           writeData => writeData, reg1 => reg1, reg2 => reg2);
    
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

      -- escreve nos registradores A, X e Y
      wr_en <= '1';
      selReg1 <= "01";
      selReg2 <= "10";
      selRegWrite <= "01";
      writeData <= "010101111001101";
      wait for clk_period*3;
      
      selReg1 <= "10";
      selReg2 <= "11";
      selRegWrite <= "10";
      writeData <= "110111111111110";
      wait for clk_period;

      selReg1 <= "11";
      selReg2 <= "00";
      selRegWrite <= "11";
      writeData <= "100010001000100";
      wait for clk_period;

      -- não escreve pro registrador Zero
      writeData <= "111111111111111";
      selRegWrite <= "00";
      wait for clk_period;

      -- não escreve sem o write enable

      wr_en <= '0';
      writeData <= "011101110111011";
      selRegWrite <= "11";
      wait for clk_period;

      wait;
    end process;

end architecture a_tb_bancoReg;