library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.all;									
use work.parameters.all;

entity RAM is
	generic (
		word_size: integer := default_RAM_word_size;
		address_size: integer := default_RAM_address_size;
		initial_state: TRAM(0 to 2**address_size-1)(word_size-1 downto 0) := (others => (others => '0'))
		);
	port (
		write_enable: in std_logic;
		address_bus: in std_logic_vector(address_size-1 downto 0);
		data_bus: inout std_logic_vector(word_size-1 downto 0)
		);
end RAM;

architecture beh of RAM is
	signal ram_storage: TRAM(0 to 2**address_size-1)(word_size-1 downto 0) := initial_state;
	signal address_value: integer range 0 to 2**address_size-1;
begin
	address_value <= conv_integer(address_bus);
	
	write_data: process(data_bus, ram_storage, address_value, write_enable)
	begin	
		if write_enable = '1' then
			ram_storage(address_value) <= data_bus;
			report "kek11" severity note;
		end if;
	end process;
	
	read_data: process(data_bus, ram_storage, address_value, write_enable)
	begin
		if write_enable = '0' then
			data_bus <= ram_storage(address_value);
			report "kek" severity note;
		else
			data_bus <= (others => 'Z');
			report "kek1" severity note;
		end if;
	end process;
end beh;

