library ieee;
use ieee.std_logic_1164.all;

package Util is
	function to_std_logic(b: boolean) return std_logic;
end package;

package body Util is
	function to_std_logic(b: boolean) return std_logic is 
	begin 
		if b then 
			return '1'; 
		else 
			return '0'; 
		end if; 
	end function to_std_logic;
end package body;