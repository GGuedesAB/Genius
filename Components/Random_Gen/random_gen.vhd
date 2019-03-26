library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity random_gen is
Port ( clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (2 downto 0);
       check: out STD_LOGIC);
end entity;

architecture main of gerador_aleatorio is

signal Qt: STD_LOGIC_VECTOR(7 downto 0) := x"01";

shared variable resto : integer;

begin
	process(clock)
		variable tmp : STD_LOGIC := '0';
	begin

		if rising_edge(clock) then			
			if (reset='1') then
				Qt <= x"01"; 
			elsif en = '1' then
				tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
				Qt <= tmp & Qt(7 downto 1);
			end if;
		resto := (((to_integer(unsigned(Qt))) mod 5) + 1);
		end if;
	end process;

	check <= Qt(7);
	Q <= std_logic_vector(to_unsigned(resto, 3));

end main;
