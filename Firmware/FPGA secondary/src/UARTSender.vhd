library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UARTSender is
	 -- if clk is 50MHz and uart is working at 2Mhz then CLK_DIV is 50/2 = 25
	 generic(CLK_DIV: integer := 25);
    port (
        clk : in  STD_LOGIC;
		  reset  : in  STD_LOGIC;
		  
		  ready : out STD_LOGIC := '0';
		  data_in : in STD_LOGIC_VECTOR (7 downto 0);
		  send : in STD_LOGIC := '0';
		  
		  out_wire : out  STD_LOGIC
	 );
end UARTSender;

architecture Behavioral of UARTSender is
    signal sampleCounter : integer range 0 to CLK_DIV := 0;
	 signal bitCounter : integer range 0 to 9 := 0;
	 signal data : STD_LOGIC_VECTOR (9 downto 0) := "1000000000"; --plus start and end bit
	 signal sReady : std_logic := '0';
	 
	 TYPE State_type IS (Idle, Sending);
	 SIGNAL state : State_Type := Idle;
	
begin
    pUARTSender: process (reset, clk) begin
        if (reset = '0') then -- async reset
            state <= Idle;
				sReady <= '1';
        elsif ( rising_edge(clk) ) then
				case state is
					when Idle =>
						out_wire <= '1';
						if (send = '1') then
							state <= Sending;
							sReady <= '0';
							data(1 downto 8) <= data_in(0 downto 7);
							sampleCounter <= 0;
							bitCounter <= 0;
						end if;
					when Sending =>
						if (sampleCounter = CLK_DIV) then
							if (bitCounter = 10) then
								sReady <= '1';
								state <= Idle;
							else
								out_wire <= data( bitCounter );
								sampleCounter <= 0;
								bitCounter <= bitCounter + 1;
							end if;
								
						else
							sampleCounter <= sampleCounter + 1;
						end if;
						
				end case;
			end if;
    end process;
    
	 ready <= sReady;
	 
end Behavioral;