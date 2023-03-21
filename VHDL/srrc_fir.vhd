----------------------------------------------------------------------------------------------------------------------------
-- Square Root Raised Cosine FIR filter 
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
use IEEE.numeric_std.all;

-- Entity description
entity srrc_fir is
	port(
		clk	: in std_logic;	-- clock signal
		rst	: in std_logic;	-- reset signal
		x	: in std_logic_vector(15 downto 0);	-- Input signal
		y	: out std_logic_vector(15 downto 0)	-- Output signal
	);
end srrc_fir;

-- Architecture description
architecture srrc_fir_beh of srrc_fir is

	-- Coefficients definition (thanks to simmetry I can store only half of them)
	type coefficient is array (0 to 11) of signed (15 downto 0);
	constant c: coefficient := (
		to_signed(-271, 16),	-- (-0.0165)
		to_signed(-246, 16),	-- (-0.015)
		to_signed(253, 16),		-- (0.0155)
		to_signed(694, 16),		-- (0.0424)
		to_signed(253, 16),		-- (0.0155)
		to_signed(-1229, 16),	-- (-0.075)
		to_signed(-2570, 16),	-- (-0.1568)
		to_signed(-1739, 16),	-- (-0.1061)
		to_signed(2569, 16),	-- (0.1568)
		to_signed(9479, 16),	-- (0.5786)
		to_signed(15966, 16),	-- (0.9745)
		to_signed(18622, 16)	-- (1.1366)
	);

	-- Definition of output lines of flip-flop
	type dff_output_vector is array (0 to 21) of std_logic_vector(15 downto 0);
	signal dff_out: dff_output_vector;

	-- Definition of the sum output lines
	type sum_output_vector is array (0 to 10) of std_logic_vector(16 downto 0); -- the sum between two values represented on 16 bits is representable with 17 bits
	signal sum_out: sum_output_vector;

	-- Definition of the multiplication output lines
	type mul_out_vector is array (0 to 11) of std_logic_vector(32 downto 0); -- product between a value on 16 bits and a value on 17 bits is representable with 33 bits
	signal mul_out: mul_out_vector;

	-- Output of the last sum
	signal result: std_logic_vector(32 downto 0);

	-- Flip-Flop component declaration
	component dff_n is
		generic(N: integer:= 8);
		port(
			d	: in std_logic_vector(N-1 downto 0);
			clk	: in std_logic;
			rst	: in std_logic;
			q	: out std_logic_vector(N-1 downto 0)
		);
	end component;

begin
	
	-- Flip-flops lines mapping
	DFF_MAP: for i in 0 to 21 generate
		-- first flip-flop
		FIRST_DFF: if i = 0 generate
			DFF_0: dff_n 
				generic map(N => 16) 
				port map(d => x, clk => clk, rst => rst, q => dff_out(0));
		end generate FIRST_DFF;

		-- generic flip-flop
		GENERIC_DFF: if i > 0 generate
			DFF_i: dff_n 
				generic map(N => 16)
				port map(d => dff_out(i-1), clk => clk, rst => rst, q => dff_out(i));
		end generate GENERIC_DFF;

	end generate DFF_MAP;

	-- Output Flip-Flop
	OUTPUT_DFF_MAP: dff_n
				generic map(N => 16)
				port map(d => result(31 downto 16), clk => clk, rst => rst, q => y); 	-- truncation discarding 16 bits and saturation discarding the most significant bit
				--port map(d => result(32 downto 17), clk => clk, rst => rst, q => y);	-- only truncation discarding 17 bits

	-- Summation stage: Sums between the couples of values that must be multiplied with the same coefficient
	-- This consent to use half of the multiplier, that are expensive
	SUM_STAGE: for i in 0 to 10 generate
		-- the first sum is between the input of the filter and the output value of the last flip-flop 
		FIRST_SUM: if i = 0 generate
			sum_out(i) <= std_logic_vector(resize(signed(x), 17) + resize(signed(dff_out(21)), 17));
		end generate FIRST_SUM;

		GENERIC_SUM: if i > 0 generate
			sum_out(i) <= std_logic_vector(resize(signed(dff_out(i - 1)), 17) + resize(signed(dff_out(21 - i)), 17));
		end generate GENERIC_SUM;
	end generate SUM_STAGE;
	
	-- Multiplication stage: results of each sum must be multiplied by the respective coefficient
	-- The value at flip-flop with index i = 11 has not been summed to anyone, it must be only multiplied with its coefficient 
	MUL_STAGE: for i in 0 to 11 generate
		GENERIC_MUL: if i < 11 generate
			mul_out(i) <= std_logic_vector(signed(sum_out(i)) * c(i));
		end generate GENERIC_MUL;

		LAST_MUL: if i = 11 generate
			mul_out(11) <= std_logic_vector(resize(signed(dff_out(10)), 17) * c(11));
		end generate LAST_MUL;
	end generate MUL_STAGE;

	-- Final sum
	result <= std_logic_vector(
		signed(mul_out(0)) + signed(mul_out(1)) +
		signed(mul_out(2)) + signed(mul_out(3)) +
		signed(mul_out(4)) + signed(mul_out(5)) +
		signed(mul_out(6)) + signed(mul_out(7)) +
		signed(mul_out(8)) + signed(mul_out(9)) +
		signed(mul_out(10)) + signed(mul_out(11)));

end srrc_fir_beh;