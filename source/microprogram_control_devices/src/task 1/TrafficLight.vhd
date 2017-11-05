library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity TrafficLight is
	port(
		clk: in std_logic;
		cwait: in std_logic;
		rst: in std_logic;
		start: in std_logic;
		r, y, g: out std_logic
		); 
end TrafficLight;

architecture beh of TrafficLight is
	type rom is array(0 to 15) of std_logic_vector(6 downto 0);
	constant rom_data: rom := (
	"0000" & "000", -- 0
	"0001" & "000", -- 1
	"0000" & "100",	-- 2
	"0000" & "100",	-- 3
	"0000" & "100",	-- 4
	"0000" & "110",	-- 5
	"0000" & "001",	-- 6
	"0000" & "001",	-- 7
	"0000" & "001",	-- 8
	"0000" & "000",	-- 9
	"0000" & "001",	-- 10
	"0000" & "000",	-- 11
	"0000" & "001",	-- 12
	"0000" & "000",	-- 13
	"0010" & "010",	-- 14
	"1110" & "000"	-- 15
	);
	signal next_address: std_logic_vector(3 downto 0);	 
	signal current_address: std_logic_vector(3 downto 0) := "0001";
	signal lights_state: std_logic_vector(2 downto 0);
	signal current_command: std_logic_vector(6 downto 0);
begin
	next_state: process(cwait, start, current_address, next_address, current_command)
	begin		
		if (start = '1' and current_address = "0001") then
			next_address <= "0010";
		elsif (cwait = '1' and current_address = "1110") then
			next_address <= "1111";
		elsif (falling_edge(cwait) and (current_address = "1110" or current_address = "1111")) then
			next_address <= "1110";
		elsif (current_command(6 downto 3) = "0000") then
			next_address <= current_address + "1";
		else
			next_address <= current_command(6 downto 3);
		end if;
	end process;  
	
	clocking: process(rst, clk, current_command)
	begin		
		if rst = '1' then
			current_address <= "0001";
		elsif rising_edge(clk) then
			current_address <= next_address;
		end if;
	end process;		 
	
	lights_state <= current_command(2 downto 0);
	current_command <= rom_data(conv_integer(current_address));
	
	r <= lights_state(2);
	y <= lights_state(1);
	g <= lights_state(0);
end beh;
