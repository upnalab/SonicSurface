library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPIReader is
    port (
        clk : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
		  
        spi_cs : in STD_LOGIC;
		  spi_clock : in STD_LOGIC;
		  spi_mosi : in STD_LOGIC;
		  
		  byte_ready : out STD_LOGIC := '0';
		  q : out std_logic_vector(7 downto 0)
	 );
end SPIReader;

architecture Behavioral of SPIReader is
	signal mosi_current : std_logic;
	signal cs_current : std_logic := '1';
	signal sclk_current : std_logic := '0';
	signal sclk_prev : std_logic := '0';
	signal sByteReady : std_logic := '0';
	signal data : STD_LOGIC_VECTOR (7 downto 0);
	signal bitCounter : integer range 0 to 7 := 0;
begin
    reader: process (reset, clk) begin
        if (reset = '0') then -- async reset
            sclk_current <= '0';
            sclk_prev <= '0';
				bitCounter <= 0;
				sByteReady <= '0';
        elsif ( rising_edge(clk) ) then
				cs_current <= spi_cs;
				sclk_prev <= sclk_current;
				sclk_current <= spi_clock;
				mosi_current <= spi_mosi;
					
				if (cs_current = '0') then --chip select is enabled low
					
					--oversampled spi_clock rising edge
					if(sclk_current = '1' and sclk_prev = '0') then 
						data <= data(6 downto 0) & mosi_current; --shift one bit in	
						if (bitCounter = 7) then --byte is ready
							bitCounter <= 0;
							sByteReady <= '1';
						else --more bits to read
							sByteReady <= '0';
							bitCounter <= bitCounter + 1;
						end if;
					end if;
				else
					bitCounter <= 0;
				end if;
			end if;
				
    end process;
    
	 byte_ready <= sByteReady;
	 q <= data;
	 
end Behavioral;