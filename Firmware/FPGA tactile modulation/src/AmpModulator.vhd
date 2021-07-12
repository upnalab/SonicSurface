library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;


entity AmpModulator is
    port (
		  clk : in  STD_LOGIC;
		  steps : in STD_LOGIC_VECTOR (4 downto 0); -- 0 to 7
		  amp : out STD_LOGIC_VECTOR (7 downto 0); -- 0 to 7
		  chgClock : out STD_LOGIC -- 0 to 7
	 );
end AmpModulator;

architecture Behavioral of AmpModulator is
	signal s_amp : STD_LOGIC_VECTOR (7 downto 0):= (others => '1');
	signal s_counter : integer range 0 to 255 := 0;
	signal s_stepCounter : integer range 0 to 31 := 0;
	signal s_chgClock : STD_LOGIC := '0';
begin
    AmpModulator: process (clk) begin 
	 if (rising_edge(clk)) then
		if (s_stepCounter = to_integer(unsigned(steps)) ) then 
			s_stepCounter <= 0;
			s_chgClock <= '1';
			s_amp <= std_logic_vector(to_unsigned(s_counter, 8));
			if (s_counter = 255) then
				s_counter <= 0;
			else
				s_counter <= s_counter + 1;
			end if;
		else
			s_stepCounter <= s_stepCounter + 1;
			s_chgClock <= '0';
		end if;
		end if;
 end process;

 amp <= s_amp;
chgClock <= s_chgClock;

end Behavioral;
