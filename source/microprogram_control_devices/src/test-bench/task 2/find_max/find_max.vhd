library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use work.types.all;
use work.parameters.all;

entity find_max is
end find_max;

architecture beh of find_max is
	signal CLK: std_logic := '0';
	signal RST: std_logic;
	signal start: std_logic;
	signal stop: std_logic;
	
	constant ROM_state: TROM(0 to 2**default_ROM_address_size-1)(default_ROM_word_size-1 downto 0) :=(
	"0000" & "000001", -- 000000 : LOAD 000001
	"0001" & "000110", -- 000001 : STORE 000110
	"0011" & "000010", -- 000010 : SUB 000010
	"1000" & "000110", -- 000011 : JNSB 000110
	"0000" & "000010", -- 000100 : LOAD 000010
	"0001" & "000110", -- 000101 : STORE 000110
	"0000" & "000110", -- 000110 : LOAD 000110
	"0011" & "000011", -- 000111 : SUB 000011
	"1000" & "001011", -- 001000 : JNSB 001011
	"0000" & "000011", -- 001001 : LOAD 000011
	"0001" & "000110", -- 001010 : STORE 000110
	"0000" & "000110", -- 001011 : LOAD 000110
	"0011" & "000100", -- 001100 : SUB 000100
	"1000" & "010000", -- 001101 : JNSB 010000
	"0000" & "000100", -- 001110 : LOAD 000100
	"0001" & "000110", -- 001111 : STORE 000110
	"0000" & "000110", -- 010000 : LOAD 000110
	"0011" & "000101", -- 010001 : SUB 000101
	"1000" & "010101", -- 010010 : JNSB 010101
	"0000" & "000101", -- 010011 : LOAD 000101
	"0001" & "000110", -- 010100 : STORE 000110
	"0000" & "000110", -- 010101 : LOAD 000110
	"1010" & "000000", -- 010110 : HALT
	others => "1010" & "000000"
	);						   
	
	constant RAM_initial_state: TRAM(0 to 2**default_RAM_address_size-1)(default_RAM_word_size-1 downto 0) := (
	"00000101",	-- 5 | 000000 | array length
	"00000011", -- 3 | 000001 | a[0]
	"00000001", -- 1 | 000010 | a[1]
	"00000010", -- 2 | 000011 | a[2]
	"00000100", -- 4 | 000100 | a[3]
	"00000101", -- 5 | 000101 | a[4]
	"00000000", -- 0 | 000110 |	result	
	others => "00000000"	
	);
	
	constant clock_period: time := 10 ns;
begin
	UDEVICE: entity ControllerDevice(beh)
	generic map(
		ROM_word_size => default_ROM_word_size,
		ROM_address_size => default_ROM_address_size,
		ROM_state => ROM_state,
		RAM_word_size => default_RAM_word_size,
		RAM_address_size => default_RAM_address_size,
		RAM_initial_state => RAM_initial_state
		)										  
	port map(
		CLK => CLK,
		RST => RST,
		start => start,
		stop => stop
		);
	
	clk <= not clk after clock_period / 2;
	
	stimulate: process
	begin
		rst <= '1';
		wait for clock_period;
		rst <= '0';
		start <= '1';
		wait;
	end process;
	
end beh;
