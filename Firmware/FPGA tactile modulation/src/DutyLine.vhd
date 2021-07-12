library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity DutyLine is
    port (
		  clk : in  STD_LOGIC;
		  pulse_in : in STD_LOGIC := '0';
		  duty_in : in STD_LOGIC_VECTOR (4 downto 0); -- up to 31
		  pulse_out : out STD_LOGIC := '0'
	 );
end DutyLine;

architecture Behavioral of DutyLine is
	 signal s_BitCounter : integer range 0 to 31 := 0;
	 signal s_prevSet : std_logic := '1';

begin
    DutyLine: process (clk) begin 
        if (rising_edge(clk)) then
				s_prevSet <= pulse_in;
				if (pulse_in = '1' AND s_prevSet = '0') then
					s_BitCounter <= to_integer(unsigned(duty_in));
				end if;
			  
			  if (s_BitCounter > 0) then 
					pulse_out <= '1';
					s_BitCounter <= s_BitCounter - 1;
			  else
					pulse_out <= '0';
			  end if;
			  
		  end if;

    end process;
    
end Behavioral;
