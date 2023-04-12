
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity frm_demap is
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	in_val	: in std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture frm_demap_arch of frm_demap is


signal out_dat_temp	: std_logic_vector(255 downto 0);
signal buffelademad	: std_logic_vector(127 downto 0);

begin


process (clk)
begin
if rising_edge(clk) then

if row = "00" and column = "0000000" then

buffelademad <= in_dat(127 downto 0);

elsif column < "00100111" then --39
buffelademad <= in_dat(127 downto 0);
out_dat_temp <= buffelademad & in_dat(255 downto 128);

elsif column = "00100111" then --39

--out_dat_temp <= buffelademad & in_da



end if;



end if;
end process;



end architecture;