library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Counter is
	 generic(COUNTER_BITS: integer := 8);
    port (
        clk_in : in  STD_LOGIC;
        clk_out: out STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0)
	 );
end Counter;

architecture Behavioral of Counter is
    signal sCounter : STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0) := (others => '0');
begin
    pCounter: process (clk_in) begin
        if rising_edge(clk_in) then
				sCounter <= sCounter + 1;
        end if;
    end process;
    
    clk_out <= sCounter;
end Behavioral;