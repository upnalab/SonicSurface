library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Mux8 is
	 port (
        clk : in  STD_LOGIC;
		  data_in : in STD_LOGIC_VECTOR (7 downto 0);
		  sel : in STD_LOGIC_VECTOR (2 downto 0);
		  
		  data_out : out STD_LOGIC
	 );
end Mux8;

architecture Behavioral of Mux8 is
    signal s_data_out: STD_LOGIC := '0';
begin
    pMux: process (clk) begin
			if rising_edge(clk) then
				s_data_out <= data_in( to_integer(unsigned(sel) ) );
        end if;
    end process;
    data_out <= s_data_out;
end Behavioral;