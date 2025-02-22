LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comparator IS

	PORT (
		A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		output : OUT STD_LOGIC
	);

END;

ARCHITECTURE arch OF comparator IS
BEGIN

	output <= '1' WHEN A > B ELSE
		'0';

END;