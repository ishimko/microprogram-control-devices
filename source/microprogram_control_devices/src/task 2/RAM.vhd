library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.all;

entity RAM is
	generic (
		word_size: integer := 8;
		address_size: integer := 2;
		initial_state: TRAM(0 to 2**address_size-1)(word_size-1 downto 0) := (others => (others => '0'))
		);
	port (
		CLK: in std_logic;
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
	
	write_data: process(CLK, data_bus, ram_storage, address_value, write_enable)
	begin	
		if write_enable = '1' then	
			if rising_edge(CLK) then
				ram_storage(address_value) <= data_bus;
			end if;
		end if;
	end process;
	
	read_data: process(CLK, data_bus, ram_storage, address_value, write_enable)
	begin
		if write_enable = '0' then
			if rising_edge(CLK) then
				data_bus <= ram_storage(address_value);
			end if;
		else
			data_bus <= (others => 'Z');
		end if;
	end process;
end beh;

