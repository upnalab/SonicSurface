library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Demux is
	generic(CHANNEL: integer := 0);
	 port (
        clk : in  STD_LOGIC;
		  data_in : in STD_LOGIC;
		  counter : in STD_LOGIC_VECTOR (2 downto 0);
		  
		  data_out : out STD_LOGIC
	 );
end Demux;

architecture Behavioral of Demux is
    signal temporal: STD_LOGIC := '0';
begin
    pDemux: process (clk) begin
			if rising_edge(clk) then
				if (CHANNEL = to_integer(unsigned(counter) )) then
					temporal <= data_in;
				end if;
        end if;
    end process;
    data_out <= temporal;
end Behavioral;