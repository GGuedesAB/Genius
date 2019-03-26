-- DBouncer.vhd


--//////////////////////// Button Debounceer ///////////////////////////--
-- ***********************************************************************
-- FileName: DBounce.vhd
-- FPGA: Microsemi IGLOO AGLN250V2
-- IDE: Libero v9.1.4.0 SP4 
--
-- HDL IS PROVIDED "AS IS." DIGI-KEY EXPRESSLY DISCLAIMS ANY
-- WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
-- PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
-- BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
-- DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
-- PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
-- BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
-- ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
-- DIGI-KEY ALSO DISCLAIMS ANY LIABILITY FOR PATENT OR COPYRIGHT
-- INFRINGEMENT.
--
-- Version History
-- Version 1.0 12/06/2011 Tony Storey
-- Initial Public Release
-- Small Footprint Button Debouncer


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity dbounce is
	 generic (N	: integer := 21);
    Port(
        clk, nreset : in std_logic;
        button_in   : in std_logic;
        DeBounced_out      : out std_logic
        );
end DBounce;

architecture arch of DBounce is
    signal DB_out 			 :std_logic;
    signal q_reg, q_next    : unsigned(N-1 downto 0);
    signal DFF1, DFF2       : std_logic;
    signal q_reset, q_add   : std_logic;
begin

    -- COUNTER FOR TIMING 
    q_next <= (others => '0') when q_reset = '1' else  -- resets the counter 
                    q_reg + 1 when q_add = '1' else    -- increment count if commanded
                    q_reg;  

    -- SYNCHRO REG UPDATE
    process(clk, nreset)
    begin
        if(rising_edge(clk)) then
            if(nreset = '0') then
                q_reg <= (others => '0');   -- reset counter
            else
                q_reg <= q_next;            -- update counter reg
            end if;
        end if;
    end process;

    -- Flip Flop Inputs
    process(clk, button_in)
    begin
        
        if(rising_edge(clk)) then
            if(nreset = '0') then
                DFF1 <= '0';
                DFF2 <= '0';
            else
                DFF1 <= button_in;
                DFF2 <= DFF1;
            end if;
        end if;
    end process;
    q_reset <= DFF1 xor DFF2;           -- if DFF1 and DFF2 are different q_reset <= '1';

    -- Counter Control Based on MSB of counter, q_reg
    process(clk, q_reg, DB_out)
    begin
        
        if(rising_edge(clk)) then
            q_add <= not(q_reg(N-1));        -- enables the counter whe msb is not '1'
            if(q_reg(N-1) = '1') then
                DB_out <= DFF2;
            else
                DB_out <= DB_out;
            end if;
        end if;

    end process;
	 
	 DeBounced_out <= DB_out;
end arch;
