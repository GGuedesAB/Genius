library ieee;
use ieee.std_logic_1164.all;

entity comparator is
	generic (n: integer := 4
	);
	
	port (a, b: in std_logic_vector (n-1 downto 0);
			igual, maior, menor : out std_logic
	);
end comparador;

architecture arch_comparador of comparador is
begin
	process (a, b)
	begin
		if (a = b) then
			igual <= '1';
			maior <= '0';
			menor <= '0';
		elsif (a > b) then
			igual <= '0';
			maior <= '1';
			menor <= '0';
		elsif (a < b) then 
			igual <= '0';
			maior <= '0';
			menor <= '1';
		else
			igual <= '1';
			maior <= '1';
			menor <= '1';
		end if;
	end process;
end arch_comparador;
