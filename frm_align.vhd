library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
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
signal column_temp 	: std_logic_vector(6 downto 0):="0000000";
signal row_temp		: std_logic_vector(1 downto 0):="00";
signal long_fas 	: std_logic_vector(31 downto 0):=x"F6F62828";
signal short_fas 	: std_logic_vector(23 downto 0):=x"F62828";
signal long_faoof	: std_logic_vector(1 downto 0):="00";
signal short_faoof	: std_logic :='0';
signal short_error_cnt	: std_logic_vector(1 downto 0):="00";
signal FAOOF_temp 	: std_logic:='1';
signal cnt_frame_510	: integer:=0;
signal frm_nr_int	: integer:=0;
signal index		: integer:=0;
signal index_check	: integer:=0;

begin

--in_dat_buffer <= in_dat;


process(clk)
begin

if rising_edge(clk) and rst = '0' then
	in_dat_buffer <= in_dat;
	
--	cnt_frame_510 <= cnt_frame_510 + 1;

	if column_temp = "1111110" and (row_temp = "00" or row_temp = "10") then
	column_temp <= "0000000";
	row_temp <= row_temp + "1";
	elsif column_temp = "1111111" and (row_temp = "01" or row_temp = "11") then
	column_temp <= "0000000";
	row_temp <= row_temp + "1";
	else
	column_temp <= column_temp + "1";
	end if;

	if FAOOF_temp = '1' then
	for i in 0 to 255-32 loop
		if in_dat(255-i downto 255-31-i) = long_fas then --hvis lang FAS fundet
			if (column_temp = "0000001" and row_temp = "00") or (row_temp = "11" and column_temp = "1111111") or (row_temp = "11" and column_temp = "1111110")then
				if (index_check = i) or long_faoof = "00" then
				long_faoof <= long_faoof + "1";
				column_temp <= "0000000";
				index <= i-8;
				index_check <= i;
				else
				long_faoof <= "01";
				column_temp <= "0000000";
				index <= i-8;
				index_check <= i;
				end if;
				exit; --exit loop

			else -- nulstiller hvis den ikke findes på korrekt index
				long_faoof <= "00";
report "The value of 'a' is " & integer'image(index+1);
			end if;
--			cnt_frame_510 <= 1;

		elsif long_faoof = "01" and column_temp = "1111111" and row_temp = "11" then
			long_faoof <= "00";
		end if;
	end loop;
	end if; -- faoof = '1' loop

	if long_faoof = "10" then
		long_faoof <= "00";
		FAOOF_temp <= '0';
	end if;
	
if FAOOF_temp = '0' then
  if (row_temp = "11" and column_temp = "1111111")then
    for i in 0 to 255-24 loop
      if in_dat(255-i downto 255-23-i) = short_fas then
	report "The value of 'i' is " & integer'image(i);
	report "The value of 'i-16' is " & integer'image(i-16);
	report "The value of 'index' is " & integer'image(index);
	if (i-16 = index) then
	  report "short FAS found, correct index";
	  column_temp <= "0000000";
	  FAOOF_temp <= '0';
	  exit;
	else
	  report "short FAS found, WRONG index " & integer'image(i); 
	  short_error_cnt <= short_error_cnt + "1";
	  if short_error_cnt = "11" then
	    FAOOF_temp <= '1';
	  end if;
	end if;
      elsif i = 255-24 then
	report "short FAS not found " & integer'image(i);
	short_error_cnt <= short_error_cnt + "1";
	if short_error_cnt = "11" then
	  FAOOF_temp <= '1';
	end if;
      end if;
    end loop;
  end if;
end if;
	

	if index = 0 then
		out_dat <= in_dat_buffer;
	elsif index > 0 then
		out_dat <= in_dat_buffer(255-index downto 0) & in_dat(255 downto 255-index+1);
	end if;

column <= column_temp;
row <= row_temp;
end if;


end process;
FAOOF <= FAOOF_temp;

end architecture;
