library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_input is
	generic (
		n: integer:= 30;
		m: integer:= 3
	);
	port(
		load_entrada, shft_left ,move, clk, clear: in std_logic;
		entrada : in std_logic_vector (m-1 downto 0);
		Q: out std_logic_vector(n-1 downto 0)
	);
end entity;

architecture main of reg_entrada_jogador is

	shared variable k : integer range 0 to n;
	shared variable j : integer range 0 to n;
	shared variable Qi : std_logic_vector (n-1 downto 0);

	signal clk_int: std_logic;

begin
	clk_int <= clk;
	
	process(shft_left, clear, clk_int, load_entrada, move) is
	begin
	
		if (clear = '1') then
			for k in 0 to n-1 loop
				Qi(k) := '0';
			end loop;
			
		elsif(rising_edge(clk_int)) then
		
			if (load_entrada = '1') then
				for i in 0 to m-1 loop
					Qi(i) := entrada(i);
				end loop;
			else
				Qi := Qi;
			end if;
				
			if (shft_left = '1' and move = '1') then --Desloca para direita
				for j in n-1 downto 1 loop
					Qi(j) := Qi(j-1);
				end loop;
				Qi(0) := '0';
			else
				Qi := Qi;
			end if;
		end if;
	end process;
	
	Q<=Qi;

end main;
