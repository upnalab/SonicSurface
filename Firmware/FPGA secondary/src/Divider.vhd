library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Divider is
	 generic(MAX_COUNTER: integer := 1249);
    port (
        clk_in : in  STD_LOGIC;
        clk_out: out STD_LOGIC
	 );
end Divider;

architecture Behavioral of Divider is
    signal temporal: STD_LOGIC := '0';
    signal counter : integer range 0 to MAX_COUNTER := 0;
begin
    pDivider: process (clk_in) begin
			if rising_edge(clk_in) then
            if (counter = MAX_COUNTER) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temporal;
end Behavioral;