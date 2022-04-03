library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is
	component ULA
		port ( entr0, entr1 : in unsigned(15 downto 0);
			sel_op : in unsigned(2 downto 0);
			saida : out unsigned(15 downto 0);
			op_zero, entr0_maior, entr0_menor : out std_logic
		);
	end component;
	
	signal entr0, entr1 : unsigned(15 downto 0);
	signal sel_op : unsigned(2 downto 0);
	signal saida : unsigned(15 downto 0);
	signal op_zero, entr0_maior, entr0_menor : std_logic;

	begin
		uut: ULA port map(entr0 => entr0, entr1 => entr1, sel_op => sel_op, saida => saida, op_zero => op_zero, entr0_maior => entr0_maior, entr0_menor => entr0_menor);
		process
		begin
			sel_op <= "000";
			entr0 <= "0000000000000000";
			entr1 <= "0000000000000000";
			wait for 50 ns;
			entr0 <= "0000000000000011";
			entr1 <= "0000000000000100";
			wait for 50 ns;
			entr0 <= "0000000000000011";
			entr1 <= "1111111111111000";
			wait for 50 ns;

			sel_op <= "001";
			entr0 <= "1111111111111111";
			entr1 <= "1111111111111111";
			wait for 50 ns;
			entr0 <= "0000000011111111";
			entr1 <= "0000000000000100";
			wait for 50 ns;
			entr0 <= "0000000011111111";
			entr1 <= "0000000100000000";
			wait for 50 ns;

			sel_op <= "010";
			entr0 <= "0101010101010101";
			entr1 <= "1010101010101010";
			wait for 50 ns;

			sel_op <= "011";
			wait for 50 ns;

			sel_op <= "100";
			entr0 <= "0000000011111111";
			entr1 <= "0101010101010101";
			wait for 50 ns;

			sel_op <= "101";
			wait for 50 ns;

			sel_op <= "110";
			entr0 <= "0000000000000011";
			entr1 <= "0000000000000100";
			wait for 50 ns;

			entr0 <= "0000000000001011";
			entr1 <= "0000000000000100";
			wait for 50 ns;

			sel_op <= "111";
			entr0 <= "0000000000000011";
			entr1 <= "0000000000000100";
			wait for 50 ns;

			entr0 <= "0000000000001011";
			entr1 <= "0000000000000100";
			wait for 50 ns;

			wait;
		end process;
end architecture;