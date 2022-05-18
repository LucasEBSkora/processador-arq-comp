library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity tb_ULA is
end;

architecture a_tb_ULA of tb_ULA is
	component ULA
		port ( 
			entr0, entr1 											: in  unsigned(14 downto 0);
			sel_op 			 											: in  unsigned(2 downto 0);
			saida 			 											: out unsigned(14 downto 0);
			op_zero, entr0_maior, entr0_menor : out std_logic
		);
	end component;
	
	signal entr0, entr1 										 : unsigned(14 downto 0);
	signal sel_op 													 : unsigned(2 downto 0);
	signal saida 														 : unsigned(14 downto 0);
	signal op_zero, entr0_maior, entr0_menor : std_logic;

	begin
		uut: ULA port map(entr0 => entr0, entr1 => entr1, sel_op => sel_op,
										  saida => saida, op_zero => op_zero, entr0_maior => entr0_maior, entr0_menor => entr0_menor);
		process
		begin

			-- 0 + 0 = 0
			sel_op <= "000";
			entr0 <= "000000000000000";
			entr1 <= "000000000000000";
			wait for 50 ns;

			-- 3 + 4 = 7
			entr0 <= "000000000000011";
			entr1 <= "000000000000100";
			wait for 50 ns;
			-- 3 + 7FF8 = 7FFB
			entr0 <= "000000000000011";
			entr1 <= "111111111111000";
			wait for 50 ns;

			-- 7FFF - 7FFF = 0
			sel_op <= "001";
			entr0 <= "111111111111111";
			entr1 <= "111111111111111";
			-- FF - 4 = FB
			wait for 50 ns;
			entr0 <= "000000011111111";
			entr1 <= "000000000000100";

			-- FF - 100 = -1 = 7FFF_c2
			wait for 50 ns;
			entr0 <= "000000011111111";
			entr1 <= "000000100000000";
			wait for 50 ns;

			-- 5555 | 2AAA = 7FFF
			sel_op <= "010";
			entr0 <= "101010101010101";
			entr1 <= "010101010101010";
			wait for 50 ns;

			-- 5555 & 2AAA = 0
			sel_op <= "011";
			wait for 50 ns;

			-- 00FF ^ 5555 = 55AA
			sel_op <= "100";
			entr0 <= "000000011111111";
			entr1 <= "101010101010101";
			wait for 50 ns;

			-- !00FF = 7F00
			sel_op <= "101";
			wait for 50 ns;

			-- 3 > 4 ? 3 : 4 = 4
			sel_op <= "110";
			entr0 <= "000000000000011";
			entr1 <= "000000000000100";
			wait for 50 ns;

			-- B > 4 ? B : 4 = B
			entr0 <= "000000000001011";
			entr1 <= "000000000000100";
			wait for 50 ns;

			-- 3 < 4 ? 3 : 4 = 3
			sel_op <= "111";
			entr0 <= "000000000000011";
			entr1 <= "000000000000100";
			wait for 50 ns;

			-- B < 4 ? B : 4 = 4
			entr0 <= "000000000001011";
			entr1 <= "000000000000100";
			wait for 50 ns;

			wait;
		end process;
end architecture a_tb_ULA;