library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SwapField is
   port (
        clk_in : in  STD_LOGIC;
		  toogle : in  STD_LOGIC;
        swap_multi_out: out STD_LOGIC := '0';
		  swap_debug : out STD_LOGIC := '0'
	 );
end SwapField;

architecture Behavioral of SwapField is
	constant PERIODS_A : STD_LOGIC_VECTOR (7 downto 0) := "01100100"; --100
	constant PERIODS_B : STD_LOGIC_VECTOR (7 downto 0) := "01100100"; --100
	
    signal sCounter : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	 signal countingA : STD_LOGIC := '1';
	 signal prevToogle : STD_LOGIC := '0';	
	 signal enabled : STD_LOGIC := '0';
begin
    pSwapField: process (clk_in) begin
        if rising_edge(clk_in) then

		  prevToogle <= toogle;
				
				if (toogle = '1' and prevToogle = '0') then
					enabled <= '1';
					countingA <= '1';
					sCounter <= PERIODS_A;
				elsif (toogle = '0' and prevToogle = '1') then
					enabled <= '0';
				end if;
				
				
				if (enabled = '1') then
					if (sCounter = "00000000") then
						if (countingA = '1') then
							sCounter <= PERIODS_B;
						else
							sCounter <= PERIODS_A;
						end if;
						countingA <= not countingA;
						swap_multi_out <= '1';
					else
						sCounter <= sCounter - 1;
						swap_multi_out <= '0';
					end if;	
				else
					swap_multi_out <= '0';
				end if;
				
        end if;
    end process;
	 
	swap_debug <=  enabled;
end Behavioral;