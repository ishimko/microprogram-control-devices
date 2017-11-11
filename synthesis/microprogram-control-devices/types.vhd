library ieee;
use ieee.std_logic_1164.all;
use work.parameters.all;

package Types is
	subtype data_word is std_logic_vector(7 downto 0);
	subtype operation_word is std_logic_vector(3 downto 0);
	subtype address_word is std_logic_vector(5 downto 0);
	
	type TROM is array(0 to 2**default_ROM_address_size-1) of std_logic_vector(default_ROM_word_size-1 downto 0);
	type TRAM is array(0 to 2**default_RAM_address_size-1) of std_logic_vector(default_RAM_word_size-1 downto 0);
end package;