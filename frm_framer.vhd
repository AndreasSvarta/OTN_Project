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
	--out_val	: out std_logic;
	FAOOF	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end component;

component frm_scramble
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	in_val	: in std_logic;
	out_val	: out std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0);
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

component frm_demap
port (
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	in_val	: in std_logic;
	row	: in std_logic_vector(1 downto 0);
	column	: in std_logic_vector(6 downto 0);
	out_dat	: out std_logic_vector(255 downto 0)
	);
end component;


signal	out_val_int	: std_logic;
signal	in_val_int	: std_logic;
signal	FAOOF_int	: std_logic;
signal	row_int		: std_logic_vector(1 downto 0);
signal	column_int	: std_logic_vector(6 downto 0);
signal  bip_err_int	: std_logic;

signal  out_dat_align  		: std_logic_vector(255 downto 0);
signal	out_dat_scramble	: std_logic_vector(255 downto 0);
signal  out_dat_bip_8		: std_logic_vector(255 downto 0);
signal  out_dat_demap		: std_logic_vector(255 downto 0);


begin



DUT_align    : frm_align	port map (clk,
					  rst,
					  in_dat,
					  FAOOF_int,
					  row_int,
					  column_int,
					  out_dat_align);
DUT_scramble : frm_scramble 	port map (clk,
					  rst,
					  out_dat_align,
					  in_val_int,
					  out_val_int,
					  row_int,
					  column_int,
					  out_dat_scramble);
--DUT_BIP_8    : frm_bip_8 	port map (clk,
--					  rst,
--					  out_dat_scramble,
--					  in_val_int,
--					  out_val_int,
--					  bip_err_int,
--					  row_int,
--					  column_int,
--					  out_dat_bip_8);
--DUT_demap    : frm_demap	port map (clk,
--					  rst,
--					  out_dat_scramble, -- skal være bip_8
--					  in_val_int,
--					  row_int,
--					  column_int,
--					  out_dat_demap);


out_data <= out_dat_scramble; -- til analyzer, skal være sidste output i bussen


end architecture;