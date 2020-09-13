library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
	generic (
		DATA_LEN : integer := 8;
		ADDR_LEN : integer := 4
	);
	port (
		clk, rst : in std_logic;

		ram_data : in std_logic_vector((DATA_LEN - 1) downto 0);
		sort_addr, N : in std_logic_vector((ADDR_LEN - 1) downto 0);
		sort_done : in std_logic;
		
		data_out : out std_logic_vector((DATA_LEN - 1) downto 0);
		ram_addr : out std_logic_vector((ADDR_LEN - 1) downto 0);
		is_printing : out std_logic
	);
end top;

architecture arch of top is

type t_state is (waiting, printing);
signal cur, nxt : t_state;

signal is_end, cnt_clear, cnt_inc : std_logic;

signal cnt_value, cnt_next : unsigned((ADDR_LEN - 1) downto 0);

begin

process (clk, rst)
begin
	if (rst = '1') then
		cur <= waiting;
		cnt_value <= (others => '0');
	elsif rising_edge(clk) then
		cur <= nxt;
		cnt_value <= cnt_next;
	end if;
end process;

process (cur, sort_done, N, is_end)
begin
	nxt <= cur;
	is_printing <= '0';
	cnt_clear <= '0';
	cnt_inc <= '0';

	case cur is
		when waiting =>
			if sort_done = '1' then
				nxt <= printing;
			end if;
		when printing =>
			is_printing <= '1';
			if is_end = '1' then
			    -- When we reach the end we just clear the counter and print again
				cnt_clear <= '1';
			else
				cnt_inc <= '1';
			end if;
	end case;
end process;

-- Counter
cnt_next <= (others => '0') when cnt_clear = '1' else
			cnt_value + 1 when cnt_inc = '1' else
			cnt_value;

-- Address mux
ram_addr <= sort_addr when cur = waiting else std_logic_vector(cnt_value);

-- Comparator
is_end <= '1' when cnt_value >= unsigned(N) else '0';

-- Pass through ram_data (to enable it to be read into slave register)
data_out <= ram_data;

end arch;
