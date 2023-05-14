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
	--out_val	: out std_logic;
	bip_err : out std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0)
	);
end entity;


architecture frm_bip_8_arch of frm_bip_8 is

signal bip_err_temp_sig	: std_logic_vector(7 downto 0);
--signal bip_err_temp_0 	: std_logic:='0';
signal in_dat_temp 	: std_logic_vector(255 downto 0);

type   	array_mux is array (0 to 3) of std_logic_vector(7 downto 0);
signal 	bip_err_array  		: array_mux := (others=>(others=>'0'));
--signal 	observed_SM_BIP_8 	: array_mux := (others=>(others=>'0'));
signal  observed_SM_BIP_8_sig	: std_logic_vector(7 downto 0);
signal 	fejl_BIP_8		: std_logic_vector(7 downto 0):="00000000";
signal 	frame_cnt		: std_logic_vector(1 downto 0):="00";

begin

in_dat_temp <= in_dat;

process (clk,rst)

variable bip_err_temp 	: std_logic_vector(7 downto 0) := "00000000";
variable test	 	: std_logic_vector(7 downto 0) := "00000000";
variable txt		: LINE;

begin

if rising_edge(clk) then
--row_out <= row;
--column_out <= column;

	if rst = '1' then 
		bip_err <= '0';
		bip_err_temp := "00000000";
		--out_val <= '0';
--	elsif in_val = '0' and in_dat /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
	elsif in_dat /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
		if row = "00" and column = "0000000" then
			observed_SM_BIP_8_sig <= in_dat_temp(191 downto 184);
		end if;
		if row = "11" and column = "1111110" then
			if bip_err_temp_sig /= "UUUUUUUU" then
				bip_err_array(to_integer(unsigned(frame_cnt))) <= bip_err_temp_sig;
			end if;


		end if;
		if row = "11" and column = "1111111" then
			fejl_BIP_8 <= bip_err_array(to_integer(unsigned(frame_cnt-"10"))) xor observed_SM_BIP_8_sig;
			if (bip_err_array(to_integer(unsigned(frame_cnt-"10"))) xor observed_SM_BIP_8_sig) /= "0000000" then
				bip_err <= '1';
			else 
				bip_err <= '0';
			end if;

			if in_val = '0' then
				frame_cnt <= frame_cnt + "1";
			end if;
			bip_err_temp := "00000000"; 
		end if;
		if row = "00" or row = "10" then
		if column = "0000000" then
			for i in 17 downto 0 loop -- skip ODU3 overhead
			test := in_dat_temp(8*i+7 downto 8*i);
--			----report "HDR The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
--			----report "HDR The value of 'in_dat_temp(i*8...)' is " & " - " & to_hstring(test);		
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);
--			----report "The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
			end loop;
			----report "HEADER START - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);		
		elsif column = "1110111" then
			for i in 31 downto 16 loop
			test := in_dat_temp(8*i+7 downto 8*i);
--			----report "FEC The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
--			----report "FEC The value of 'in_dat_temp(i*8...)' is " & " - " & to_hstring(test);		
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);		
			end loop;
			----report "FEC START - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);	
		elsif column > "1110111" then
			-- skip FEC
			----report "FEC SKIP - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);	
		elsif column = "1111111" then
			for i in 1 downto 0 loop
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);		
			end loop;
			----report "COLUMN 127 last 2 byte 'bip_err_temp' is " & to_hstring(bip_err_temp);	
		else
			for i in 31 downto 0 loop -- for data
			test := in_dat_temp(8*i+7 downto 8*i);
--			----report "DATA The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
--			----report "DATA The value of 'in_dat_temp(i*8...)' is " & " - " & to_hstring(test);		
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);
			end loop;
			----report "DATA - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);	
		end if;

		elsif row = "01" or row = "11" then
			if column = "0000000" then
			for i in 31 downto 11 loop -- lidt usikker p� om det skal v�re til 17, men i hvert fald ikke til 0. virker ned til 11
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);			
			----report "TEST 01|11 of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
			end loop;
			elsif column = "1110110" then
			for i in 31 downto 0 loop -- skip ODU3 overhead
			test := in_dat_temp(8*i+7 downto 8*i);
--			----report "FEC 01|11 The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
--			----report "FEC 01|11 The value of 'in_dat_temp(i*8...)' is " & " - " & to_hstring(test);		
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);
			----report "The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
			end loop;
			----report "HEADER START - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);		
			elsif column > "1110111" then
			----report "SKIP FEC 01|11";
			else
			for i in 31 downto 0 loop
--			----report "DATA 01|11 The value of 'i' and 'bip_err_temp' is " & integer'image(i) & " - " & to_hstring(bip_err_temp);		
--			----report "DATA 01|11 The value of 'in_dat_temp(i*8...)' is " & " - " & to_hstring(test);		
			bip_err_temp(0) := bip_err_temp(0) xor in_dat_temp(8*i);
			bip_err_temp(1) := bip_err_temp(1) xor in_dat_temp(8*i+1);
			bip_err_temp(2) := bip_err_temp(2) xor in_dat_temp(8*i+2);
			bip_err_temp(3) := bip_err_temp(3) xor in_dat_temp(8*i+3);
			bip_err_temp(4) := bip_err_temp(4) xor in_dat_temp(8*i+4);
			bip_err_temp(5) := bip_err_temp(5) xor in_dat_temp(8*i+5);
			bip_err_temp(6) := bip_err_temp(6) xor in_dat_temp(8*i+6);
			bip_err_temp(7) := bip_err_temp(7) xor in_dat_temp(8*i+7);
			end loop;
			----report "DATA 01|11 - The value of 'bip_err_temp' is " & to_hstring(bip_err_temp);	
			end if;
		end if;
		bip_err_temp_sig <= bip_err_temp;
     		----report "frm_bip8: " & to_hstring(unsigned(bip_err_temp));
	end if;

end if;
end process;

end architecture;