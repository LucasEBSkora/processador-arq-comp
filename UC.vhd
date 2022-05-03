library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
  port (
    clk    : in std_logic;
    reset  : in std_logic;
    PC     : out unsigned(15 downto 0) 
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
  end component;

  signal PC_incrementado : unsigned(15 downto 0);
  signal PC_interno : unsigned(15 downto 0);
  
  signal wr_en           : std_logic := '1';
begin
  PC_reg: reg16bits port map (clk => clk, rst => reset, wr_en => wr_en, data_in => PC_incrementado, data_out => PC_interno);
  
  PC_incrementado <= PC_interno + "0000000000000001";
  PC <= PC_interno;
  
end architecture a_UC;