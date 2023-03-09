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
		y	: in std_logic_vector(15 downto 0)	-- Output signal
	)
end srrc_fir;

-- Architecture description
architecture srrc_fir_beh of srrc_fir is

	-- Coefficients definition (thanks to simmetry I can store only half of them)
	type coefficient is array (0 to 11) of signed (15 downto 0);
	constant c: coeff := (
		to_signed(-271, 16),
		to_signed(-246, 16),
		to_signed(253, 16),
		to_signed(694, 16),
		to_signed(253, 16),
		to_signed(-1229, 16),
		to_signed(-2570, 16),
		to_signed(-1739, 16),
		to_signed(2569, 16),
		to_signed(9479, 16),
		to_signed(15966, 16),
		to_signed(18622, 16)
	);

	-- Definition of flip-flop input lines
	--type dff_input_vector is array (0 to 21) of std_logic_vector(15 downto 0);
	--signal dff_in: dff_input_vector;

	-- Definition of flip-flop output lines
	--type dff_output_vector is array (0 to 21) of std_logic_vector(15 downto 0);
	--signal dff_out: dff_output_vector;

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
		generic(N: integer:= 8)
	port(
		d	: in std_logic_vector(N-1 downto 0);
		clk	: in std_logic;
		rst	: in std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	);
	end component;

begin
	
	-- Flip-flops lines mapping
	dff_map: for i in 0 to 21 generate
		-- first flip-flop
		FIRST: if i = 0 generate
			DFF_0: dff_n 
				generic map(N => 16)
				port map(d => x, clk => clk, rst => rst, q => dff_out(0));
		end generate FIRST;

		-- generic flip-flop
		GENERIC: if i > 0 generate
			DFF_i: dff_n
				generic map(N => 16)
				port map(d => dff_out(i-1), clk => clk, rst => rst, q => dff_out(i));
		end generate GENERIC;
	end generate dff_map;

	-- Output Flip-Flop
	out_map: dff_n
	generic map(N => 16)
	port map(d => result(32 downto 17), clk => clk, rst => rst, q => y);

end srrc_fir_beh