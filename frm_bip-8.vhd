library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;


entity frm_bip_8 is
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	in_val	: in std_logic;
	out_val	: out std_logic;
	bip_err : out std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture frm_bip_8_arch of frm_bip_8 is

signal bip_err_temp 	: std_logic:='0';
--signal in_dat_temp 	: std_logic_vector(255 downto 0);



begin

--in_dat_temp <= in_dat;

process (clk,rst)

variable result : std_logic := '0';

begin

if rising_edge(clk) then
	if rst = '1' then 
		bip_err <= '0';
		bip_err_temp <= '0';
		out_val <= '0';
	else
		if in_val = '0' then
			if row = "11" and column = "1111111" then
				bip_err <= bip_err_temp;
				bip_err_temp <= '0';
			else
				for i in 0 to 255 loop
					result := result xor in_dat(i);
				end loop;
				bip_err_temp <= result;
report "in_dat= " & to_hstring(in_dat);
			end if;
		end if;
	end if;

end if;
end process;
--bip_err <= bip_err_temp;

end architecture;