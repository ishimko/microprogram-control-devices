library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use work.types.all;
use work.parameters.all;

entity sort is
end sort;

architecture beh of sort is
	signal CLK: std_logic := '0';
	signal RST: std_logic;
	signal start: std_logic;
	signal stop: std_logic;
	
	constant ROM_state: TROM(0 to 2**default_ROM_address_size-1)(default_ROM_word_size-1 downto 0) :=(
	--	OP_CODE | RAM ADR |  N Bin  | N DEC | instruction
	"0000" & "000000", -- 000000 | 00 | LOAD array length
	"0101" & "111111", -- 000001 | 01 | DEC 
	"0001" & "000011", -- 000010 | 02 | STORE loop main
	"0000" & "000011", -- 000011 | 03 | LOAD loop main; m:MAIN_LOOP
	"0001" & "000100", -- 000100 | 04 | STORE loop inner
	"0000" & "000101", -- 000101 | 05 | LOAD array base
	"0101" & "111111", -- 000110 | 06 | DEC 
	"0001" & "100001", -- 000111 | 07 | STORE to FSR
	"0000" & "100001", -- 001000 | 08 | LOAD FSR; m:INNER_LOOP
	"0100" & "111111", -- 001001 | 09 | INC 
	"0001" & "100001", -- 001010 | 0a | STORE to FSR
	"0000" & "100000", -- 001011 | 0b | LOAD from INDF
	"0001" & "000001", -- 001100 | 0c | STORE previous
	"0000" & "100001", -- 001101 | 0d | LOAD FSR
	"0100" & "111111", -- 001110 | 0e | INC 
	"0001" & "100001", -- 001111 | 0f | STORE to FSR
	"0000" & "100000", -- 010000 | 10 | LOAD from INDF
	"0011" & "000001", -- 010001 | 11 | SUB previous
	"1000" & "011111", -- 010010 | 12 | JNSB GOTO SKIP
	"0000" & "100000", -- 010011 | 13 | LOAD from INDF
	"0001" & "000010", -- 010100 | 14 | STORE tmp
	"0000" & "000001", -- 010101 | 15 | LOAD previous
	"0001" & "100000", -- 010110 | 16 | STORE to INDF
	"0000" & "100001", -- 010111 | 17 | LOAD FSR
	"0101" & "111111", -- 011000 | 18 | DEC 
	"0001" & "100001", -- 011001 | 19 | STORE to FSR
	"0000" & "000010", -- 011010 | 1a | LOAD tmp
	"0001" & "100000", -- 011011 | 1b | STORE to INDF
	"0000" & "100001", -- 011100 | 1c | LOAD FSR
	"0100" & "111111", -- 011101 | 1d | INC 
	"0001" & "100001", -- 011110 | 1e | STORE to FSR
	"0000" & "100001", -- 011111 | 1f | LOAD FSR; m:SKIP
	"0101" & "111111", -- 100000 | 20 | DEC 
	"0001" & "100001", -- 100001 | 21 | STORE to FSR
	"0000" & "000100", -- 100010 | 22 | LOAD loop inner
	"0101" & "111111", -- 100011 | 23 | DEC 
	"0001" & "000100", -- 100100 | 24 | STORE loop inner
	"0110" & "001000", -- 100101 | 25 | JNZ GOTO INNER_LOOP
	"0000" & "000011", -- 100110 | 26 | LOAD loop main
	"0101" & "111111", -- 100111 | 27 | DEC 
	"0001" & "000011", -- 101000 | 28 | STORE loop main
	"0110" & "000011", -- 101001 | 29 | JNZ GOTO MAIN_LOOP
	"1010" & "111111", -- 101010 | 2a | HALT 
	others => "1010" & "000000"
	);						   
	
	constant RAM_initial_state: TRAM(0 to 2**default_RAM_address_size-1)(default_RAM_word_size-1 downto 0) := (
	"00000101",	-- 5 | 000000 | array length
	"00000000", -- 0 | 000001 | previous
	"00000000", -- 0 | 000010 | tmp
	"00000000", -- 0 | 000011 | loop main
	"00000000", -- 0 | 000100 | loop inner
	"00000110", -- 0 | 000101 | array base(000110)
	"00000100", -- 4 | 000110 |	a[0]
	"00000010", -- 2 | 000111 |	a[1]
	"00000011", -- 3 | 001000 |	a[2]
	"00001001", -- 9 | 001001 |	a[3]
	"00000001", -- 1 | 001010 |	a[4]
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
