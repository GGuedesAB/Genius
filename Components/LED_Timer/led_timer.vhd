library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity led_timer is
	generic(
		m: integer := 5 -- PARA SER UM TEMP. DE 0,5 SEG.
	);
	port(
		clk: in std_logic;
		clear: in std_logic;
		start: in std_logic;
		finish : out std_logic
	);
end temp;

architecture arch_temp of temp is
	signal count : integer;
	begin

	process (clk, clear, start, count)
		begin
		if (clear = '1') then
			count <= 0;
			finish <= '0';
		elsif (rising_edge(clk) and start = '1') then
			if (count < m) then
				finish <= '0';
				count <= count + 1;
			else
				finish <= '1';
				count <= count;
			end if;
		elsif (rising_edge(clk) and start = '0') then
			count <= 0;
		else 
			count <= count;
		end if;
	end process;
end arch_temp;
