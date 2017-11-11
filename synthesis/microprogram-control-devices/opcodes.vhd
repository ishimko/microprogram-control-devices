library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

package Opcodes is
	constant OP_LOAD: operation_word := "0000";
	constant OP_STORE: operation_word := "0001";
	constant OP_ADD: operation_word := "0010";
	constant OP_SUB: operation_word := "0011";
	constant OP_INC: operation_word := "0100";
	constant OP_DEC: operation_word := "0101";
	constant OP_JNZ: operation_word := "0110";
	constant OP_JZ: operation_word := "0111";
	constant OP_JNSB: operation_word := "1000";
	constant OP_JMP: operation_word := "1001";
	constant OP_HALT: operation_word := "1010";
end package;