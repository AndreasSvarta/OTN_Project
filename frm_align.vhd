library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
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

signal in_dat_buffer 	: std_logic_vector(255 downto 0);
signal column_temp 	: std_logic_vector(6 downto 0);
signal long_fas 	: std_logic_vector(31 downto 0):=x"F6F62828";
signal short_fas 	: std_logic_vector(23 downto 0):=x"F62828";
signal long_faoof	: std_logic_vector(1 downto 0):="00";
signal short_faoof	: std_logic :='0';
signal short_error_cnt	: std_logic_vector(1 downto 0):="00";
signal FAOOF_temp 	: std_logic:='1';
signal cnt_test		: integer:=0;
signal frm_nr_int	: integer:=0;
signal index		: integer:=0;

begin

--in_dat_buffer <= in_dat;

process(clk)
begin

if rising_edge(clk) and rst = '0' then
	in_dat_buffer <= in_dat;

	cnt_test <= cnt_test + 1;

	for i in 0 to 255-32 loop
		if in_dat(i+31 downto i) = long_fas then
			long_faoof <= long_faoof + "1";
			cnt_test <= 1;
			index <= i-214;
		end if;
	end loop;

	if cnt_test > 510 then
		long_faoof <= "00";
		cnt_test <= 1;
	end if;

	if long_faoof = "10" then
		long_faoof <= "00";
		FAOOF_temp <= '0';
	end if;
	

	if FAOOF_temp = '0' then
		for i in 0 to 255-32 loop
			if in_dat(i+31 downto i) = short_fas then
				FAOOF_temp <= '0';
			elsif cnt_test > 510 then
				cnt_test <= 1;
				short_error_cnt <= short_error_cnt + "1";
				if short_error_cnt = "11" then
					FAOOF_temp <= '1';
				end if;
			end if;
		end loop;
	end if;

	if index = 0 then
		out_dat <= in_dat_buffer;
	elsif index > 0 then
		out_dat <= in_dat_buffer(255-index downto 0) & in_dat(255 downto 255-index+1);
	end if;

end if;


end process;
column <= column_temp;
FAOOF <= FAOOF_temp;

end architecture;