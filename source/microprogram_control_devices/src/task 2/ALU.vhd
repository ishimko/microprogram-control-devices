library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ALU is
	port(
		enable: in std_logic;
		operation: in std_logic_vector(3 downto 0);
		operand: in std_logic_vector(7 downto 0);
		result: out std_logic_vector(7 downto 0);
		zero_flag: out std_logic;
		sign_bit: out std_logic
		);
end ALU;

architecture beh of ALU is
	subtype data_word is std_logic_vector(7 downto 0);
	subtype operation_word is std_logic_vector(3 downto 0);
	
	signal accumulator: data_word;
	signal add_result: data_word;
	signal sub_result: data_word;
	signal inc_result: data_word;
	signal dec_result: data_word;
	signal zero, sign: std_logic;
	
	constant LOAD: operation_word := "0000";
	constant ADD: operation_word := "0001";
	constant SUB: operation_word := "0010";
	constant INC: operation_word := "0011";
	constant DEC: operation_word := "0100";
begin	
	add_result <= accumulator + operand;
	sub_result <= accumulator - operand;
	inc_result <= accumulator + "1";
	dec_result <= accumulator - "1";
	
	perform_operation: process(enable, operation, operand, add_result, sub_result, inc_result, dec_result)
	begin	   
		if rising_edge(enable) then
			case operation is
				when LOAD => accumulator <= operand;
				when ADD => accumulator <= add_result;
				when SUB => accumulator <= sub_result;
				when INC => accumulator <= inc_result;
				when DEC => accumulator <= dec_result;
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
	
	