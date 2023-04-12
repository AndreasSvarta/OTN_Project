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
	FAOOF	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture frm_align_arch of frm_align is

signal in_dat_buffer 	: std_logic_vector(255 downto 0);
signal column_temp 	: std_logic_vector(6 downto 0):="1111010";
signal row_temp		: std_logic_vector(1 downto 0):="11";
signal long_fas 	: std_logic_vector(31 downto 0):=x"F6F62828";
signal short_fas 	: std_logic_vector(23 downto 0):=x"F62828";
signal long_faoof	: std_logic_vector(1 downto 0):="00";
signal short_faoof	: std_logic :='0';
signal short_error_cnt	: std_logic_vector(1 downto 0):="00";
signal FAOOF_temp 	: std_logic:='1';
signal index		: std_logic_vector(7 downto 0):="00000000";
--signal index_faoof_0	: std_logic_vector(7 downto 0):="00000000";
signal index_check	: integer range -8 to 255 :=0;
signal in_dat_512	: std_logic_vector(511 downto 0);
signal out_dat_temp	: std_logic_vector(255 downto 0);

begin

--in_dat_buffer <= in_dat;

in_dat_512 <= in_dat_buffer & in_dat;
process(clk,rst)
begin

if rising_edge(clk) and rst = '0' then
	in_dat_buffer <= in_dat;

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
--	for i in 0 to 255-31 loop
	for i in 0 to 255 loop
		if in_dat_512(511-i downto 511-31-i) = long_fas then --hvis lang FAS fundet
--		if in_dat(255-i downto 255-31-i) = long_fas then --hvis lang FAS fundet
report "The value of 'i' is " & integer'image(i);
report "The value of 'index_check' is " & integer'image(index_check);
report "The value of 'index_check+8' is " & integer'image(index_check+8);
			if (row_temp = "11" and column_temp = "1111111") then
				if (index_check = i) then
					long_faoof <= long_faoof + "1";
					report "nue r vi her";
				else
					report "eler måske her";
					long_faoof <= "01";
				end if;
				column_temp <= "0000000";
				index <= i-"00001000";
				index_check <= i;
				exit; --exit loop

			else -- nulstiller hvis den ikke findes på korrekt index, men dog findes
				column_temp <= "0000000";
				row_temp <= "00";
				long_faoof <= "01";
report "The value of 'a' is " & integer'image(to_integer(unsigned(index)));
			end if;

		elsif long_faoof = "01" and column_temp = "1111111" and row_temp = "11" then
			long_faoof <= "00";
		end if;
	end loop;
  out_dat_temp <= in_dat_512(511-to_integer(unsigned(index)) downto 511-255-to_integer(unsigned(index)));
end if; -- faoof = '1' loop

	if long_faoof = "10" then
		long_faoof <= "00";
		FAOOF_temp <= '0';
	end if;
	
if FAOOF_temp = '0' then
  if (row_temp = "11" and column_temp = "1111111")then
    if in_dat_512(511-to_integer(unsigned(index))-16 downto 511-23-to_integer(unsigned(index))-16) = short_fas then
	report "Short fas at correct index found";
	short_error_cnt <= "00";
    else
	report "Short fas NOT found or not at correct index";
	short_error_cnt <= short_error_cnt + "1";
	if short_error_cnt = "11" then
	  FAOOF_temp <= '1';
	end if;
    end if;
  end if;
  out_dat_temp <= in_dat_512(511-to_integer(unsigned(index)) downto 511-255-to_integer(unsigned(index)));
end if;
	

--for i in 0 to 255 loop
--  if i = index then--    out_dat <= in_dat_buffer(255-i downto 0) & in_dat(255 downto 255-i+1);
--  end if;
--end loop;
--	if index = 0 then
--		out_dat <= in_dat_buffer;
--	elsif index > 0 then
		--out_dat <= in_dat_buffer(255-to_integer(unsigned(index)) downto 0) & in_dat(255 downto 255-to_integer(unsigned(index))+1);
--		out_dat <= in_dat_buffer(255 downto 0);
--	end if;
column <= column_temp;
row <= row_temp;
out_dat <= out_dat_temp;
end if;


end process;
FAOOF <= FAOOF_temp;

end architecture;
