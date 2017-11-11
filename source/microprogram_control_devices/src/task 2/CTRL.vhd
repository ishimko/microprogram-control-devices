library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.types.all;
use work.util.all;
use work.opcodes.all;

entity CTRL is
	port (
		CLK, RST, Start: in std_logic;
		Stop: out std_logic;
		
		-- ROM
		ROM_read_enable: out std_logic;
		ROM_address: out std_logic_vector(5 downto 0);
		ROM_out: in std_logic_vector(9 downto 0);
		
		-- RAM
		RAM_write_enable: out std_logic;
		RAM_address: out std_logic_vector(5 downto 0);
		RAM_data: inout data_word;
		
		-- ALU
		ALU_operand: out data_word;
		ALU_operation: out operation_word;
		ALU_enable: out std_logic;
		ALU_result: in data_word;
		ALU_zero_flag: in std_logic;
		ALU_sign_bit: in std_logic
		
		);						   
end CTRL;

architecture beh of CTRL is
	type state is (
	IDLE,
	FETCH,
	DECODE,
	READ,
	LOAD,
	STORE,
	ADD,
	SUB,
	INC,
	DEC,
	HALT,
	JNZ,
	JZ,
	JNSB,
	JMP
	);
	
	signal next_state, current_state: state;
	signal instruction: std_logic_vector(9 downto 0);
	signal instruction_pointer: address_word;
	signal operation: operation_word;
	signal address: address_word;
	signal data: data_word;
	signal FSR: data_word;
	
	constant INDF_ADDRESS: address_word := "111111";
	constant FSR_ADDRESS: address_word := "111110";
begin
	save_state: process(CLK, RST, next_state)
	begin		
		if (RST = '1') then
			current_state <= IDLE;
		elsif rising_edge(CLK) then
			current_state <= next_state;
		end if;
	end process;
	
	update_state: process(current_state, start, operation)
	begin		
		case current_state is
			when IDLE => 
				if (start = '1') then
					next_state <= FETCH;
				else
					next_state <= IDLE;
			end if;
			when FETCH => next_state <= DECODE;
			when DECODE =>
				case operation is
					when OP_HALT => next_state <= HALT;
					when OP_STORE => next_state <= STORE;
					when OP_JMP => next_state <= JMP;
					when OP_JZ => next_state <= JZ;
					when OP_JNZ => next_state <= JNZ;
					when OP_JNSB => next_state <= JNSB;
					when others => next_state <= READ;
			end case;
			when READ =>
				case operation is
					when OP_LOAD => next_state <= LOAD;
					when OP_ADD => next_state <= ADD;
					when OP_SUB => next_state <= SUB;
					when OP_INC => next_state <= INC;
					when OP_DEC => next_state <= DEC;
					when others => next_state <= IDLE;
			end case;
			when LOAD | STORE | ADD | SUB | INC | JMP | JZ | JNZ | JNSB => next_state <= FETCH;
			when HALT => next_state <= HALT;
			when others => next_state <= IDLE;
		end case;
	end process;							  
	
	update_stop: process(current_state)
	begin
		stop <= to_std_logic(current_state = HALT);
	end process;
	
	update_instruction_pointer: process(CLK, RST, current_state)
	begin		
		if (RST = '1') then
			instruction_pointer <= (others => '0');
		elsif falling_edge(CLK) then
			if (current_state = DECODE) then
				instruction_pointer <= instruction_pointer + 1;
			elsif (current_state = JZ and ALU_zero_flag = '1') then
				instruction_pointer <= address;
			elsif (current_state = JNZ and ALU_zero_flag = '0') then
				instruction_pointer <= address;
			elsif (current_state = JNSB and ALU_sign_bit = '0') then
				instruction_pointer <= address;
			elsif (current_state = JMP) then
				instruction_pointer <= address;
			end if;
		end if;
	end process; 
	
	update_ROM_read_enable: process(next_state, current_state)
	begin		
		ROM_read_enable <= to_std_logic(next_state = FETCH or current_state = FETCH);
	end process;
	
	read_ROM: process(RST, current_state, ROM_out)
	begin
		if (RST = '1') then
			instruction <= (others => '0');
		elsif (current_state = FETCH) then
			instruction <= ROM_out;
		end if;
	end process;
	
	decode_instruction: process(next_state, instruction)
	begin
		if (next_state = DECODE) then
			operation <= instruction(9 downto 6);
			address <= instruction(5 downto 0);
		end if;
	end process;
	
	update_RAM_write_address: process(address)
	begin
		if (current_state /= JMP and current_state /= JNZ and current_state /= JZ and current_state /= JNSB) then
			if (address = INDF_ADDRESS) then
				RAM_address <= FSR(5 downto 0);
				report "INFD" severity note;
			elsif (address /= FSR_ADDRESS) then
				RAM_address <= address;
			end if;
		end if;
	end process;   
	
	update_RAM_write_enable: process(current_state)
	begin
		if (current_state = STORE and address /= FSR_ADDRESS) then
			RAM_write_enable <= '1';
		else
			RAM_write_enable <= '0';
		end if;
	end process;
	
	write_to_FSR: process(current_state)
	begin
		if (current_state = STORE and address = FSR_ADDRESS) then
			FSR <= ALU_result;
		end if;
	end process;
	
	read_RAM: process(current_state)
	begin		
		if (current_state = READ) then
			if (address = FSR_ADDRESS) then
				data <= FSR;
			else
				data <= RAM_data;
			end if;
		end if;
	end process;
	
	update_ALU_enable: process(current_state)
	begin		
		ALU_enable <= to_std_logic(current_state = ADD or current_state = SUB or current_state = INC or current_state = DEC or current_state = LOAD);
	end process;
	
	ROM_address <= instruction_pointer;
	RAM_data <= ALU_result when RAM_write_enable = '1' else (others => 'Z');
	ALU_operand <= data;
	ALU_operation <= operation;
end beh;
