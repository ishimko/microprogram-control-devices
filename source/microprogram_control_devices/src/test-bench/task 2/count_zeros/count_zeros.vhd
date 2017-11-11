library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use work.types.all;
use work.parameters.all;

entity count_zeros is
end count_zeros;

architecture beh of count_zeros is
	signal CLK: std_logic := '0';
	signal RST: std_logic;
	signal start: std_logic;
	signal stop: std_logic;
	
	constant ROM_state: TROM(0 to 2**default_ROM_address_size-1)(default_ROM_word_size-1 downto 0) :=(
	--	OP_CODE | RAM ADR |  N Hex  | N DEC | instruction
	"0000" & "000001", -- 000000 | 00 	| LOAD a[0]
	"0110" & "000101", -- 000001 | 01	| JNZ m1
	"0000" & "000110", -- 000010 | 02	| LOAD res
	"0100" & "000000", -- 000011 | 03	| ADD 1
	"0001" & "000110", -- 000100 | 04	| STORE res
	"0000" & "000010", -- 000101 | 05 	| LOAD a[1] : m1
	"0110" & "001010", -- 000110 | 06	| JNZ m2
	"0000" & "000110", -- 000111 | 07	| LOAD res
	"0100" & "000000", -- 001000 | 08	| ADD 1
	"0001" & "000110", -- 001001 | 09	| STORE res
	"0000" & "000011", -- 001010 | 10 	| LOAD a[2] : m2
	"0110" & "001111", -- 001011 | 11	| JNZ m3
	"0000" & "000110", -- 001100 | 12	| LOAD res
	"0100" & "000000", -- 001101 | 13	| ADD 1
	"0001" & "000110", -- 001110 | 14	| STORE res
	"0000" & "000100", -- 001111 | 15 	| LOAD a[3] : m3
	"0110" & "010100", -- 010000 | 16	| JNZ m4
	"0000" & "000110", -- 010001 | 17	| LOAD res
	"0100" & "000000", -- 010010 | 18	| ADD 1
	"0001" & "000110", -- 010011 | 19	| STORE res
	"0000" & "000101", -- 010100 | 20 	| LOAD a[4] : m4
	"0110" & "011001", -- 010101 | 21	| JNZ m5
	"0000" & "000110", -- 010110 | 22	| LOAD res
	"0100" & "000000", -- 010111 | 23	| ADD 1
	"0001" & "000110", -- 011000 | 24	| STORE res
	"1010" & "000000", -- 011001 | 25 	| HALT : m5
	others => "1010" & "000000"
	);						   
	
	constant RAM_initial_state: TRAM(0 to 2**default_RAM_address_size-1)(default_RAM_word_size-1 downto 0) := (
	"00000101",	-- 5 | 000000 | array length
	"00000000", -- 0 | 000001 | a[0]
	"00000001", -- 1 | 000010 | a[1]
	"00000000", -- 0 | 000011 | a[2]
	"00000100", -- 4 | 000100 | a[3]
	"00000000", -- 5 | 000101 | a[4]
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
