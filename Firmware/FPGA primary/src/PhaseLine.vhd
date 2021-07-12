library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;


entity PhaseLine is
    port (
		  clk : in  STD_LOGIC;
		  set : in  STD_LOGIC := '0';
		  swap : in  STD_LOGIC := '0';
		  phase : in STD_LOGIC_VECTOR (5 downto 0); -- We need one more bit because anything >=32 is for off
		  counter : in STD_LOGIC_VECTOR (4 downto 0); -- 0 to 31
		  
		  pulse : out STD_LOGIC := '0'
	 );
end PhaseLine;

architecture Behavioral of PhaseLine is
	 signal s_counter : integer range 0 to 31 := 0;
	 signal s_phaseCurrent : integer range 0 to 63 := 0;
	 signal s_phasePrev : integer range 0 to 63 := 0;
	 signal s_prevSet : std_logic := '0';
	 signal s_prevSwap : std_logic := '0';
begin
    PhaseLine: process (clk) begin 
        if (rising_edge(clk)) then
				s_prevSet <= set;
				s_prevSwap <= swap;
				
				if (set = '1' AND s_prevSet = '0') then
					s_phasePrev <= to_integer(unsigned(phase));
				end if;
				
				if (swap = '1' AND s_prevSwap = '0') then
					s_phaseCurrent <= s_phasePrev;
					s_phasePrev <= s_phaseCurrent;
				end if;
			  
			  if (s_phaseCurrent = to_integer(unsigned(counter)) ) then 
					s_counter <= 16;
			  end if;
			  
			  if (s_counter = 0) then
					pulse <= '0';
			  else
					s_counter <= s_counter - 1;
					pulse <= '1';
			  end if;

		  end if;
 end process;

end Behavioral;
