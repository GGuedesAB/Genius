LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder IS 
	PORT
	(En : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
	leds: OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
END decoder;

ARCHITECTURE Behavior OF decoder IS
BEGIN

	--Menos significativo LED1
	WITH En SELECT
		leds <=  "00001" WHEN "000",
					"00010" WHEN "001",
					"00100" WHEN "010",
					"01000" WHEN "011",
					"10000" WHEN "100",
					"11111" WHEN OTHERS;
END Behavior;

