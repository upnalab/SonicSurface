library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Distribute is
    port (
		  CLK : in  STD_LOGIC;
		  
		  byte_in : in  STD_LOGIC := '0';
		  q_in : in STD_LOGIC_VECTOR (7 downto 0);
		  swap_out : out  STD_LOGIC := '0';
		  set_out : out STD_LOGIC := '0';
		  multiplex_out : out STD_LOGIC := '0';
		  data_out: out STD_LOGIC_VECTOR (7 downto 0); 
		  address : out std_logic_vector(7 downto 0); --256 addresses
		  
		  debug_swap : out STD_LOGIC := '0';
		  debug_reset : out STD_LOGIC := '0';
		  debug_onShiftClocks : out STD_LOGIC := '1'
	 );
end Distribute;

architecture Behavioral of Distribute is

type T_PHASE_CORRECTION is array (0 to 255) of integer range 0 to 255;
	constant PHASE_CORRECTION : T_PHASE_CORRECTION := (29,31,13,9,29,13,13,30,30,29,13,15,17,15,29,13,13,29,30,14,27,13,29,30,29,27,30,29,12,13,31,31,13,29,13,26,13,30,15,26,31,28,13,29,14,13,17,13,27,13,1,30,30,15,30,30,14,14,30,10,15,14,28,0,30,11,11,12,14,12,14,26,15,26,29,29,12,31,15,29,15,31,13,28,30,30,28,14,16,14,14,25,27,12,13,29,12,10,16,29,13,9,29,29,13,31,28,12,13,30,15,27,13,30,29,13,14,13,29,13,13,30,12,11,15,29,15,30,31,13,14,7,13,30,30,30,12,12,28,29,29,29,0,0,13,10,27,28,31,28,31,0,14,12,28,27,30,29,14,15,16,12,29,11,29,30,29,12,31,14,28,18,29,0,12,16,11,0,28,28,13,31,28,29,31,29,14,30,29,30,15,28,16,16,29,10,12,12,13,29,29,27,16,29,28,14,30,29,28,31,13,28,27,31,30,14,29,15,30,27,30,11,0,29,10,30,14,12,28,30,14,13,13,30,16,12,0,30,30,29,15,27,27,13,14,15,31,27,12,14,30,29,30,14,15,26);
		--0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
	 signal s_boardEnable : STD_LOGIC := '1';
	 signal s_ByteCounter : integer range 0 to 256 := 0;
	  
	 signal s_data_out : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	 signal s_address : std_logic_vector(7 downto 0) := (others => '0');
	 signal s_swap_out :  STD_LOGIC := '0';
	 signal s_set_out : STD_LOGIC := '0';
	 
	 signal s_debug_swap : STD_LOGIC := '0';
	 signal s_debug_onShiftClocks : STD_LOGIC := '1';
begin
    Distribute: process (clk) begin
        if (rising_edge(clk)) then
				if (byte_in = '1') then --a byte of data is ready
					
					if (q_in = "11111110" AND s_boardEnable = '1') then --254 is start phases
						s_ByteCounter <= 0;
						s_swap_out <= '0';
						s_set_out <= '0';
					elsif (q_in = "11111101") then --253 is swap
						s_debug_swap <= not s_debug_swap;
						s_set_out <= '0';
						s_swap_out <= '1';
						s_ByteCounter <= 0;
						
					elsif (q_in = "10010110") then --150 is switch off clocks
						s_debug_onShiftClocks <= '0';
					elsif (q_in = "10010111") then --151 is switch on clocks
						s_debug_onShiftClocks <= '1';
						
					elsif (q_in = "11000000") then --192 board primary
						s_boardEnable <= '0';
					elsif (q_in = "11000001") then --193 board secondary
						s_boardEnable <= '1';
						
					elsif (s_boardEnable = '1') then-- any other byte is for the delay lines. send only if the board is enabled
						--s_data_out <= q_in;
						s_address <= std_logic_vector(to_unsigned(s_ByteCounter, 8));
						s_swap_out <= '0';
						s_set_out <= '1';
						s_ByteCounter <= s_ByteCounter + 1;
						
						if (q_in = "00100000") then
							s_data_out <= q_in; -- a phase of 32 represents "off" so no phase correction
						else
							s_data_out <= std_logic_vector( to_unsigned( to_integer(unsigned(q_in)) + PHASE_CORRECTION(s_ByteCounter), 8 ) ) and "00011111";
						end if;
						
					end if;
				else
					s_swap_out <= '0';
					s_set_out <= '0';
				end if;
				
				
		  end if;
 end process;
 debug_swap <= s_debug_swap;
 debug_reset <= s_boardEnable;
 debug_onShiftClocks <= s_debug_onShiftClocks;
 
 data_out <= s_data_out;
 address <= s_address;
 swap_out <= s_swap_out;
 set_out <= s_set_out;
 
end Behavioral;
