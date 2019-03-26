library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity level_timer is
	generic(
		n: integer;
		--m: integer := 375000000
		m : integer
	);
	port(
		clk	: in std_logic;
		clear	: in std_logic;
		start	: in std_logic;
		param	: in integer range 0 to n;
		time_left: out integer range 0 to n+1;
		finish : out std_logic
	);
end entity;

architecture main of tempo_fase is

	signal count : integer range 0 to m;
	signal limite : integer range 0 to n+1;
	signal count_to : integer range 0 to n+1;
	
	begin
	
	
	process (clk, clear, start, count, limite, param)
		begin
		count_to <= param + 1;
		time_left <= limite;
		if (clear = '1') then
			limite <= 0;
			finish <= '0';
			
		elsif (rising_edge(clk) and start = '1') then
			if (limite = count_to) then
				finish <= '1';
				limite <= limite;
			elsif (count < m) then
				finish <= '0';
				count <= count + 1;
			elsif (count = m) then
				limite <= limite + 1;
				count <= 0;
			else
				limite <= limite;
			end if;
					
		else
			limite <= limite;
			count <= count;
		end if;
		
	end process;
end main;
