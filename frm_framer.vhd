library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;
entity frm_framer is
	port(
	clk		: in std_logic;
	rst		: in std_logic;
	in_dat		: in std_logic_vector(255 downto 0);
	in_val		: in std_logic;
	out_val		: out std_logic;
	row		: out std_logic_vector(1 downto 0);
	column		: out std_logic_vector(6 downto 0);
	out_data	: out std_logic_vector(255 downto 0)
	);
end entity;


architecture fram_framer_arch of frm_framer is

component frm_align
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	FAOOF	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end component;

component frm_bip_8
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
end component;

signal 	clk_int		: std_logic;
signal 	rst_int		: std_logic;
signal	in_dat_align	: std_logic_vector(255 downto 0);
signal	in_dat_bip_8	: std_logic_vector(255 downto 0);
signal	out_val_int	: std_logic;
signal	out_val_bip_8	: std_logic;
signal	in_val_bip_8	: std_logic;
signal	FAOOF_int	: std_logic;
signal	row_out		: std_logic_vector(1 downto 0);
signal	row_in		: std_logic_vector(1 downto 0);
signal	column_int	: std_logic_vector(6 downto 0);
signal	out_dat_align	: std_logic_vector(255 downto 0);
signal	out_dat_bip_8	: std_logic_vector(255 downto 0);
signal 	bip_err_int	: std_logic;



begin

in_dat_align <= in_dat;
clk_int <= clk;
rst_int <= rst;
out_data <= out_dat_align;
column <= column_int;
row <= row_out;
row_in <= row_out;
in_dat_bip_8 <= out_dat_align;
in_val_bip_8 <= FAOOF_int;

DUT_align : frm_align port map (clk_int,rst_int,in_dat_align,FAOOF_int,row_out,column_int,out_dat_align);
DUT_BIP_8 : frm_bip_8 port map (clk_int,rst_int,in_dat_bip_8,in_val_bip_8,out_val_bip_8,bip_err_int,row_in,column_int,out_dat_bip_8);
--process(clk)
--begin
--out_data <= out_dat_int;
--end process;


end architecture;