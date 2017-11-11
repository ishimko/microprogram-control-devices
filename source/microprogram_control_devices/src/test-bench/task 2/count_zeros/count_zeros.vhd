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
	"0000" & "000001", -- 000000 : LOAD 000001
	"0110" & "000101", -- 000001 : JNZ 000101
	"0000" & "000110", -- 000010 : LOAD 000110
	"0100" & "111111", -- 000011 : INC
	"0001" & "000110", -- 000100 : STORE 000110
	"0000" & "000010", -- 000101 : LOAD 000010
	"0110" & "001010", -- 000110 : JNZ 001010
	"0000" & "000110", -- 000111 : LOAD 000110
	"0100" & "111111", -- 001000 : INC
	"0001" & "000110", -- 001001 : STORE 000110
	"0000" & "000011", -- 001010 : LOAD 000011
	"0110" & "001111", -- 001011 : JNZ 001111
	"0000" & "000110", -- 001100 : LOAD 000110
	"0100" & "111111", -- 001101 : INC
	"0001" & "000110", -- 001110 : STORE 000110
	"0000" & "000100", -- 001111 : LOAD 000100
	"0110" & "010100", -- 010000 : JNZ 010100
	"0000" & "000110", -- 010001 : LOAD 000110
	"0100" & "111111", -- 010010 : INC
	"0001" & "000110", -- 010011 : STORE 000110
	"0000" & "000101", -- 010100 : LOAD 000101
	"0110" & "011001", -- 010101 : JNZ 011001
	"0000" & "000110", -- 010110 : LOAD 000110
	"0100" & "111111", -- 010111 : INC
	"0001" & "000110", -- 011000 : STORE 000110
	"1010" & "111111", -- 011001 : HALT
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
