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
	"0000" & "000000", -- 000000 : LOAD 000000
	"0101" & "111111", -- 000001 : DEC
	"0001" & "000011", -- 000010 : STORE 000011
	"0000" & "000011", -- 000011 : LOAD 000011, MAIN_LOOP:
	"0001" & "000100", -- 000100 : STORE 000100
	"0000" & "000101", -- 000101 : LOAD 000101
	"0101" & "111111", -- 000110 : DEC
	"0001" & "111110", -- 000111 : STORE FSR
	"0000" & "111110", -- 001000 : LOAD FSR, INNER_LOOP:
	"0100" & "111111", -- 001001 : INC
	"0001" & "111110", -- 001010 : STORE FSR
	"0000" & "111111", -- 001011 : LOAD INDF
	"0001" & "000001", -- 001100 : STORE 000001
	"0000" & "111110", -- 001101 : LOAD FSR
	"0100" & "111111", -- 001110 : INC
	"0001" & "111110", -- 001111 : STORE FSR
	"0000" & "111111", -- 010000 : LOAD INDF
	"0011" & "000001", -- 010001 : SUB 000001
	"1000" & "011111", -- 010010 : JNSB GOTO SKIP
	"0000" & "111111", -- 010011 : LOAD INDF
	"0001" & "000010", -- 010100 : STORE 000010
	"0000" & "000001", -- 010101 : LOAD 000001
	"0001" & "111111", -- 010110 : STORE INDF
	"0000" & "111110", -- 010111 : LOAD FSR
	"0101" & "111111", -- 011000 : DEC
	"0001" & "111110", -- 011001 : STORE FSR
	"0000" & "000010", -- 011010 : LOAD 000010
	"0001" & "111111", -- 011011 : STORE INDF
	"0000" & "111110", -- 011100 : LOAD FSR
	"0100" & "111111", -- 011101 : INC
	"0001" & "111110", -- 011110 : STORE FSR
	"0000" & "111110", -- 011111 : LOAD FSR, SKIP:
	"0101" & "111111", -- 100000 : DEC
	"0001" & "111110", -- 100001 : STORE FSR
	"0000" & "000100", -- 100010 : LOAD 000100
	"0101" & "111111", -- 100011 : DEC
	"0001" & "000100", -- 100100 : STORE 000100
	"0110" & "001000", -- 100101 : JNZ GOTO INNER_LOOP
	"0000" & "000011", -- 100110 : LOAD 000011
	"0101" & "111111", -- 100111 : DEC
	"0001" & "000011", -- 101000 : STORE 000011
	"0110" & "000011", -- 101001 : JNZ GOTO MAIN_LOOP
	"1010" & "111111", -- 101010 : HALT
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
