library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Waves_8_32 is
   generic(NBLOCKS: integer := 24);
	
	port (
	wrclock : in std_logic;
	wr_enable : in std_logic;
	wr_buffer : in std_logic;
	wraddress : in std_logic_vector(13 downto 0);
	data_in : in std_logic_vector(7 downto 0);
	
	rdclock : in std_logic;
	rd_buffer : in std_logic;
	rdaddress : in std_logic_vector(10 downto 0);
	data_out : out std_logic_vector(63 downto 0)
	);
	
end Waves_8_32;

architecture Waves_8_32_arch of Waves_8_32 is

-- signals

signal s_wren : std_logic_vector(NBLOCKS downto 0);
signal s_wraddress : std_logic_vector(9 downto 0);
signal s_block_wr : std_logic_vector(4 downto 0);
signal s_data_in : std_logic_vector(7 downto 0);

signal s_rdaddress : std_logic_vector(7 downto 0);
signal s_block_rd : std_logic_vector(4 downto 0);
type output_type is array (0 to NBLOCKS) of std_logic_vector(31 downto 0);
signal s_outputs : output_type;

-- components	

component BRAM_8_32 IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;


begin

-- insts

insts : for i in 0 to NBLOCKS generate
	begin
		BRAM_inst : BRAM_8_32 PORT MAP 
		(
			data		   => s_data_in,
			rdaddress	=> s_rdaddress,
			rdclock		=> rdclock,
			wraddress	=> s_wraddress,
			wrclock		=> wrclock,
			wren		   => s_wren(i),
			q	 		   => s_outputs(i)
		);


end generate insts;

 -- logic
s_data_in <= data_in;


s_wraddress(1 downto 0) <= wraddress(1 downto 0);
s_wraddress(8 downto 2) <= wraddress(9 downto 3);
s_wraddress(9) <= wr_buffer;

s_block_wr(4 downto 1) <= wraddress(13 downto 10);
s_block_wr(0) <= wraddress(2);


s_rdaddress(6 downto 0) <= rdaddress(6 downto 0);
s_rdaddress(7) <= rd_buffer;

s_block_rd(4 downto 1) <= rdaddress(10 downto 7);
s_block_rd(0) <= '0';


wrenables : for i in 0 to NBLOCKS generate
	begin
		s_wren(i) <= '1' when (wr_enable = '1' and i = to_integer(unsigned(s_block_wr))) else '0';
end generate wrenables;

data_out(31 downto 0) <= s_outputs(to_integer(unsigned(s_block_rd)));
data_out(63 downto 32) <= s_outputs(to_integer(unsigned(s_block_rd)) + 1);

-- process


end Waves_8_32_arch;