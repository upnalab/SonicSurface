library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- use IEEE.std_logic_unsigned.all;
-- use IEEE.std_logic_signed.all;


entity stateGenerator is
    port (

	-- ports
	
	clk : in std_logic;
	switch : in std_logic;

	state_out : out std_logic := '0'
	
	);
end stateGenerator;

architecture stateGenerator_arch of stateGenerator is

-- signals

signal state : std_logic := '0';
signal switch_current : std_logic := '1';
signal switch_prev : std_logic := '1';

-- components



begin

-- insts


	
-- logic

state_out <= state;

-- process

process(clk)
	begin
		if(rising_edge(clk)) then
			switch_current <= switch;
			switch_prev <= switch_current;
			
			-- oversampled falling edge
			if(switch_current = '0' and switch_prev = '1') then 
				state <= not state; --just reverse the status
			end if;
		end if;
end process;

end stateGenerator_arch;