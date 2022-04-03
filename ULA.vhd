library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
	port ( 
				entr0, entr1 : in unsigned(15 downto 0);
				sel_op : in unsigned(2 downto 0);
				saida : out unsigned(15 downto 0);
				op_zero, entr0_maior, entr0_menor : out std_logic
			);
end entity;

architecture a_ULA of ULA is
	signal saida_interno : unsigned(15 downto 0);
begin
	saida_interno <= 
				entr0 + entr1															when sel_op = "000" else --a+b
				entr0 - entr1 														when sel_op = "001" else --a-b
				entr0(15 downto 0) or  entr1(15 downto 0) when sel_op = "010" else --a|b
				entr0(15 downto 0) and entr1(15 downto 0) when sel_op = "011" else --a&b
				entr0(15 downto 0) xor entr1(15 downto 0) when sel_op = "100" else --a^b
				not entr0(15 downto 0) 										when sel_op = "101" else --!a
				entr0																			when entr0 >  entr1 and sel_op = "110" else -- a > b ? a : b
				entr1																			when entr0 <= entr1 and sel_op = "110" else -- a > b ? a : b
				entr0																			when entr0 <  entr1 and sel_op = "111" else -- a < b ? a : b
				entr1																			when entr0 >= entr1 and sel_op = "111" else -- a < b ? a : b
				"0000000000000000";
	saida <= saida_interno;
	op_zero <= 	'1' when saida_interno = "0000000000000000" else
							'0';
	entr0_maior <=	'1' when entr0 > entr1 else
									'0';
	entr0_menor <=  '1' when entr0 < entr1 else
									'0';
end;
