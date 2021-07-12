library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PulseExpander is
	 generic(OUTPUT_LENGTH_CYCLES: integer := 8);
    port (
        clk_in : in  STD_LOGIC;
		  pulse_in : in STD_LOGIC;
        pulse_out: out STD_LOGIC
	 );
end PulseExpander;

architecture Behavioral of PulseExpander is
    signal sCounter : integer range 0 to OUTPUT_LENGTH_CYCLES := 0;
	 signal s_pulse_out: STD_LOGIC := '0';
begin
    pPulseExpander: process (clk_in) begin
        if rising_edge(clk_in) then
				if (pulse_in = '1') then
					sCounter <= OUTPUT_LENGTH_CYCLES;
				end if;
		  
				if (sCounter = 0) then
					s_pulse_out <= '0';
				else
					s_pulse_out <= '1';
					sCounter <= sCounter - 1;
				end if;
        end if;
    end process;
    
    pulse_out <= s_pulse_out;
end Behavioral;