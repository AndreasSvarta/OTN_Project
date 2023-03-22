library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;


entity frm_align is
port (	
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	out_val	: out std_logic;
	FAOOF	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture frm_align_arch of frm_align is

signal in_dat_temp : std_logic_vector(255 downto 0);
signal column_temp : std_logic_vector(6 downto 0);
signal long_fas : std_logic_vector(31 downto 0):=x"F6F62828";

begin

in_dat_temp <= in_dat;

process(clk)
begin
column_temp <= "0000000";

end process;
column <= column_temp;


end architecture;