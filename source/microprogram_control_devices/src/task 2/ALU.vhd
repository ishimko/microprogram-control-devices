library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.types.all;
use work.opcodes.all;


entity ALU is
	port(
		enable: in std_logic;
		operation: in operation_word;
		operand: in data_word;
		result: out data_word;
		zero_flag: out std_logic;
		sign_bit: out std_logic
		);
end ALU;

architecture beh of ALU is
	signal accumulator: data_word;
	signal add_result: data_word;
	signal sub_result: data_word;
	signal inc_result: data_word;
	signal dec_result: data_word;
	signal zero, sign: std_logic;
begin	
	add_result <= accumulator + operand;
	sub_result <= accumulator - operand;
	inc_result <= accumulator + "1";
	dec_result <= accumulator - "1";
	
	perform_operation: process(enable, operation, operand, add_result, sub_result, inc_result, dec_result)
	begin	   
		if rising_edge(enable) then
			case operation is
				when OP_LOAD => accumulator <= operand;
				when OP_ADD => accumulator <= add_result;
				when OP_SUB => accumulator <= sub_result;
				when OP_INC => accumulator <= inc_result;
				when OP_DEC => accumulator <= dec_result;
				when others => NULL;
			end case;
		end if;
	end process;
	
	set_flags: process(accumulator)
	begin		
		if accumulator = (accumulator'range => '0') then
			zero <= '1';
		else
			zero <= '0';
		end if;
		
		sign <= accumulator(7);
	end process;
	
	result <= accumulator;
	zero_flag <= zero;
	sign_bit <= sign;
end beh;
	
	