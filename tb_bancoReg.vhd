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
      selRegWrite : in  unsigned(2 downto 0);
      selRegA     : in  unsigned(2 downto 0);
      selRegB     : in  unsigned(2 downto 0);
      writeData   : in  unsigned(15 downto 0);
      regA        : out unsigned(15 downto 0);
      regB        : out unsigned(15 downto 0)
    );
  end component;

  constant clk_period                  : time      := 100 ns;
  signal finished                      : std_logic := '0';
  signal clk, rst, wr_en               : std_logic;
  signal selRegWrite, selRegA, selRegB : unsigned(2 downto 0);
  signal writeData, regA, regB         : unsigned(15 downto 0);

  begin
    uut: bancoReg port map(clk => clk, rst => rst, wr_en => wr_en,
                           selRegWrite => selRegWrite, selRegA => selRegA, selRegB => selRegB,
                           writeData => writeData, regA => regA, regB => regB);
    
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

      -- lê e escreve em dois registradores
      wr_en <= '1';
      selRegA <= "001";
      selRegB <= "010";
      selRegWrite <= "001";
      writeData <= "1010101111001101";
      wait for clk_period*3;
      
      selRegWrite <= "010";
      writeData <= "1110111111111110";
      wait for clk_period;

      -- não escreve pro registrador 0
      writeData <= "1111111111111111";
      selRegWrite <= "000";
      selRegA <= "000";
      selRegB <= "000";
      wait for clk_period;

      -- não escreve sem o write enable

      wr_en <= '0';
      selRegWrite <= "011";
      selRegA <= "011";
      selRegB <= "011";
      wait for clk_period;

      -- mas escreve nos outros 7
      
      wr_en <= '1';
      
      writeData <= "0000000000000001";
      selRegWrite <= "001";
      selRegA <= "001";
      selRegB <= "000";
      wait for clk_period;

      writeData <= "0000000000000010";
      selRegWrite <= "010";
      selRegA <= "010";
      selRegB <= "001";
      wait for clk_period;

      writeData <= "0000000000000011";
      selRegWrite <= "011";
      selRegA <= "011";
      selRegB <= "010";
      wait for clk_period;

      writeData <= "0000000000000100";
      selRegWrite <= "100";
      selRegA <= "100";
      selRegB <= "011";
      wait for clk_period;

      writeData <= "0000000000000101";
      selRegWrite <= "101";
      selRegA <= "101";
      selRegB <= "100";
      wait for clk_period;

      writeData <= "0000000000000110";
      selRegWrite <= "110";
      selRegA <= "110";
      selRegB <= "101";
      wait for clk_period;

      writeData <= "0000000000000111";
      selRegWrite <= "111";
      selRegA <= "111";
      selRegB <= "110";
      wait for clk_period;

      selRegB <= "111";
      wait for clk_period;

      wait;
    end process;

end architecture a_tb_bancoReg;