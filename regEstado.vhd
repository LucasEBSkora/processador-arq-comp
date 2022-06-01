library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regEstado is
    port(
        clk                    : in  std_logic;
        rst                    : in  std_logic;
        e_V, e_N, e_Z, e_C     : in  std_logic;
        i_V, i_N, i_Z, i_C	   : in  std_logic;
        o_V, o_N, o_Z, o_C	   : out std_logic
    );
end entity;

architecture a_regEstado of regEstado is
    signal V, N, Z, C : std_logic;
begin

    process(clk, rst)
    begin
        if rst='1' then
            V <= '0';
            N <= '0';
            Z <= '0';
            C <= '0';
        else
            if e_V = '1' then
                if rising_edge(clk) then
                    V <= i_V;
                end if;
            end if;
            if e_N = '1' then
                if rising_edge(clk) then
                    N <= i_N;
                end if;
            end if;
            if e_Z = '1' then
                if rising_edge(clk) then
                    Z <= i_Z;
                end if;
            end if;
            if e_C = '1' then
                if rising_edge(clk) then
                    C <= i_C;
                end if;
            end if;
        end if;
    end process;

    o_V <= V;
    o_N <= N;
    o_Z <= Z;
    o_C <= C;
end architecture;
