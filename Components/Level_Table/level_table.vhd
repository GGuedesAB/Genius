library ieee;
use ieee.std_logic_1164.all;

entity level_table is
	generic (word_size :integer := 50;
				address   :integer := 10
				);
	
	port (clk, clear 		: in std_logic;
			addr_in			: in integer range address-1 downto 0;
			--Writing interface
			write_eneable	: in std_logic;
			write_data 		: in std_logic_vector (word_size-1 downto 0);
			--Reading interface
			read_eneable	: in std_logic;
			read_data		: out std_logic_vector (word_size-1 downto 0)
			);
end entity;

architecture main of banco_de_reg is
	type reg_banco is array (address-1 downto 0) of std_logic_vector (word_size-1 downto 0);
	signal banco_1 : reg_banco;
begin
		process (clk, clear)
		begin
			if (clear = '1') then
				for i in 0 to address-1 loop
					banco_1(i) <= (others => '0');
				end loop;
			elsif (rising_edge(clk)) then
				if (write_eneable = '1') then
					banco_1(addr_in) <= write_data;
				end if;
			end if;
		end process;
		
		read_data <= banco_1(addr_in);
end architecture;
