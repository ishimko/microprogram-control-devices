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
	--  OP_CODE | RAM ADR |  N Hex   | N DEC| instruction
	"0000" & "000001", -- 000000 | 00 	|LOAD a[0]
	"0001" & "000110", -- 000001 | 01 	|STORE res
	"0011" & "000010", -- 000010 | 02 	|SUB a[1]
	"1000" & "000110", -- 000011 | 03 	|JNSB m1
	"0000" & "000010", -- 000100 | 04 	|LOAD a[1]
	"0001" & "000110", -- 000101 | 05 	|STORE res
	"0000" & "000110", -- 000110 | 06 	|LOAD res	: m1
	"0011" & "000011", -- 000111 | 07 	|SUB a[2]
	"1000" & "001011", -- 001000 | 08 	|JNSB m2
	"0000" & "000011", -- 001001 | 09 	|LOAD a[2]
	"0001" & "000110", -- 001010 | 10 	|STORE res
	"0000" & "000110", -- 001011 | 11 	|LOAD res	: m2
	"0011" & "000100", -- 001100 | 12 	|SUB a[3]
	"1000" & "010000", -- 001101 | 13 	|JNSB m3
	"0000" & "000100", -- 001110 | 14 	|LOAD a[3]
	"0001" & "000110", -- 001111 | 15 	|STORE res
	"0000" & "000110", -- 010000 | 16 	|LOAD res	: m3
	"0011" & "000101", -- 010001 | 17 	|SUB a[4]
	"1000" & "010101", -- 010010 | 18 	|JNSB m4
	"0000" & "000101", -- 010011 | 19 	|LOAD a[4]
	"0001" & "000110", -- 010100 | 20 	|STORE res
	"0000" & "000110", -- 010101 | 21 	|LOAD res	: m4
	"1010" & "000000", -- 010110 | 22 	|HALT
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
		
	clk <= not clk after clock_period;
	
	stimulate: process
	begin
		rst <= '1';
		wait for clock_period;
		rst <= '0';
		start <= '1';
		wait;
	end process;
	
end beh;
