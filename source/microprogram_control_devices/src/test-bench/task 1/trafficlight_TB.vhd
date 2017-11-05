library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

entity trafficlight_tb is
end trafficlight_tb;

architecture TB_ARCHITECTURE of trafficlight_tb is
	-- Component declaration of the tested unit
	component trafficlight
	port(
		clk : in STD_LOGIC;
		cwait : in STD_LOGIC;
		rst : in STD_LOGIC;
		start : in STD_LOGIC;
		r : out STD_LOGIC;
		y : out STD_LOGIC;
		g : out STD_LOGIC );
	end component;

	signal clk : STD_LOGIC := '0';
	signal cwait : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal start : STD_LOGIC;

	signal r : STD_LOGIC;
	signal y : STD_LOGIC;
	signal g : STD_LOGIC;

	constant clock_period: time := 10 ns;
begin
	UUT : entity trafficlight(beh)
		port map (
			clk => clk,
			cwait => cwait,
			rst => rst,
			start => start,
			r => r,
			y => y,
			g => g
		);
	
	clk <= not clk after clock_period / 2;
	
	stimulate: process
	begin		
		wait for 2 * clock_period;
		start <= '1';
		wait for 16 * clock_period;
		cwait <= '1';
		wait for 16 * clock_period;
		cwait <= '0';
		wait for 8 * clock_period;
		rst <= '1';
		wait for clock_period;
		rst <= '0';
		wait for 8 * clock_period;
		report "End of simulation" severity failure;
	end process;
end TB_ARCHITECTURE;

