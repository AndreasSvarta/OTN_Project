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

signal bip_err_temp 	: std_logic_vector(7 downto 0):="00000000";
signal bip_err_temp_0 	: std_logic:='0';
signal in_dat_temp 	: std_logic_vector(255 downto 0);



begin

in_dat_temp <= in_dat;

process (clk,rst)

--variable result : std_logic := '0';

begin

if rising_edge(clk) then
	if rst = '1' then 
		bip_err <= '0';
		bip_err_temp <= "00000000";
		out_val <= '0';
	elsif in_val = '0' then
--		bip_err_temp(7) <= in_dat_temp(255) xor in_dat_temp(247) xor in_dat_temp(239);
		for i in 0 to 31 loop
			bip_err_temp(7) <= bip_err_temp(7) xor in_dat_temp(8*i);
			bip_err_temp(6) <= bip_err_temp(6) xor in_dat_temp(8*i+1);
			bip_err_temp(5) <= bip_err_temp(5) xor in_dat_temp(8*i+2);
			bip_err_temp(4) <= bip_err_temp(4) xor in_dat_temp(8*i+3);
			bip_err_temp(3) <= bip_err_temp(3) xor in_dat_temp(8*i+4);
			bip_err_temp(2) <= bip_err_temp(2) xor in_dat_temp(8*i+5);
			bip_err_temp(1) <= bip_err_temp(1) xor in_dat_temp(8*i+6);
			bip_err_temp(0) <= bip_err_temp(0) xor in_dat_temp(8*i+7);
		end loop;
	end if;

end if;
end process;
--bip_err <= bip_err_temp;

end architecture;
