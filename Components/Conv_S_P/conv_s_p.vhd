library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_serie_paralelo is
	generic (
		n: integer:= 30
	);
	port(
		m : in integer range 0 to 9;
		load_leds, shft_left ,move, clk, clear: in std_logic;
		leds : in std_logic_vector (n-1 downto 0);
		Q: out std_logic_vector(2 downto 0)
	);
end entity;

architecture main of reg_serie_paralelo is

	--shared variable k : integer range 0 to n;
	--shared variable j : integer range 0 to n;
	shared variable Qi : std_logic_vector (n-1 downto 0);

	signal clk_int: std_logic;
	signal fase : integer range 0 to 10;

begin
	clk_int <= clk;
	
	process(shft_left, clear, clk_int, load_leds, move) is
	begin
		--Indice da fase + 1
		--fase <= m+1;
		--for l in ((3*fase)-1) downto ((3*fase)-3) loop
		--	Qi(l) := Qi(l);
		--end loop;
	
		if (clear = '1') then
			for k in 0 to n-1 loop
				Qi(k) := '0';
			end loop;
			
		elsif(rising_edge(clk_int)) then
		
			if (load_leds = '1') then
				for i in 0 to n-1 loop
					Qi(i) := leds(i);
				end loop;
			else
				Qi := Qi;
			end if;
				
			if (shft_left = '1' and move = '1') then --Desloca para esquerda
				for j in n-1 downto 1 loop
					Qi(j) := Qi(j-1);
				end loop;
				Qi(0) := '0';
			else
				Qi := Qi;
			end if;
			
			for l in 2 downto 0 loop
				Q(l) <= Qi((3*m)+l);
			end loop;
			
		end if;
	end process;

end main;