library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
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
	out_val	: out std_logic;
	FAOOF	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end component;

signal 	clk_int		: std_logic;
signal 	rst_int		: std_logic;
signal	in_dat_int	: std_logic_vector(255 downto 0);
signal	out_val_int	: std_logic;
signal	FAOOF_int	: std_logic;
signal	row_int		: std_logic_vector(1 downto 0);
signal	column_int	: std_logic_vector(6 downto 0);
signal	out_dat_int	: std_logic_vector(255 downto 0);

begin

in_dat_int <= in_dat;
clk_int <= clk;
rst_int <= rst;

DUT_align : frm_align port map (clk_int,rst_int,in_dat_int,out_val_int,FAOOF_int,row_int,column_int,out_dat_int);



end architecture;