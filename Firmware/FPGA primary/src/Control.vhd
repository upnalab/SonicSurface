library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control is
   generic(NBLOCKS: integer := 64);
	
	port (
	phasein : in std_logic_vector(7 downto 0);
	set_in : in  STD_LOGIC := '0';
	duty_in : in STD_LOGIC_VECTOR (7 downto 0); 
	CLK : in  STD_LOGIC;
   reset  : in  STD_LOGIC := '1';
	address : in std_logic_vector(5 downto 0); --64 different address for the pulse / duty blocks
	latch : in  STD_LOGIC := '0';
	data_out : out std_logic_vector((NBLOCKS-1) downto 0)
	);
	
end Control;

architecture Behavioral of Control is

-- signals

signal s_pulseLink : STD_LOGIC_VECTOR((NBLOCKS-1) downto 0);
signal s_Latch : STD_LOGIC_VECTOR((NBLOCKS-1) downto 0);

--components

component PhaseLine IS
	PORT
	(
		  CLK : in  STD_LOGIC;
		  reset  : in  STD_LOGIC := '1';
		  set_in : in  STD_LOGIC := '0';
		  latch : in  STD_LOGIC := '0';
		  phasein : in STD_LOGIC_VECTOR (7 downto 0);
		  pulse_out : out STD_LOGIC := '0'
	);
END component;

component DutyLine IS
	PORT
	(
		  CLK : in  STD_LOGIC;
		  reset  : in  STD_LOGIC := '1';
		  pulse_in : in STD_LOGIC := '0';
		  duty_in : in STD_LOGIC_VECTOR (7 downto 0);  --From Arduino - 8 inputs pins connected into the FPGA
		  duty_out : out STD_LOGIC := '0'
	);
END component;


begin

-- insts

insts : for i in 0 to (NBLOCKS-1) generate
	begin
		PhaseLine_inst : PhaseLine PORT MAP 
		(
			CLK => CLK,
		   reset => reset,
		   set_in => set_in,
			latch => s_Latch(i),
		   phasein => phasein,
		   pulse_out => s_pulseLink(i)
		);
		
		DutyLine_inst : DutyLine PORT MAP 
		(
		   CLK => CLK,
		   reset => reset,
		   pulse_in  => s_pulseLink(i),
		   duty_in => duty_in,
			duty_out => data_out(i)
		);

end generate insts;



phase_to_duty : for i in 0 to (NBLOCKS-1) generate
begin
		s_Latch(i) <= '1' when ((latch = '1') and i = to_integer(unsigned(address))) else '0';
end generate phase_to_duty;


end Behavioral;