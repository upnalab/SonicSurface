library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity expander64 is
    port (
        input : in  STD_LOGIC;
        output : out std_logic_vector(63 downto 0)
	 );
end expander64;

architecture Behavioral of expander64 is
begin    
    output <= (others => input);
end Behavioral;