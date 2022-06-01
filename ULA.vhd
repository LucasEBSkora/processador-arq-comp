library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
	port ( 
		entr0, entr1 : in  unsigned(14 downto 0);
		sel_op 			 : in  unsigned(2 downto 0);
		saida 			 : out unsigned(14 downto 0);
		V, N, Z, C	 : out std_logic
	);
end entity;

architecture a_ULA of ULA is
	signal saida_interno : unsigned(14 downto 0);

	constant op_add : unsigned(2 downto 0) := "000"; 
  constant op_sub : unsigned(2 downto 0) := "001";
  constant op_or  : unsigned(2 downto 0) := "010";
  constant op_and : unsigned(2 downto 0) := "011";
  constant op_xor : unsigned(2 downto 0) := "100";
	constant op_not : unsigned(2 downto 0) := "101";
	constant op_gt  : unsigned(2 downto 0) := "110";
	constant op_lt  : unsigned(2 downto 0) := "111";
begin
	saida_interno <= 
				entr0 + entr1															when sel_op = op_add else --a+b
				entr0 - entr1 														when sel_op = op_sub else --a-b
				entr0(14 downto 0) or  entr1(14 downto 0) when sel_op = op_or  else --a|b
				entr0(14 downto 0) and entr1(14 downto 0) when sel_op = op_and else --a&b
				entr0(14 downto 0) xor entr1(14 downto 0) when sel_op = op_xor else --a^b
				not entr0(14 downto 0) 										when sel_op = op_not else --!a
				entr0																			when entr0 >  entr1 and sel_op = op_gt else -- a > b ? a : b
				entr1																			when entr0 <= entr1 and sel_op = op_gt else -- a > b ? a : b
				entr0																			when entr0 <  entr1 and sel_op = op_lt else -- a < b ? a : b
				entr1																			when entr0 >= entr1 and sel_op = op_lt else -- a < b ? a : b
				"000000000000000";
	saida <= saida_interno;
	
	V <= ((entr0(14) and entr1(14)) or (entr1(14) and (not saida_interno(14))) or ((not saida_interno(14)) and entr0(14))) XOR ((entr0(13) and entr1(13)) or (entr1(13) and (not saida_interno(13))) or ((not saida_interno(13)) and entr0(13)))  when sel_op = op_add else
			 ((entr0(14) and entr1(14)) or (entr0(14) and saida_interno(14)) or (entr0(14) and entr1(14) and saida_interno(14))) XOR ((entr0(13) and entr1(13)) or (entr0(13) and saida_interno(13)) or (entr0(13) and entr1(13) and saida_interno(13)))when sel_op = op_sub else
	'0';
	
	N <= saida_interno(14);

	Z <= 	'1' when saida_interno = "000000000000000" else
				'0';
				
	C <= (entr0(14) and entr1(14)) or (entr1(14) and not saida_interno(14)) or (not saida_interno(14) and entr0(14))  when sel_op = op_add else
		((not entr0(14)) and entr1(14)) or ((not entr0(14)) and saida_interno(14)) or (entr0(14) and entr1(14) and saida_interno(14)) when sel_op = op_sub else
			'0';
	
end;
