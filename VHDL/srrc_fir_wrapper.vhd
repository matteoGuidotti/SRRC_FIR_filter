----------------------------------------------------------------------------------------------------------------------------
-- Wrapper for the Square Root Raised Cosine FIR filter 
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

entity srrc_fir_wrapper is 
	port(
		clk	: in std_logic;	-- clock signal
		rst	: in std_logic;	-- reset signal
		x	: in std_logic_vector(15 downto 0);	-- Input signal
		y	: out std_logic_vector(15 downto 0)	-- Output signal
	);
end srrc_fir_wrapper;

architecture struct of srrc_fir_wrapper is

	component srrc_fir
		port(
			clk	: in std_logic;	-- clock signal
			rst	: in std_logic;	-- reset signal
			x	: in std_logic_vector(15 downto 0);	-- Input signal
			y	: out std_logic_vector(15 downto 0)	-- Output signal
		);
	end component;

begin

	filter: srrc_fir port map(clk, rst, x, y);

end struct;