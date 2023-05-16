library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use IEEE.NUMERIC_STD.all;

entity frm_demap is
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	out_val	: out std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture frm_demap_arch of frm_demap is


signal out_dat_temp	: std_logic_vector(255 downto 0);
signal buffelademad	: std_logic_vector(255 downto 0) := (others => '0');
signal bufferlength	: std_logic_vector(5 downto 0) := (others => '0');
signal delay 		: std_logic;
signal out_val_temp	: std_logic;
signal wrap_bit		: std_logic := '0';
signal wrap_bit2	: std_logic := '0';
signal another_bit 	: std_logic := '0';

signal pos_cnt		: std_logic_vector(1 downto 0);
signal neg_cnt		: std_logic_vector(1 downto 0);
signal zero_cnt		: std_logic_vector(1 downto 0);

signal thirtynineforty : std_logic_vector(6 downto 0);
signal seventynineeighty : std_logic_vector(6 downto 0);

begin

thirtynineforty   <= "0100111" + delay;
seventynineeighty <= "1001111" + delay;

process (clk)
variable plusminusone : signed(1 downto 0):= "00";
begin
if rising_edge(clk) then
bufferloop : for I in 0 to 32 loop
bufferif : if I = to_integer(unsigned(bufferlength)) then
if rst = '1' then
	delay <= '0';
	bufferlength <= "000000";
	neg_cnt <= "00";
	pos_cnt <= "00";
	zero_cnt <= "00";
end if;

if column = "0000000" and row < "11" then --JC
	if in_dat(135 downto 128) = x"01" then
		neg_cnt <= neg_cnt + 1;
	elsif in_dat(135 downto 128) = x"00" then
		zero_cnt <= zero_cnt + 1;
	elsif in_dat(135 downto 128) = x"03" then
		pos_cnt <= pos_cnt + 1;
	end if;
end if;




if column = "0000000" then
	if row = "11" then
		if neg_cnt > "01" then
			bufferlength <= bufferlength + 17;
			plusminusone := plusminusone + 1;
			another_bit <= '0';
				if bufferlength < "10000" then
					buffelademad(127 - (I mod 16) * 8 downto 120 - (I mod 16) * 8) <= in_dat(7 downto 0);
				else
					buffelademad(255 - (I mod 16) * 8 downto 248 - (I mod 16) * 8) <= in_dat(7 downto 0);
				end if;	

		elsif pos_cnt > "01" then
			bufferlength <= bufferlength + 15;
			plusminusone := plusminusone - 1;
			if bufferlength > "10000" and another_bit = '0' then
				another_bit <= '1';
				bufferlength <= bufferlength - 17;
			elsif bufferlength <= "10000" and another_bit = '1' then
				bufferlength <= bufferlength + 15;
			elsif another_bit = '1' then
				bufferlength <= bufferlength - 17;
			end if;


		elsif zero_cnt > "01" then
			bufferlength <= bufferlength + 16;
			plusminusone := "00";
		end if;
	else
		if bufferlength = "01111" and delay = '0' then
			buffelademad(255 - (I mod 16) * 8 downto 248 - (I mod 16) * 8) <= in_dat(127 downto 120);
		end if;

		bufferlength <= bufferlength + 16 + to_integer(signed(plusminusone));
		if bufferlength > "00000" and bufferlength < "01111" and delay ='0' then
			buffelademad(255 - (I mod 16) * 8 downto 128 - (I mod 16) * 8) <= in_dat(127 downto 0);
		elsif bufferlength = "00000" and wrap_bit = '0' then
			buffelademad(255 downto 128) <= in_dat(127 downto 0);
		elsif bufferlength = "00000" and wrap_bit = '1' and delay = '0' then
			buffelademad(255 downto 128) <= in_dat(127 downto 0);
			wrap_bit <= '0';
		end if;
	end if;

	if bufferlength > "01111" and to_integer(signed(plusminusone)) /= -1 then -- 15		
		if bufferlength /= "10000" then			
			out_val_temp <= '0';
		elsif bufferlength = "10000" then
			out_val_temp <= '0';
			out_dat_temp <= buffelademad(255 downto 128) & in_dat(127 downto 0);
		end if;
		bufferlength <= bufferlength - 16 + to_integer(signed(plusminusone));
		plusminusone := "00";
		if delay = '0' then
			report "hej";
			out_dat_temp <= buffelademad(255 downto 128 - (I mod 16) * 8) & in_dat(127 downto (I mod 16) * 8);
			buffelademad(255 downto 255 - (I mod 16) * 8 + 1) <= in_dat((I mod 16) * 8 - 1 downto 0);		
		elsif delay = '1' then
			out_val_temp <= '1';
		end if;
		if pos_cnt > "01" then 
			buffelademad(255 downto 255 - (I mod 16) * 8 + 1) <= in_dat((I mod 16) * 8 - 1 downto 0);
		end if;
	elsif bufferlength = "01111" and neg_cnt > "01" then
		out_val_temp <= '0';
		out_dat_temp <= buffelademad(255 downto 8) & in_dat(7 downto 0);		
	else
		out_val_temp <= '1';
	end if;	

elsif column = thirtynineforty or column = seventynineeighty then --39//79
	if delay = '0' then
		bufferlength <= bufferlength + 16;
		if bufferlength > "00000" and bufferlength < "10000" then
			buffelademad(255 - (I mod 16) * 8 downto 128 - (I mod 16) * 8) <= in_dat(255 downto 128);
		else
			buffelademad(255 downto 128) <= in_dat(255 downto 128);
		end if;
		if bufferlength > "01111" then -- 15
			bufferlength <= bufferlength - 16;
			out_dat_temp <= buffelademad(255 downto 128 - (I mod 16) * 8) & in_dat(255 downto 128 + (I mod 16) * 8);
			buffelademad(255 downto 255 - (I mod 16) * 8 + 1) <= in_dat(128 + (I mod 16) * 8 - 1 downto 128);
		else 
			out_val_temp <= '1';
		end if;	

	elsif delay = '1' then --40//80
		bufferlength <= bufferlength + 16;
		if bufferlength > "00000" and bufferlength < "10000" then
			buffelademad(255 - (I mod 16) * 8 downto 128 - (I mod 16) * 8) <= in_dat(127 downto 0);
		else
			buffelademad(255 downto 128) <= in_dat(127 downto 0);
		end if;
		if bufferlength > "01111" then -- 15
			bufferlength <= bufferlength - 16;
			out_dat_temp <= buffelademad(255 downto 128 - (I mod 16) * 8) & in_dat(127 downto (I mod 16) * 8);
			buffelademad(255 downto 255 - (I mod 16) * 8 + 1) <= in_dat((I mod 16) * 8 - 1 downto 0);
		else 
			out_val_temp <= '1';
		end if;	
		if bufferlength = "100000" then
			out_val_temp <= '1';
		end if;
	end if;
end if;


if column /= "0000000" and column /= "00100111" + delay and column /= "01001111" + delay and column < "01111000" then

	if column = "01110111" and bufferlength < "10000" and pos_cnt > "00" and bufferlength /= "00000" and wrap_bit = '0' then 
		if bufferlength < "10000" and delay = '1' then
			out_val_temp <= '0';
			out_dat_temp <= buffelademad(255 downto 255 - I * 8 + 1) & in_dat(255 downto I * 8);
			buffelademad(255 downto 255 - I * 8 + 1) <= in_dat(I * 8 - 1 downto 0);
		else
			out_val_temp <= '1';
			buffelademad(255 - I * 8 downto 0) <= in_dat(255 downto 255 - (32 - I) * 8 + 1);
		end if;
	elsif column = "01110111" and bufferlength < "10000" and delay = '0' then 
		if wrap_bit = '0' then
			wrap_bit <= '1';
		end if; 
		out_val_temp <= '1';
		buffelademad(255 - I * 8 downto 128 ) <= in_dat(255 downto 255 - (16 - I) * 8 + 1);
	elsif bufferlength > "00000" then 
		out_val_temp <= '0';
		if row = "11" and column = "00000001" and neg_cnt < "10" and zero_cnt < "10" then
			if bufferlength = "11111" then
				out_val_temp <= '1';
			elsif bufferlength = "10000" and wrap_bit = '0' then
				out_dat_temp <= buffelademad(255 downto 120) & in_dat(255 - 8 downto 128);
			elsif bufferlength = "10000" and wrap_bit = '1' and delay = '0' then
				out_dat_temp <= buffelademad(255 downto 136) & in_dat(247 downto 112);
			else 
				--out_dat_temp <= buffelademad(255 downto abs((32-(I + 1)) * 8)) & in_dat(247 downto I * 8);		
			end if;
		else
				if bufferlength = "100000" then
					out_dat_temp <= in_dat;
				else
				out_dat_temp <= buffelademad(255 downto 255 - I * 8 + 1) & in_dat(255  downto I * 8);
				end if;	
		end if;
		buffelademad(255 downto 255 - I * 8 + 1) <= in_dat(I * 8 - 1 downto 0);
		plusminusone := "00";
	else
		if bufferlength = "00000" and row = "11" and column = "00000001" and pos_cnt > "01" then
			out_val_temp <= '0';
			out_dat_temp <= buffelademad(255 downto 255 - 7) & in_dat(255 - 8 downto 0);		
		else

			out_val_temp <= '0';
			out_dat_temp <= in_dat;
		end if;
	end if;

elsif column >= "01111000" then --120	
		out_val_temp <= '1';
		if column = "01111110" and delay = '0' then --126	
			delay <= '1';
		elsif column = "01111111" and delay = '1' then --127
			delay <= '0';
		end if;

		if row = "11" then
			neg_cnt <= "00";
			pos_cnt <= "00";
			zero_cnt <= "00";
		end if;
end if;


end if;
end loop;

end if;
end process;

out_val <= out_val_temp;
out_dat <= out_dat_temp when out_val_temp = '0';

end architecture;