library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.all;

entity ROM is
	generic (
		word_size: integer := 10;
		address_size: integer := 6
		);						   
	port (
		read_enable: in std_logic;
		address: in std_logic_vector(address_size-1 downto 0);
		data_out: out std_logic_vector(word_size-1 downto 0)
		);
end ROM;

architecture beh of ROM is
	signal data: std_logic_vector(word_size-1 downto 0);
	signal state: TROM;
begin
	data <= state(conv_integer(address));
	
	read_data: process(read_enable, data)
	begin
		if (read_enable = '1') then
			data_out <= data;
		else
			data_out <= (others => 'Z');
		end if;
	end process;
	
end beh;



