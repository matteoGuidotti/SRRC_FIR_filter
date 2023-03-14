----------------------------------------------------------------------------------------------------------------------------
-- Square Root Raised Cosine FIR filter TESTBENCH file
-- Order of the filter: 22
-- Roll-Off factor: 0.5
-- Samples per symbol: 4
-- Input and Output signals represented with 16 bits
-- Coefficient values represented with 16 bits
----------------------------------------------------------------------------------------------------------------------------
-- Author: Guidotti Matteo
----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity srrc_fir_tb is
end srrc_fir_tb;

architecture testbench of srrc_fir_tb is

	component srrc_fir is
		port(
			clk	: in std_logic;	-- clock signal
			rst	: in std_logic;	-- reset signal
			x	: in std_logic_vector(15 downto 0);	-- Input signal
			y	: out std_logic_vector(15 downto 0)	-- Output signal
		);
	end component;

	-- constants
	constant T_CLK		: time := 8 ns;
	constant TestLen 	: integer := 30;	-- Number of clock cycle before stopping the simulation

	-- signals
	signal clk_tb			: std_logic := '0';	-- clock signal (initialized to '0')
	signal rst_tb			: std_logic := '1';	-- reset signal (initialized to '1')
	signal x_tb				: std_logic_vector(15 downto 0) := (others => '0'); -- input signal 
	signal y_tb				: std_logic_vector(15 downto 0) := (others => '0'); -- output signal
	signal stop_simulation 	: std_logic := '1'; -- signal to stop the simulation. It is stopped when stop_simulation goes to '0'

begin
	clk_tb <= (not(clk_tb) and stop_simulation) after T_CLK / 2;

	srrc_fir_dut: srrc_fir
				port map(
					clk => clk_tb,
					rst => rst_tb,
					x => x_tb,
					y => y_tb
				);
	
	-- the testbench signals change synchronously with the rising edge of the clock
	testing_process: process(clk_tb, rst_tb)
		variable clock_cycle : integer := 0; -- variable used to count the number of clock cycles after the reset
	begin
		if(rising_edge(clk_tb)) then
			case(clock_cycle) is
				when 1	=> rst_tb <= '0';
				when 2 	=> x_tb <= (15 downto 1 => '0') & '0';
				when (TestLen - 1) => stop_simulation <= '0';
				when others => null;
			end case;
			clock_cycle := clock_cycle + 1;
		end if;
	end process;  
end testbench;