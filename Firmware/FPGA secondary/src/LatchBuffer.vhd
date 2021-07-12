library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LatchBuffer is
    port (
        clk_in : in  STD_LOGIC;
		  signal_in : in STD_LOGIC;
        signal_out: out STD_LOGIC
	 );
end LatchBuffer;

architecture Behavioral of LatchBuffer is
	 signal s_signal_out: STD_LOGIC := '0';
begin
    pLatchBuffer: process (clk_in) begin
        if rising_edge(clk_in) then
				s_signal_out <= signal_in;
        end if;
    end process;
    
    signal_out <= s_signal_out;
end Behavioral;