library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is
	component mux8x1
		port( entr0,entr1 : in unsigned(15 downto 0);
				sel_op : in unsigned(1 downto 0);
				saida : out unsigned(15 downto 0)
			);
	end component;
	
	signal entr0, entr1, in_sel0, in_sel1, in_sel2: std_logic;

	begin
		uut: porta port map( entr0 => entr0,
									entr1 => entr1,
									sel_op => sel_op,
									sel_1 => sel_1,
									sel_2 => sel_2
								);
	process
	begin
		entr0 <= '0000000000000000';
		entr1 <= '0000000000000000';
		sel_op <= '00';
		wait for 50 ns;
		entr0 <= '0000000000000010';
		entr1 <= '0000000000000100';
		wait for 50 ns;
		entr0 <= '0000000000000110';
		entr1 <= '0000000000000100';
		sel_op <= '01';
		wait for 50 ns;
		entr0 <= '0000000000000110';
		entr1 <= '0000000000000100';
		sel_op <= '10';
		wait for 50 ns;
		entr0 <= '0000000000000110';
		entr1 <= '0000000000000100';
		sel_op <= '01';
		wait for 50 ns;
		entr0 <= '1010101010101010';
		entr1 <= '0101010101010101';
		sel_op <= '11';
		wait for 50 ns;
		wait;
	end process;
end architecture;