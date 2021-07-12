library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AllChannels is
   generic(NBLOCKS: integer := 256);
	
	port (
		clk8 : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		chgClock : in  STD_LOGIC;
		counter : in std_logic_vector(6 downto 0);
		pulse_length : in STD_LOGIC_VECTOR (7 downto 0); -- 0 to 7
		
		swap : in  STD_LOGIC := '0';
		phase : in std_logic_vector(7 downto 0);
		set : in  STD_LOGIC := '0';
		address : in std_logic_vector(7 downto 0); --256 different address for the pulse / duty blocks

		--data_out : out std_logic_vector((NBLOCKS/8-1) downto 0)
		data_out : out std_logic_vector(31 downto 0)
		--data_demux : out std_logic_vector(NBLOCKS-1 downto 0)
	);
	
end AllChannels;

architecture Behavioral of AllChannels is

-- signals

signal s_set : STD_LOGIC_VECTOR((NBLOCKS-1) downto 0);
signal s_enabled : STD_LOGIC_VECTOR((NBLOCKS-1) downto 0) := (others => '1');
signal s_pulseToMux : STD_LOGIC_VECTOR((NBLOCKS-1) downto 0);

--components

component PhaseLine IS
	PORT
	(
		  clk : in  STD_LOGIC;
		  set : in  STD_LOGIC := '0';
		  swap : in  STD_LOGIC := '0';
		  phase : in STD_LOGIC_VECTOR (4 downto 0); 
		  counter : in STD_LOGIC_VECTOR (3 downto 0);
		  enabled : in  STD_LOGIC := '0';
		  
		  pulse : out STD_LOGIC := '0'
	);
END component;


component Mux8 IS
	PORT
	(
		  clk : in  STD_LOGIC;
		  data_in : in STD_LOGIC_VECTOR (7 downto 0);
		  sel : in STD_LOGIC_VECTOR (2 downto 0);
		  
		  data_out : out STD_LOGIC
	);
END component;

begin

-- insts

insts : for i in 0 to (NBLOCKS-1) generate
	begin
		PhaseLine_inst : PhaseLine PORT MAP 
		(
			clk => clk,
		   set => s_set(i),
			swap => swap,
			phase => phase(5 downto 1),
			counter => counter(6 downto 3),
			enabled => s_enabled(i),
		   pulse => s_pulseToMux(i)
		);

end generate insts;


muxes : for i in 0 to (NBLOCKS/8-1) generate
	begin
		Mux8_inst : Mux8 PORT MAP 
		(
			clk => clk8,
		   data_in => s_pulseToMux( i*8+7 downto i*8 ),
			sel => counter(2 downto 0),
		   data_out => data_out(i)
		);

end generate muxes;

AllChannels: process (chgClock) begin 
        if (rising_edge(chgClock)) then
				s_enabled( to_integer(unsigned(pulse_length)) ) <= NOT s_enabled( to_integer(unsigned(pulse_length)) );
		  end if;
 end process;
 
phase_to_duty : for i in 0 to (NBLOCKS-1) generate
begin
		s_set(i) <= '1' when set = '1' and i = to_integer(unsigned(address)) else '0';
		
		--data_demux(i) <= s_pulseToMux(i);
end generate phase_to_duty;


end Behavioral;