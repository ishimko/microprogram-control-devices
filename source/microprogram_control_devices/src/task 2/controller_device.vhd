library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity ControllerDevice is
	generic (
		ROM_word_size: integer := 10;
		ROM_address_size: integer := 6;
		ROM_state: TROM(0 to 2**ROM_address_size-1)(ROM_word_size-1 downto 0) := (others => (others => '0'));
		RAM_word_size: integer := 8;
		RAM_address_size: integer := 2;
		RAM_initial_state: TRAM(0 to 2**RAM_address_size-1)(RAM_word_size-1 downto 0) := (others => (others => '0'))
		);
	port (
		CLK, RST, start: in std_logic;
		stop: out std_logic
		);
end ControllerDevice;

architecture beh of ControllerDevice is
	-- ROM
	signal ROM_read_enable: std_logic;
	signal ROM_address: address_word;
	signal ROM_out: std_logic_vector(9 downto 0);
	-- RAM
	signal RAM_write_enable: std_logic;
	signal RAM_address: address_word;
	signal RAM_data: data_word;
	-- ALU
	signal ALU_operand: data_word;
	signal ALU_operation: operation_word;
	signal ALU_enable: std_logic;
	signal ALU_result: data_word;
	signal ALU_zero_flag: std_logic;
	signal ALU_sign_bit: std_logic;
begin
	URAM: entity RAM(beh) 
	generic map(
		word_size => RAM_word_size,
		address_size => RAM_address_size,
		initial_state => RAM_initial_state
		)
	port map(
		write_enable => RAM_write_enable,
		address_bus => RAM_address,
		data_bus => RAM_data
		);
	
	UROM: entity ROM(beh)
	generic map(
		word_size => ROM_word_size,
		address_size => ROM_address_size,
		state => ROM_state	
		)
	port map(
		read_enable => ROM_read_enable,
		address => ROM_address,
		data_out => ROM_out
		);
	
	UALU: entity ALU(beh)
	port map(
		enable => ALU_enable,
		operation => ALU_operation,
		operand => ALU_operand,
		result => ALU_result,
		zero_flag => ALU_zero_flag,
		sign_bit => ALU_sign_bit
		);
	
	UCTRL: entity CTRL(beh)
	port map(
		CLK => CLK,
		RST => RST,
		Start => Start,
		Stop => stop,
		
		ROM_read_enable => ROM_read_enable,
		ROM_address => ROM_address,
		ROM_out => ROM_out,
		
		RAM_write_enable => RAM_write_enable, 
		RAM_address => RAM_address,
		RAM_data => RAM_data,
		
		ALU_operand => ALU_operand,
		ALU_operation => ALU_operation,
		ALU_enable => ALU_enable,
		ALU_result => ALU_result,
		ALU_zero_flag => ALU_zero_flag,
		ALU_sign_bit => ALU_sign_bit
		);
end beh;