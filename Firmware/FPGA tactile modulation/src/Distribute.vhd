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
		  data_out: out STD_LOGIC_VECTOR (7 downto 0); 
		  address : out std_logic_vector(7 downto 0); --256 addresses
		  
		  ampModStep : out std_logic_vector(4 downto 0); --256 addresses
		  
		  debug_swap : out STD_LOGIC := '0'
	 );
end Distribute;

architecture Behavioral of Distribute is

type T_PHASE_CORRECTION is array (0 to 255) of integer range 0 to 32;
	constant PHASE_CORRECTION : T_PHASE_CORRECTION := (0,14,15,31,15,15,0,0,16,1,1,29,15,15,17,1,31,17,15,31,30,31,13,30,0,18,18,30,15,14,31,14,30,15,0,0,15,15,1,0,1,17,13,29,15,0,0,0,0,16,31,30,31,0,31,0,16,0,16,15,30,14,17,0,14,31,30,13,30,14,14,30,15,1,0,13,31,31,31,31,14,31,1,29,31,0,15,14,16,0,0,31,0,17,15,14,0,15,30,16,0,17,0,17,17,15,0,14,0,16,2,0,18,0,1,0,15,18,1,17,18,0,16,16,17,14,1,1,14,15,1,30,17,14,2,16,31,3,17,14,16,17,1,0,1,30,0,30,0,14,15,15,13,30,31,15,31,0,0,0,0,31,31,14,31,31,16,0,18,17,1,0,16,31,30,30,16,0,18,14,0,16,14,2,16,19,1,30,31,16,15,1,16,16,3,30,15,31,31,0,0,1,17,31,2,16,16,0,0,13,16,14,16,14,31,13,13,31,15,15,15,16,30,15,0,16,31,31,1,0,15,18,0,31,1,15,1,0,0,14,15,1,16,0,15,18,30,1,19,2,16,30,15,15,1,1);
		--0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	 signal s_ByteCounter : integer range 0 to 256 := 0;
	  
	 signal s_data_out : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	 signal s_address : std_logic_vector(7 downto 0) := (others => '0');
	 signal s_swap_out :  STD_LOGIC := '0';
	 signal s_set_out : STD_LOGIC := '0';
	 signal s_ampModStep : std_logic_vector(4 downto 0) := "01010";
	 signal s_debug_swap : STD_LOGIC := '0';
begin
    Distribute: process (clk) begin
        if (rising_edge(clk)) then
				if (byte_in = '1') then --a byte of data is ready
					
					if (q_in = "11111110") then --254 is start phases
						s_ByteCounter <= 0;
						s_swap_out <= '0';
						s_set_out <= '0';
					elsif (q_in = "11111101") then --253 is swap
						s_debug_swap <= not s_debug_swap;
						s_set_out <= '0';
						s_swap_out <= '1';
						s_ByteCounter <= 0;
				   elsif (q_in(7 downto 5) = "101") then -- "101XXXXX" is step set
						s_ampModStep <= q_in(4 downto 0);
					else -- any other byte is for the delay lines. 
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
 data_out <= s_data_out;
 address <= s_address;
 swap_out <= s_swap_out;
 set_out <= s_set_out;
 ampModStep <= s_ampModStep;
 
end Behavioral;
