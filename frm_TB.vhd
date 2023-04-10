library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;
use work.frm_test_util.all;

entity frm_TB is

end entity;


architecture frm_TB_arch of frm_TB is

component frm_framer
	port(
	clk	: in std_logic;
	rst	: in std_logic;
	in_dat	: in std_logic_vector(255 downto 0);
	in_val	: in std_logic;
	out_val	: out std_logic;
	row	: out std_logic_vector(1 downto 0);
	column	: out std_logic_vector(6 downto 0);
	out_data: out std_logic_vector(255 downto 0)
	);
end component;

component frm_gen
  port (
    clk         : in    std_logic;
    reset       : in    std_logic;
    out_data    : out   std_logic_vector(255 downto 0);
    stat        : out   gen_stat_type;
    test_conf   : in    test_config_type; 
    otn_oh      : in    otn_overhead_type
    );
end component;
signal	  stat_TB	 	:    gen_stat_type;
signal    test_conf_TB   	:    test_config_type; 
signal    otn_oh_TB      	:    otn_overhead_type;
signal	  clk_TB,reset_TB       :    std_logic;
signal	  out_data_TB    	:    std_logic_vector(255 downto 0);


signal	in_dat_dut_TB	: std_logic_vector(255 downto 0);
signal	out_dat_gen_TB	: std_logic_vector(255 downto 0);
signal	in_val_TB	: std_logic;
signal	out_val_TB	: std_logic;
signal	row_TB		: std_logic_vector(1 downto 0);
signal	column_TB	: std_logic_vector(6 downto 0);


begin
frm_gen1 : frm_gen port map(clk_TB,reset_TB,out_dat_gen_TB,stat_TB,test_conf_TB,otn_oh_TB);
DUT	 : frm_framer port map(clk_TB,reset_TB,in_dat_dut_TB,in_val_TB,out_val_TB,row_TB,column_TB,out_data_TB);
	in_dat_dut_TB <= out_dat_gen_TB;
      test_conf_TB.conf 	    <= "00";            
      test_conf_TB.cbr_map     	    <='1';     
      test_conf_TB.prbs             <='0';
      test_conf_TB.clk_mode         <=0;
      test_conf_TB.disable_gen      <='0';
      test_conf_TB.disable_ana      <='0';
      test_conf_TB.otn_scr_inh_gen  <='0';
      test_conf_TB.otn_scr_inh_ana  <='0'; 
      test_conf_TB.txt    	    <="00";

      otn_oh_TB.frm_nr       <=  (others => '0');
      otn_oh_TB.row          <=  0;
      otn_oh_TB.col          <=  0;
      otn_oh_TB.data         <=  (others => '0');
--      otn_oh_TB.fas_pos      <=  511;
 
--      otn_oh_TB.FAS          <=  x"f6f6f6282828";
      otn_oh_TB.MFAS         <=  (others => '0');
      otn_oh_TB.SM_TTI       <=  (others => '0');
      otn_oh_TB.SM_BIP8      <=  (others => '0');
      otn_oh_TB.SM_AUX       <=  (others => '0');
      otn_oh_TB.GCC0         <=  (others => '0');
      otn_oh_TB.OTU3_RES     <=  (others => '0');
      otn_oh_TB.OPU3_RES1    <=  (others => '0');
      otn_oh_TB.OPU3_JC1     <=  (others => '0');
      
      otn_oh_TB.ODU3_RES1    <=  (others => '0');
      otn_oh_TB.TCM_ACT      <=  (others => '0');

      otn_oh_TB.TCM6_TTI     <=  (others => '0');
      otn_oh_TB.TCM6_BIP8    <=  (others => '0');
      otn_oh_TB.TCM6_AUX     <=  (others => '0');
              
      otn_oh_TB.TCM5_TTI     <=  (others => '0');
      otn_oh_TB.TCM5_BIP8    <=  (others => '0');
      otn_oh_TB.TCM5_AUX     <=  (others => '0');
              
      otn_oh_TB.TCM4_TTI     <=  (others => '0');
      otn_oh_TB.TCM4_BIP8    <=  (others => '0');
      otn_oh_TB.TCM4_AUX     <=  (others => '0');
              
      otn_oh_TB.FTFL         <=  (others => '0');

      otn_oh_TB.OPU3_RES2    <=  (others => '0');
      otn_oh_TB.OPU3_JC2     <=  (others => '0');

      otn_oh_TB.TCM3_TTI     <=  (others => '0');
      otn_oh_TB.TCM3_BIP8    <=  (others => '0');
      otn_oh_TB.TCM3_AUX     <=  (others => '0');
              
      otn_oh_TB.TCM2_TTI     <=  (others => '0');
      otn_oh_TB.TCM2_BIP8    <=  (others => '0');
      otn_oh_TB.TCM2_AUX     <=  (others => '0');
              
      otn_oh_TB.TCM1_TTI     <=  (others => '0');
      otn_oh_TB.TCM1_BIP8    <=  (others => '0');
      otn_oh_TB.TCM1_AUX     <=  (others => '0');
                
      otn_oh_TB.PM_TTI       <=  (others => '0');
      otn_oh_TB.PM_BIP8      <=  (others => '0');
      otn_oh_TB.PM_AUX       <=  (others => '0');
                         
      otn_oh_TB.EXP          <=  (others => '0');

      otn_oh_TB.OPU3_RES3    <=  (others => '0');
      otn_oh_TB.OPU3_JC3     <=  (others => '0');
 
      otn_oh_TB.GCC1         <=  (others => '0');
      otn_oh_TB.GCC2         <=  (others => '0');
              
      otn_oh_TB.APS          <=  (others => '0');
      otn_oh_TB.ODU3_RES2    <=  (others => '0');
              
      otn_oh_TB.PT           <=  (others => '0');
      otn_oh_TB.vcPT         <=  (others => '0');
      
      otn_oh_TB.STM_A1       <=  (others => '0');
      otn_oh_TB.STM_A2       <=  (others => '0');
      
      otn_oh_TB.STM_BIP8     <=  (others => '0');
      otn_oh_TB.STM_J0       <=  (others => '0');
      otn_oh_TB.STM_J0_SEQ   <=  (others => '0');
      
      otn_oh_TB.jc_seq       <=  (others => '0');
      
      otn_oh_TB.demap        <=  (others => '0');
      otn_oh_TB.demap_stm    <=  (others => '0');
      
      otn_oh_TB.otu3ais      <=  (others => '0');
      otn_oh_TB.odu3ais      <=  (others => '0');
      otn_oh_TB.odu3oci      <=  (others => '0');
      otn_oh_TB.odu3lck      <=  (others => '0');
                 
      otn_oh_TB.cbr_ais      <=  (others => '0');

    process(stat_TB.frm_nr)
	begin
	case to_integer(unsigned(stat_TB.frm_nr)) is
	when 0 =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 1 =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 2 =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 3 =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  510;
	when 4 => 
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 5 => 
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 6 =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	when 7 =>
		otn_oh_TB.FAS <= x"FFFFFFFFFFFF";
		otn_oh_TB.fas_pos <=  510;
	when 8 => 
		otn_oh_TB.FAS <= x"FFFFFFFFFFFF";
		otn_oh_TB.fas_pos <=  511;
	when 9 =>
		otn_oh_TB.FAS <= x"FFFFFFFFFFFF";
		otn_oh_TB.fas_pos <=  510;
	when 10 =>
		otn_oh_TB.FAS <= x"FFFFFFFFFFFF";
		otn_oh_TB.fas_pos <=  511;
	when 11=>
		otn_oh_TB.FAS <= x"FFFFFFFFFFFF";
		otn_oh_TB.fas_pos <=  511;
	when others =>
		otn_oh_TB.FAS <= x"F6F6F6282828";
		otn_oh_TB.fas_pos <=  511;
	end case;

    end process;


    clk_STIM : PROCESS
    BEGIN
        clk_TB <= '0';
        WAIT FOR 5 ns;
        clk_TB <= '1';
        WAIT FOR 5 ns;
    END PROCESS;

    rst_STIM : PROCESS
    BEGIN
        reset_TB <= '1';
        WAIT FOR 7 ns;
        reset_TB <= '0';
        WAIT;
    END PROCESS;
    

     
end architecture;