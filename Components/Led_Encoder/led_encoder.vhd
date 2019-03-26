LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY led_encoder IS 
	GENERIC (DELAY : integer := 10);
	PORT	(encoder_clk, encoder_reset : in STD_LOGIC;
			 prepare_new	: in std_LOGIC;
			 bounced_swtiches : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			 debug : out std_LOGIC_VECTOR (4 downto 0);
			 encoded_sw: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			 user_interaction	: out STD_LOGIC);
END ENTITY;

ARCHITECTURE Behavior OF led_encoder IS

--component DBounce is
--	 generic (N	: integer);
--  port(clk, nreset : in std_logic;
--			button_in   : in std_logic;
--			DeBounced_out      : out std_logic);
--end component;

signal debounced_swithces : std_logic_vector (4 downto 0);
signal deb_sw1, deb_sw2, deb_sw3, deb_sw4, deb_sw5 : std_logic;
signal switch_change : std_logic;
signal force_low : integer range 0 to 2;
signal debouncers_reset : std_logic;

BEGIN
	debouncers_reset <= not encoder_reset;

	--debounced_swithc5 : DBounce generic map (N => DELAY)
	--										port map (clk => encoder_clk, nreset => debouncers_reset,
	--													 button_in => bounced_swtiches(4),
	--													 DeBounced_out => debounced_swithces(4));
	--													 
	--debounced_swithc4 : DBounce generic map (N => DELAY)
	--										port map (clk => encoder_clk, nreset => debouncers_reset,
	--													 button_in => bounced_swtiches(3),
	--													 DeBounced_out => debounced_swithces(3));
	--
	--debounced_swithc3 : DBounce generic map (N => DELAY)
	--										port map (clk => encoder_clk, nreset => debouncers_reset,
	--													 button_in => bounced_swtiches(2),
	--													 DeBounced_out => debounced_swithces(2));
	--
	--debounced_swithc2 : DBounce generic map (N => DELAY)
	--										port map (clk => encoder_clk, nreset => debouncers_reset,
	--													 button_in => bounced_swtiches(1),
	--													 DeBounced_out => debounced_swithces(1));
	--													 
	--debounced_swithc1 : DBounce generic map (N => DELAY)
	--										port map (clk => encoder_clk, nreset => debouncers_reset,
	--													 button_in => bounced_swtiches(0),
	--													 DeBounced_out => debounced_swithces(0));

	--Menos significativo LED1
	debounced_swithces <= bounced_swtiches;
	WITH debounced_swithces SELECT
		encoded_sw <=  "000" WHEN "00001",
							"001" WHEN "00010",
							"010" WHEN "00100",
							"011" WHEN "01000",
							"100" WHEN "10000",
							"111" WHEN OTHERS;
	
	process (debounced_swithces, encoder_clk, switch_change)
	begin
		deb_sw1 <= debounced_swithces(0);
		deb_sw2 <= debounced_swithces(1);
		deb_sw3 <= debounced_swithces(2);
		deb_sw4 <= debounced_swithces(3);
		deb_sw5 <= debounced_swithces(4);
		debug <= debounced_swithces;
		if (rising_edge(encoder_clk)) then
			if (prepare_new = '1') then
				force_low <= 0;
			else
				force_low <= force_low;
			end if;
			if ((deb_sw1 = '1' or deb_sw2 = '1' or deb_sw3 = '1' or deb_sw4 = '1' or deb_sw5 = '1') and (force_low < 2)) then
				switch_change <= '1';
			else
				switch_change <= '0';
			end if;
		else
			switch_change <= switch_change;
		end if;
	end process;

	user_interaction <= switch_change;
END Behavior;
