LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY data_mux IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		ctr : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END;

ARCHITECTURE arch OF data_mux IS

BEGIN

	output <= A WHEN ctr = '0' ELSE
		B;

END;