library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Distributor is
    port (
		  byte_ready : in STD_LOGIC := '0';
		  byte_in : in std_logic_vector(7 downto 0);
		  reset : in STD_LOGIC := '1';
		  
		  led0 : out STD_LOGIC;
		  led1 : out STD_LOGIC;
		  led2 : out STD_LOGIC;
		  led3 : out STD_LOGIC
	 );
end Distributor;

architecture Behavioral of Distributor is
	signal sled0: STD_LOGIC := '0';
	signal sled1: STD_LOGIC := '0';
	signal sled2: STD_LOGIC := '0';
	signal sled3: STD_LOGIC := '0';
begin
    Distributor: process (byte_ready, reset) begin
		if (reset = '0')then
			sled0 <= '0';
			sled1 <= '0';
			sled2 <= '0';
			sled3 <= '0';
		elsif ( rising_edge(byte_ready)  ) then
			case byte_in is
					when "01101000" => 	
						sled0 <= not sled0;
					when "10110100" =>
						sled1 <= not sled1;
					when "00011000" => 	
						sled0 <= '1';
						sled1 <= '1';
					when "00100010" => 	
						sled0 <= '0';
						sled1 <= '0';
					when others =>
						sled0 <= '1';
						sled1 <= '0';
				end case;
		end if;
				
    end process;
    
	 led0 <= sled0;
	 led1 <= sled1;
	 led2 <= sled2;
	 led3 <= sled3;
end Behavioral;