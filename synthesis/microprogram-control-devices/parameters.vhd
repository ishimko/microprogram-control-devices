library ieee;
use ieee.std_logic_1164.all;

package Parameters is
	constant default_ROM_address_size: integer:= 6;
	constant default_ROM_word_size: integer:= 10;
	constant default_RAM_word_size: integer := 8;
	constant default_RAM_address_size: integer := 6;
end package;