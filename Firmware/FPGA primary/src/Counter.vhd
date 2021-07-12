library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Counter is
	 generic(COUNTER_BITS: integer := 8);
    port (
        clk_in : in  STD_LOGIC;
		  sync_reset : in STD_LOGIC;
        clk_out: out STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0)
	 );
end Counter;

architecture Behavioral of Counter is
    signal sCounter : STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0) := (others => '0');
	 signal prev_res : STD_LOGIC := '0';
begin
    pCounter: process (clk_in) begin
        if rising_edge(clk_in) then
				prev_res <= sync_reset;
				if (sync_reset = '1' and prev_res = '0') then
					sCounter <= (others => '0');
				else
					sCounter <= sCounter + 1;
				end if;
        end if;
    end process;
    
    clk_out <= sCounter;
end Behavioral;