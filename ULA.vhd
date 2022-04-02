library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
	port ( entr0,entr1 : in unsigned(15 downto 0);
				sel_op : in unsigned(1 downto 0);
				saida : out unsigned(15 downto 0)
			);
end entity;

architecture a_ULA of ULA is
begin
	saída <= entr0+entr1 when sel_op = "00" else
				entr0-entr1 when sel_op = "01" else
				entr0 when entr0>entr1 and sel_op = "10" else
				entr1 when entr1>entr0 and sel_op = "10" else  --retorna o maior
				entr0(7 downto 0) and entr1(7 downto 0) when sel_op = '11' else --Operação de and em cada um dos bits
				'0000000000000000';
end
