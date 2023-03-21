----------------------------------------------------------------------------------------------------------------------------
-- Parallel D Flip-Flop with generic number of bits for input/output (N)
-- Synchronous reset
----------------------------------------------------------------------------------------------------------------------------
-- Author: Guidotti Matteo
----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

-- Entity description
entity dff_n is 
	generic (N: integer:= 8);	-- default value of N is 8
	port(
		d	: in std_logic_vector(N-1 downto 0);
		clk	: in std_logic;
		rst	: in std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	);
end dff_n;

-- Architecture description
architecture dff_n_beh of dff_n is
begin
	proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '0') then
				q <= (others => '0');
			else
				q <= d;
			end if;
		end if;
	end process;
end dff_n_beh;