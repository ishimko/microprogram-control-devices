library ieee;
use ieee.std_logic_1164.all;

package Types is
	subtype data_word is std_logic_vector(7 downto 0);
	subtype operation_word is std_logic_vector(3 downto 0);
	subtype address_word is std_logic_vector(5 downto 0);
	
	type TROM is array(natural range <>) of std_logic_vector;
	type TRAM is array(natural range <>) of std_logic_vector;
end package;