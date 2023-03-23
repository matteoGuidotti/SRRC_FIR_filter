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
	constant T_CLK		: time := 25 ns;	-- Clock period
	constant TestLen 	: integer := 102;	-- Number of clock cycle in which the simulation is stopped

	-- signals
	signal clk_tb			: std_logic := '0';	-- clock signal (initialized to '0')
	signal rst_tb			: std_logic := '0';	-- reset signal (initialized to '0')
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
	testing_process: process(clk_tb)
		variable clock_cycle : integer := 0; -- variable used to count the number of clock cycles after the reset
	begin
		if(rising_edge(clk_tb)) then
			case(clock_cycle) is
				-- this case statement model the input as it is taken from a sin waveform signal with period 2pi
				when 1	=> rst_tb <= '1';
				when 2 	=> x_tb <= "0000000000000000";
				when 3 	=> x_tb <= "0000100000011110";
				when 4 	=> x_tb <= "0001000000110100";
				when 5 	=> x_tb <= "0001100000111001";
				when 6 	=> x_tb <= "0010000000100101";
				when 7 	=> x_tb <= "0010011111110000";
				when 8 	=> x_tb <= "0010111110010010";
				when 9 	=> x_tb <= "0011011100000011";
				when 10 => x_tb <= "0011111000111011";
				when 11 => x_tb <= "0100010100110011";
				when 12 => x_tb <= "0100101111100100";
				when 13 => x_tb <= "0101001001000110";
				when 14 => x_tb <= "0101100001010100";
				when 15 => x_tb <= "0101111000000111";
				when 16 => x_tb <= "0110001101011000";
				when 17 => x_tb <= "0110100001000100";
				when 18 => x_tb <= "0110110011000011";
				when 19 => x_tb <= "0111000011010011";
				when 20 => x_tb <= "0111010001101110";
				when 21 => x_tb <= "0111011110010010";
				when 22 => x_tb <= "0111101000111010";
				when 23 => x_tb <= "0111110001100100";
				when 24 => x_tb <= "0111111000001110";
				when 25 => x_tb <= "0111111100110110";
				when 26 => x_tb <= "0111111111011010";
				when 27 => x_tb <= "0111111111111011";
				when 28 => x_tb <= "0111111110011000";
				when 29 => x_tb <= "0111111010110010";
				when 30 => x_tb <= "0111110101001001";
				when 31 => x_tb <= "0111101101011111";
				when 32 => x_tb <= "0111100011110101";
				when 33 => x_tb <= "0111011000001111";
				when 34 => x_tb <= "0111001010101111";
				when 35 => x_tb <= "0110111011011001";
				when 36 => x_tb <= "0110101010010001";
				when 37 => x_tb <= "0110010111011011";
				when 38 => x_tb <= "0110000010111100";
				when 39 => x_tb <= "0101101100111001";
				when 40 => x_tb <= "0101010101011000";
				when 41 => x_tb <= "0100111100011111";
				when 42 => x_tb <= "0100100010010101";
				when 43 => x_tb <= "0100000111000000";
				when 44 => x_tb <= "0011101010100111";
				when 45 => x_tb <= "0011001101010001";
				when 46 => x_tb <= "0010101111000111";
				when 47 => x_tb <= "0010010000001111";
				when 48 => x_tb <= "0001110000110011";
				when 49 => x_tb <= "0001010000111001";
				when 50 => x_tb <= "0000110000101010";
				when 51 => x_tb <= "0000010000001111";
				when 52 => x_tb <= "1111101111110000";
				when 53 => x_tb <= "1111001111010101";
				when 54 => x_tb <= "1110101111000110";
				when 55 => x_tb <= "1110001111001100";
				when 56 => x_tb <= "1101101111110000";
				when 57 => x_tb <= "1101010000111000";
				when 58 => x_tb <= "1100110010101110";
				when 59 => x_tb <= "1100010101011000";
				when 60 => x_tb <= "1011111000111111";
				when 61 => x_tb <= "1011011101101010";
				when 62 => x_tb <= "1011000011100000";
				when 63 => x_tb <= "1010101010100111";
				when 64 => x_tb <= "1010010011000110";
				when 65 => x_tb <= "1001111101000011";
				when 66 => x_tb <= "1001101000100100";
				when 67 => x_tb <= "1001010101101110";
				when 68 => x_tb <= "1001000100100110";
				when 69 => x_tb <= "1000110101010000";
				when 70 => x_tb <= "1000100111110000";
				when 71 => x_tb <= "1000011100001010";
				when 72 => x_tb <= "1000010010100000";
				when 73 => x_tb <= "1000001010110110";
				when 74 => x_tb <= "1000000101001101";
				when 75 => x_tb <= "1000000001100111";
				when 76 => x_tb <= "1000000000000100";
				when 77 => x_tb <= "1000000000100101";
				when 78 => x_tb <= "1000000011001001";
				when 79 => x_tb <= "1000000111110001";
				when 80 => x_tb <= "1000001110011011";
				when 81 => x_tb <= "1000010111000101";
				when 82 => x_tb <= "1000100001101101";
				when 83 => x_tb <= "1000101110010001";
				when 84 => x_tb <= "1000111100101100";
				when 85 => x_tb <= "1001001100111100";
				when 86 => x_tb <= "1001011110111011";
				when 87 => x_tb <= "1001110010100111";
				when 88 => x_tb <= "1010000111111000";
				when 89 => x_tb <= "1010011110101011";
				when 90 => x_tb <= "1010110110111001";
				when 91 => x_tb <= "1011010000011011";
				when 92 => x_tb <= "1011101011001100";
				when 93 => x_tb <= "1100000111000100";
				when 94 => x_tb <= "1100100011111100";
				when 95 => x_tb <= "1101000001101101";
				when 96 => x_tb <= "1101100000001111";
				when 97 => x_tb <= "1101111111011010";
				when 98 => x_tb <= "1110011111000110";
				when 99 => x_tb <= "1110111111001011";
				when 100 => x_tb <= "1111011111100001";
				when 101 => x_tb <= "1111111111111111";
				when TestLen => stop_simulation <= '0';
				when others => null;
			end case;
			clock_cycle := clock_cycle + 1;
		end if;
	end process;  
end testbench;