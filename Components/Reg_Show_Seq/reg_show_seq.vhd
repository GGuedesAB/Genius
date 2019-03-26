library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_show_seq is
	generic (
		n: integer:= 3
	);
	port(load, clk, clear, fase: in std_logic;
		  I: in std_logic_vector(n-1 downto 0);
		  Qout: out std_logic_vector(n-1 downto 0)
	);
end entity;
architecture arch_reg_carg_par of Reg_Mostra_Seq is
signal Q: std_logic_vector(n-1 downto 0);
signal one : std_logic_vector(n-1 downto 0);

begin
	process(load, clear, clk, fase, Q) is
	begin
		one <= (0 => '1', others => '0');
		if(clear = '1') then
			for i in 0 to n-1 loop
			 Q(i) <= '0';
			end loop;
		elsif (rising_edge(clk) and load = '1') then
			if (fase = '1') then
				Q <= std_logic_vector(unsigned(I) + unsigned(one));
			else
				Q <= std_logic_vector(unsigned(Q) - unsigned(one));
			end if;
		end if;
		Qout <= Q;
	end process;
end arch_reg_carg_par;
