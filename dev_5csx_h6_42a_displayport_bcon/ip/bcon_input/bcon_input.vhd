--- Title: bcon_input.vhd
---
---
---     o  0
---     | /       Copyright (c) 2016
---    (CL)---o   Critical Link, LLC
---      \
---       O
---
--- Company: Critical Link, LLC.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
library WORK;
use work.trig_gen_pkg.ALL;
use work.bcon_pkg.ALL;

LIBRARY altera_mf;
USE altera_mf.all;

entity bcon_input is
	generic
	(
		g_lane_invert : std_logic_vector(4 downto 0) := "00000"
	);
	port 
	(
		i_register_clock : in  std_logic;
		i_data_clock : in std_logic; 
		o_pixel_clock : out std_logic; 

		i_rst : in std_logic;

		-- register access interface
		i_reg_addr : in  std_logic_vector(4 downto 0);
		i_reg_read_en : in  std_logic;
		i_reg_write_en : in  std_logic;
		i_reg_writedata : in  std_logic_vector(31 downto 0);
		o_reg_readdata : out std_logic_vector(31 downto 0);
		o_reg_waitrequest : out std_logic;

		-- data_out interface
		o_data_out_data : out std_logic_vector(31 downto 0);
		o_data_out_startofpacket : out std_logic;
		o_data_out_valid : out std_logic;
		o_data_out_endofpacket : out std_logic;
		i_data_out_ready : in std_logic;
		
		-- video_out interface (conduit)
		o_line_valid  : out std_logic;
		o_frame_valid : out std_logic;
		o_data_valid  : out std_logic;
		o_data        : out std_logic_vector(23 downto 0);

		-- PLL reconfig
		reconfig_to_pll   : in  std_logic_vector(63 downto 0) := (others => 'X'); -- reconfig_to_pll
		reconfig_from_pll : out std_logic_vector(63 downto 0);                    -- reconfig_from_pll

		-- timestamp
		i_timestamp : in std_logic_vector(31 downto 0);
		i_timestamp_slow : in std_logic_vector(31 downto 0);
		o_stamp_latch : out std_logic;
		o_stamp_marker : out std_logic_vector(31 downto 0);

		-- bcon_bm_interface
		i_bcon_x : in std_logic_vector(3 downto 0);
		i_bcon_xclk : in std_logic;
		o_bcon_cc : out std_logic;
		o_fpga_trig : out std_logic  -- one of CC lines (selectable) routed to GPIO alt_input
	);
end entity bcon_input;

architecture rtl of bcon_input is

	------------------------------------------------------------------------------
	-- Constants
	------------------------------------------------------------------------------
	constant VERS_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
	constant CTRL_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, 5));
	constant SIZE_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(2, 5));
	constant ROIS_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(3, 5));
	constant TCTL_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(4, 5));
	constant T1C_REG_OFFSET : std_logic_vector(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(5, 5));

	-- VERSION HISTORY
	-- 0x00010000 - Initial code.
	constant VERSION : std_logic_vector(31 downto 0) := x"00010000";

	component altlvdsrx_5x7
		PORT
		(
			rx_channel_data_align		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			rx_enable		: IN STD_LOGIC ;
			rx_in		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			rx_inclock		: IN STD_LOGIC ;
			rx_out		: OUT STD_LOGIC_VECTOR (34 DOWNTO 0)
		);
	end component;

	component pll_1x7_reconfig is
		port (
			refclk            : in  std_logic                     := 'X';             -- clk
			rst               : in  std_logic                     := 'X';             -- reset
			outclk_0          : out std_logic;                                        -- clk
			outclk_1          : out std_logic;                                        -- clk
			outclk_2          : out std_logic;                                        -- clk
			locked            : out std_logic;                                        -- export
			reconfig_to_pll   : in  std_logic_vector(63 downto 0) := (others => 'X'); -- reconfig_to_pll
			reconfig_from_pll : out std_logic_vector(63 downto 0)                     -- reconfig_from_pll
		);
	end component pll_1x7_reconfig;

	COMPONENT dcfifo
	GENERIC (
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		rdsync_delaypipe		: NATURAL;
		underflow_checking		: STRING;
		use_eab		: STRING;
		wrsync_delaypipe		: NATURAL
	);
	PORT (
			aclr	: IN std_logic := '0';
			data	: IN STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			rdclk	: IN STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			wrfull	: OUT STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC 
	);
	END COMPONENT;

	component cyclonev_pll_lvds_output
	generic (
		pll_loaden_enable_disable  : STRING;
		pll_lvdsclk_enable_disable : STRING
	);
	port (
		ccout           : in  std_logic_vector (1 downto 0);
		loaden          : out std_logic ;
		lvdsclk         : out std_logic 
	);
	end component;
	
	------------------------------------------------------------------------------
	-- Signals
	------------------------------------------------------------------------------
	type t_state is 
		(
			IDLE,
			TRANSMIT_DATA
		);
	signal s_state : t_state := IDLE;

	signal s_bcon_mode_reg : unsigned(3 downto 0) := BCON_8x1;
	signal s_bcon_mode_reg_m : unsigned(3 downto 0) := BCON_8x1;
	signal s_bcon_mode_reg_m1 : unsigned(3 downto 0) := BCON_8x1;


	type t_output_state is 
		(
			OUTPUT_IDLE,
			SEND_HEADER,
			SEND_FRAME
		);
	signal s_output_state : t_output_state := OUTPUT_IDLE;

	signal s_srst_reg : std_logic := '1';
	signal s_enable_reg : std_logic := '1';
	signal s_pll_rst_reg : std_logic := '1';
	signal s_pll_x_locked_reg : std_logic := '0';
	signal s_xclk_locked_reg : std_logic := '0';  -- when '1', means X lanes are locked / bit aligned
	signal s_xclk_locked_reg_m : std_logic := '0';  -- when '1', means X lanes are locked / bit aligned
	signal s_xclk_notlocked_sticky_reg : std_logic := '0';  -- when '1', means X lanes are locked / bit aligned
	signal s_roi_col_start_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_row_start_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_col_start_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_row_start_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_col_start_reg_m1 : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_row_start_reg_m1 : unsigned(11 downto 0) := (others=>'0');
	signal s_num_rows_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_num_rows_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_num_cols_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_num_cols_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_col_end_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_row_end_reg : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_col_end_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_roi_row_end_reg_m : unsigned(11 downto 0) := (others=>'0');
	signal s_trig_clk_div_reg : unsigned(3 downto 0) := to_unsigned(1, 4);
	signal s_clk_period_reg : unsigned(15 downto 0) := to_unsigned(1, 16);
	signal s_cc_compare_strt_reg : compare_array := (others=>(others=>'0'));
	signal s_cc_compare_end_reg :  compare_array := (others=>(others=>'0'));
	signal s_cc_en_reg : std_logic_vector(3 downto 0) := (others=>'0');
	signal s_cc_inv_reg : std_logic_vector(3 downto 0) := (others=>'0');
	signal s_cc_sel_reg : unsigned(1 downto 0) := to_unsigned(1, 2);

	signal s_x_channel_data_align : std_logic_vector(4 downto 0) := (others=>'0');
	signal s_x_enable : std_logic := '0';
	signal s_x_inclock : std_logic := '0';
	signal s_x_out : std_logic_vector(27 downto 0) := (others=>'0');
	signal s_x_clkout : std_logic_vector(6 downto 0) := (others=>'0');
	signal s_x_out_preinv : std_logic_vector(27 downto 0) := (others=>'0');
	signal s_x_clkout_preinv : std_logic_vector(6 downto 0) := (others=>'0');
	signal s_x_rx_clk : std_logic := '0';
	signal s_x_locked : std_logic := '0';

	signal s_pix_cnt : unsigned(2 downto 0) := (others=>'0');

	signal s_fifo_data_in : std_logic_vector(35 downto 0) := (others => '1');
	signal s_fifo_data_rd : std_logic := '0';
	signal s_fifo_data_we : std_logic := '0';
	signal s_fifo_data_we_r1 : std_logic := '0';
	signal s_fifo_data_full : std_logic := '0';
	signal s_fifo_data_full_reg : std_logic := '0';
	signal s_fifo_data_full_reg_m : std_logic := '0';
	signal s_fifo_data_full_sticky_reg : std_logic := '0';
	signal s_fifo_data_out : std_logic_vector(35 downto 0) := (others => '0');
	signal s_fifo_data_out_r1 : std_logic_vector(35 downto 0) := (others => '0');
	signal s_fifo_data_empty : std_logic := '1';
	signal s_fifo_data_save : std_logic_vector(15 downto 0) := (others => '0');

	signal s_row_cnt : unsigned(11 downto 0) := (others=>'0');
	signal s_col_cnt : unsigned(11 downto 0) := (others=>'0');
	signal s_hdr_count : integer := 0;
	signal s_new_frame_tog_r1, s_new_frame_tog : std_logic := '0';
	signal s_new_frame_tog_r2, s_new_frame_tog_m : std_logic := '0';
	signal s_frame_index : unsigned(31 downto 0) := (others=>'0');
	signal s_x_lval, s_x_lval_r1 : std_logic := '0';
	signal s_x_fval, s_x_fval_r1 : std_logic := '0';
	signal s_pixel_data_valid : std_logic := '0';
	signal s_eof, s_sof, s_eop : std_logic := '0';
	signal s_hdr_valid : std_logic := '0';
	signal s_hdr_data : std_logic_vector(31 downto 0) := (others=>'0');

	signal s_x_enable_unbuf : std_logic := '0';
	signal s_x_inclock_unbuf : std_logic := '0';
	signal s_align_clk : unsigned(3 downto 0) := (others=>'0');

	signal s_databits    : std_logic_vector(23 downto 0) := (others=>'0');
	signal s_databits_r1 : std_logic_vector(23 downto 0) := (others=>'0');
	signal s_databits_r2 : std_logic_vector(23 downto 0) := (others=>'0');
	signal s_outputs : std_logic_vector(1 downto 0) := (others=>'0');
	
begin

	o_reg_waitrequest <= '0'; -- Should never have a need to force wait.

	--! Process to handle register writes by the HPS.
	REG_WRITE_PROC : process(i_register_clock) 
	begin
		if rising_edge(i_register_clock) then
			if (i_reg_write_en = '1') then
				case i_reg_addr is
					when CTRL_REG_OFFSET =>
						s_srst_reg <= i_reg_writedata(0);
						s_pll_rst_reg <= i_reg_writedata(1);
						s_bcon_mode_reg <= unsigned(i_reg_writedata(11 downto 8));
						if i_reg_writedata(5) = '1' then
							s_xclk_notlocked_sticky_reg <= '0';
						end if;
						
						if i_reg_writedata(6) = '1' then
							s_fifo_data_full_sticky_reg <= '0';
						end if;

					when SIZE_REG_OFFSET =>
						s_num_cols_reg <= unsigned(i_reg_writedata(11 downto 0));
						s_num_rows_reg <= unsigned(i_reg_writedata(27 downto 16));

					when ROIS_REG_OFFSET =>
						s_roi_col_start_reg <= unsigned(i_reg_writedata(11 downto 0));
						s_roi_row_start_reg <= unsigned(i_reg_writedata(27 downto 16));

					when TCTL_REG_OFFSET =>
						s_trig_clk_div_reg <= unsigned(i_reg_writedata(3 downto 0));
						s_cc_en_reg <= i_reg_writedata(7 downto 4);
						s_cc_inv_reg <= i_reg_writedata(15 downto 12);
						s_cc_sel_reg <= unsigned(i_reg_writedata(9 downto 8));
						s_clk_period_reg <= unsigned(i_reg_writedata(31 downto 16));

					when T1C_REG_OFFSET =>
						s_cc_compare_strt_reg(0) <= unsigned(i_reg_writedata(15 downto 0));
						s_cc_compare_end_reg(0)  <= unsigned(i_reg_writedata(31 downto 16));

					when others => 
						null;
				end case;		
			else
				-- sticky bit on xclk lock drifting
				if s_xclk_locked_reg_m = '0' then
					s_xclk_notlocked_sticky_reg <= '1';
				end if;
				
				-- sticky bit for output FIFO full (FIFO overflow detection)
				if s_fifo_data_full_reg_m = '1' then
					s_fifo_data_full_sticky_reg <= '1';
				end if;
			end if;
		end if;
	end process REG_WRITE_PROC;

	--! Process to handle register reads by the HPS.
	REG_READ_PROC : process(i_register_clock) 
	begin
		if rising_edge(i_register_clock) then
			o_reg_readdata <= (others => '0');
			s_pll_x_locked_reg <= s_x_locked;
			s_xclk_locked_reg_m <= s_xclk_locked_reg;
			
			s_fifo_data_full_reg <= s_fifo_data_full;
			s_fifo_data_full_reg_m <= s_fifo_data_full_reg;

			s_roi_col_end_reg <= s_roi_col_start_reg + s_num_cols_reg;
			s_roi_row_end_reg <= s_roi_row_start_reg + s_num_rows_reg;

			if (i_reg_read_en = '1') then
				case i_reg_addr is
					when VERS_REG_OFFSET =>
						o_reg_readdata <= VERSION;

					when CTRL_REG_OFFSET =>
						o_reg_readdata(0) <= s_srst_reg;
						o_reg_readdata(1) <= s_pll_rst_reg;
						o_reg_readdata(2) <= s_pll_x_locked_reg;
						o_reg_readdata(4) <= s_xclk_locked_reg_m;
						o_reg_readdata(5) <= s_xclk_notlocked_sticky_reg;
						o_reg_readdata(6) <= s_fifo_data_full_sticky_reg;

						o_reg_readdata(11 downto 8) <= std_logic_vector(s_bcon_mode_reg);

					when SIZE_REG_OFFSET =>
						o_reg_readdata(11 downto 0) <= std_logic_vector(s_num_cols_reg);
						o_reg_readdata(27 downto 16) <= std_logic_vector(s_num_rows_reg);

					when ROIS_REG_OFFSET =>
						o_reg_readdata(11 downto 0) <= std_logic_vector(s_roi_col_start_reg);
						o_reg_readdata(27 downto 16) <= std_logic_vector(s_roi_row_start_reg);

					when TCTL_REG_OFFSET =>
						o_reg_readdata(3 downto 0) <= std_logic_vector(s_trig_clk_div_reg);
						o_reg_readdata(7 downto 4) <= s_cc_en_reg;
						o_reg_readdata(15 downto 12) <= s_cc_inv_reg;
						o_reg_readdata(9 downto 8) <= std_logic_vector(s_cc_sel_reg);
						o_reg_readdata(31 downto 16) <= std_logic_vector(s_clk_period_reg);

					when T1C_REG_OFFSET =>
						o_reg_readdata(15 downto 0) <= std_logic_vector(s_cc_compare_strt_reg(0));
						o_reg_readdata(31 downto 16) <= std_logic_vector(s_cc_compare_end_reg(0));

					when others => 
						o_reg_readdata <= (others => '0');
				end case;		
			end if;
		end if;
	end process REG_READ_PROC;


	-- see spec
	s_x_lval <= s_x_out(4);
	s_x_fval <= s_x_out(3);
	
	databit1 : for i in 0 to 6 generate
	begin
		s_databits(23 - i) <= s_x_out(21 + i);
	end generate;
	
	databit2 : for i in 0 to 6 generate
	begin
		s_databits(16 - i) <= s_x_out(14 + i);
	end generate;
	
	databit3 : for i in 0 to 6 generate
	begin
		s_databits(9 - i) <= s_x_out(7 + i);
	end generate;
	
	databit4 : for i in 0 to 2 generate
	begin
		s_databits(2 - i) <= s_x_out(i);
	end generate;
	
	s_outputs <= s_x_out(5) & s_x_out(6);

	o_stamp_marker <= (others=>'0');
	o_stamp_latch <= s_x_fval;

	o_line_valid  <= s_x_lval;
	o_frame_valid <= s_x_fval;
	o_data_valid  <= s_x_lval and s_x_fval;
	o_data        <= s_databits;

	-- TODO - this does not decode the frame info or checksum data
	bcon_state_machine : process(s_x_rx_clk)
	begin
		if rising_edge(s_x_rx_clk) then

			s_x_lval_r1 <= s_x_lval;
			s_x_fval_r1 <= s_x_fval;
			s_databits_r1 <= s_databits;
			s_databits_r2 <= s_databits_r1;
			s_pixel_data_valid <= '0';

			s_roi_row_start_reg_m <= s_roi_row_start_reg;
			s_roi_row_end_reg_m <= s_roi_row_end_reg;
			s_roi_col_start_reg_m <= s_roi_col_start_reg;
			s_roi_col_end_reg_m <= s_roi_col_end_reg;

			if s_srst_reg = '1' then
				s_new_frame_tog <= '0';
				s_state <= IDLE;
			else
				case s_state is
					when IDLE =>
						s_eof <= '0';
						s_sof <= '1';	
						s_row_cnt <= to_unsigned(0, s_row_cnt'length);
						s_col_cnt <= to_unsigned(0, s_col_cnt'length);
						if s_enable_reg = '1' and s_xclk_locked_reg = '1' then
							if s_x_fval_r1 = '0' and s_x_fval = '1' then
								s_state <= TRANSMIT_DATA;
								s_new_frame_tog <= not s_new_frame_tog;
							end if;
						end if;

					when TRANSMIT_DATA =>
						if s_xclk_locked_reg = '1' then
							-- end of frame markers
							if s_x_fval = '0' then
								s_eof <= '1';	
							end if;

							-- start of frame markers
							if s_pixel_data_valid <= '1' then
								s_sof <= '0';
							end if;

							-- if a valid pixel is clocked in
							if ( (s_x_lval_r1 = '1') and (s_x_fval_r1 = '1') ) then
								-- only clock data if within desired ROI
								if (s_row_cnt >= s_roi_row_start_reg_m) and
								   (s_row_cnt < s_roi_row_end_reg_m) and
								   (s_col_cnt >= s_roi_col_start_reg_m) and
								   (s_col_cnt < s_roi_col_end_reg_m) then
									s_pixel_data_valid <= '1';
								end if;
								-- bump counters
								if s_x_lval = '0' then
									s_row_cnt <= s_row_cnt + 1;
									s_col_cnt <= to_unsigned(0, s_col_cnt'length);
								else
									s_col_cnt <= s_col_cnt + 1;
								end if;
							end if;

							-- state transition on falling edge of fval
							if s_x_fval_r1 = '0' then
								s_state <= IDLE;
							end if;
						else
							-- flag condition and go back to IDLE?

							-- if odd case, flush additional pixel write 
						end if;

					when others => NULL;

				end case;
			end if;
		end if; 
	end process bcon_state_machine;

	s_eop <= s_eof;

	-- push received pixels onto 32 bit FIFO based on base mode selected
	-- this is ugly, but I can think of no other way...
	fifo_write : process(s_x_rx_clk)
	begin
		if rising_edge(s_x_rx_clk) then
			s_fifo_data_we <= '0';
			s_fifo_data_we_r1 <= '0';
			
			s_bcon_mode_reg_m <= s_bcon_mode_reg;
			
			if s_srst_reg = '1' then
				s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
			elsif s_pixel_data_valid = '1' or s_eof = '1' then
				s_fifo_data_in(32) <= s_sof;
				s_fifo_data_in(33) <= s_eof;
				s_fifo_data_in(34) <= s_pixel_data_valid;
				s_fifo_data_in(35) <= s_eop;
				case s_bcon_mode_reg_m is
					when BCON_8x1 =>
						-- pack up to 4 pixels, 1 at a time
						if s_pixel_data_valid = '1' then
							s_fifo_data_in(31 downto 0) <= s_databits_r2(7 downto 0) & s_fifo_data_in(31 downto 8);
						end if;

						if s_pix_cnt = 3 then
							s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
							s_fifo_data_we <= '1';
						else
							s_pix_cnt <= s_pix_cnt + 1;
						end if;
					when BCON_8x2 =>
						s_fifo_data_we <= s_fifo_data_we_r1;
					
						-- pack up to 4 pixels, 2 at a time
						if s_pixel_data_valid = '1' then
							s_fifo_data_in(31 downto 0) <= s_databits_r2(15 downto 0) & s_fifo_data_in(31 downto 16);
						end if;
						if s_pix_cnt = 1 then
							s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
						else
							s_fifo_data_we_r1 <= '1';
							s_pix_cnt <= s_pix_cnt + 1;
						end if;
					when BCON_12x1 =>
						s_fifo_data_we <= s_fifo_data_we_r1;
					
						-- pack up to 2 pixels, 1 at a time
						if s_pixel_data_valid = '1' then
							s_fifo_data_in(31 downto 0) <=  "0000" & s_databits_r2(11 downto 0) & s_fifo_data_in(31 downto 16);
						end if;
						if s_pix_cnt = 1 then
							s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
						else
							s_fifo_data_we_r1 <= '1';
							s_pix_cnt <= s_pix_cnt + 1;
						end if;
					when BCON_12x1_PACKED =>
						if s_pixel_data_valid = '1' then
							case s_pix_cnt is
								when to_unsigned(0, s_pix_cnt'length) =>
									s_fifo_data_in(11 downto 0) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(1, s_pix_cnt'length) =>
									s_fifo_data_in(23 downto 12) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(2, s_pix_cnt'length) =>
									s_fifo_data_in(31 downto 24) <= s_databits_r2(7 downto 0);
									s_fifo_data_save(3 downto 0) <= s_databits_r2(11 downto 8);
									s_fifo_data_we <= '1';
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(3, s_pix_cnt'length) =>
									s_fifo_data_in(3 downto 0) <= s_fifo_data_save(3 downto 0);
									s_fifo_data_in(15 downto 4) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(4, s_pix_cnt'length) =>
									s_fifo_data_in(27 downto 16) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(5, s_pix_cnt'length) =>
									s_fifo_data_in(31 downto 28) <= s_databits_r2(3 downto 0);
									s_fifo_data_save(7 downto 0) <= s_databits_r2(11 downto 8) & s_databits_r2(7 downto 4);
									s_fifo_data_we <= '1';
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(6, s_pix_cnt'length) =>
									s_fifo_data_in(7 downto 0) <= s_fifo_data_save(7 downto 0);
									s_fifo_data_in(19 downto 8) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(7, s_pix_cnt'length) =>
									s_fifo_data_in(31 downto 20) <= s_databits_r2(11 downto 0);
									s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
									s_fifo_data_we <= '1';
								when others => 
									s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
							end case;
						end if;
					when BCON_12x2 =>
						-- pack up to 2 pixels, 2 at a time
						s_fifo_data_in(15 downto 0) <= "0000" & s_databits_r2(11 downto 0);
						s_fifo_data_in(31 downto 16)  <= "0000" & s_databits_r2(23 downto 12);
						s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
						s_fifo_data_we <= '1';
					when BCON_12x2_PACKED =>
						if s_pixel_data_valid = '1' then
							case s_pix_cnt is
								when to_unsigned(0, s_pix_cnt'length) =>
									s_fifo_data_in(11 downto 0) <= s_databits_r2(11 downto 0);
									s_fifo_data_in(23 downto 12) <= s_databits_r2(23 downto 12);
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(1, s_pix_cnt'length) =>
									s_fifo_data_in(31 downto 24) <= s_databits_r2(7 downto 0);
									s_fifo_data_save(15 downto 0) <= s_databits_r2(23 downto 8);
									s_fifo_data_we <= '1';
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(2, s_pix_cnt'length) =>
									s_fifo_data_in(15 downto 0) <= s_fifo_data_save(15 downto 0);
									s_fifo_data_in(27 downto 16) <= s_databits_r2(11 downto 0);
									s_fifo_data_in(31 downto 28) <= s_databits_r2(15 downto 12);
									s_fifo_data_save(7 downto 0) <= s_databits_r2(23 downto 16);
									s_fifo_data_we <= '1';
									s_pix_cnt <= s_pix_cnt + 1;
								when to_unsigned(3, s_pix_cnt'length) =>
									s_fifo_data_in(7 downto 0) <= s_fifo_data_save(7 downto 0);
									s_fifo_data_in(19 downto 8) <= s_databits_r2(11 downto 0);
									s_fifo_data_in(31 downto 20) <= s_databits_r2(23 downto 12);
									s_fifo_data_we <= '1';
									s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
								when others => 
									s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
							end case;
						end if;
					when BCON_16x1YCrCb422 =>
						s_fifo_data_we <= s_fifo_data_we_r1;
					
						-- pack up to 2 pixels, 1 at a time
						if s_pixel_data_valid = '1' then
							s_fifo_data_in(31 downto 0) <= s_databits_r2(15 downto 0) & s_fifo_data_in(31 downto 16);
						end if;
						if s_pix_cnt = 1 then
							s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
						else
							s_fifo_data_we_r1 <= '1';
							s_pix_cnt <= s_pix_cnt + 1;
						end if;
					when BCON_24RGB =>
						-- pack up to 3 pixels, 3 at a time
						s_fifo_data_in(31 downto 0) <= x"00" & s_databits_r2(23 downto 0);
						s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
						s_fifo_data_we <= '1';
					when others => NULL;
				end case;
				-- TODO - check if this is OK or if I have to push this back through
				if s_eof = '1' then
					s_fifo_data_we <= '1';
					s_pix_cnt <= to_unsigned(0, s_pix_cnt'length);
				end if;
			end if;
		end if;
	end process fifo_write;

	s_fifo_data_rd <= i_data_out_ready and not s_fifo_data_empty when s_output_state /= SEND_HEADER else '0';
	o_data_out_endofpacket <= s_fifo_data_out(35) and not s_fifo_data_empty when s_output_state = SEND_FRAME else '0';
	o_data_out_valid <= not s_fifo_data_empty when s_output_state = SEND_FRAME else s_hdr_valid;

	-- reverse endian the output for streaming to RAM
	o_data_out_data(31 downto 24) <= s_fifo_data_out(7 downto 0) when s_output_state = SEND_FRAME AND i_data_out_ready = '1' else
									s_fifo_data_out_r1(7 downto 0) when s_output_state = SEND_FRAME AND i_data_out_ready = '0' else s_hdr_data(7 downto 0);
	o_data_out_data(23 downto 16) <= s_fifo_data_out(15 downto 8) when s_output_state = SEND_FRAME AND i_data_out_ready = '1' else
									s_fifo_data_out_r1(15 downto 8) when s_output_state = SEND_FRAME AND i_data_out_ready = '0' else s_hdr_data(15 downto 8);
	o_data_out_data(15 downto 8) <= s_fifo_data_out(23 downto 16) when s_output_state = SEND_FRAME AND i_data_out_ready = '1' else
									s_fifo_data_out_r1(23 downto 16) when s_output_state = SEND_FRAME AND i_data_out_ready = '0' else s_hdr_data(23 downto 16);
	o_data_out_data(7 downto 0) <= s_fifo_data_out(31 downto 24) when s_output_state = SEND_FRAME AND i_data_out_ready = '1' else
									s_fifo_data_out_r1(31 downto 24) when s_output_state = SEND_FRAME AND i_data_out_ready = '0' else s_hdr_data(31 downto 24);

	-- send out a data header at the beginning of a frame
	-- then send out data in FIFO
	send_header_data : process(i_data_clock)
	begin
		if rising_edge(i_data_clock) then

			s_num_cols_reg_m <= s_num_cols_reg;
			s_num_rows_reg_m <= s_num_rows_reg;
			s_roi_row_start_reg_m1 <= s_roi_row_start_reg;
			s_roi_col_start_reg_m1 <= s_roi_col_start_reg;
			s_bcon_mode_reg_m1 <= s_bcon_mode_reg;

			if i_data_out_ready = '1' then
				s_fifo_data_out_r1 <= s_fifo_data_out;
			end if;
			
			if s_srst_reg = '1' then
				s_frame_index <= (others=>'0');
				s_output_state <= OUTPUT_IDLE;
				s_new_frame_tog_r1 <= '0';
				s_new_frame_tog_r2 <= '0';
				s_new_frame_tog_m <= '0';
			else
				case s_output_state is 
					when OUTPUT_IDLE =>
						s_hdr_count <= 0;
						s_hdr_valid <= '0';
						o_data_out_startofpacket <= '0';
						s_new_frame_tog_m <= s_new_frame_tog;
						s_new_frame_tog_r1 <= s_new_frame_tog_m;
						s_new_frame_tog_r2 <= s_new_frame_tog_r1;
						if s_new_frame_tog_r2 /= s_new_frame_tog_r1 then
							s_output_state <= SEND_HEADER;
						end if;

					when SEND_HEADER =>
						-- packet header
						s_hdr_valid <= '1';
						if i_data_out_ready = '1' and s_hdr_valid = '1' then
							s_hdr_count <= s_hdr_count + 1;
							case s_hdr_count is
								when 0 =>
									s_hdr_data <= "0000" & std_logic_vector(s_roi_row_start_reg_m1) & "0000" & std_logic_vector(s_roi_col_start_reg_m1);
									o_data_out_startofpacket <= '0';
								when 1 =>
									s_hdr_data <= std_logic_vector(s_frame_index);
								when 2 =>
									s_hdr_data <= i_timestamp;
								when 3 =>
									s_hdr_data <= i_timestamp_slow;
								when 4  =>
									s_hdr_data(31 downto 4) <= (others=>'0');
									s_hdr_data(3 downto 0) <= std_logic_vector(s_bcon_mode_reg_m1);
								when 5  =>
									s_hdr_data <= (others => '0');
								when 7 => 
									if i_data_out_ready = '1' then
										s_output_state <= SEND_FRAME;
									end if;
								when others => NULL;	
							end case;
						else
							case s_hdr_count is
								when 0 =>
									s_hdr_data <= "0000" & std_logic_vector(s_num_rows_reg_m) & "0000" & std_logic_vector(s_num_cols_reg_m);
									o_data_out_startofpacket <= '1';
								when 1 =>
									s_hdr_data <= "0000" & std_logic_vector(s_roi_row_start_reg_m1) & "0000" & std_logic_vector(s_roi_col_start_reg_m1);
									o_data_out_startofpacket <= '0';
								when 2 =>
									s_hdr_data <= std_logic_vector(s_frame_index);
								when 3 =>
									s_hdr_data <= i_timestamp;
								when 4 =>
									s_hdr_data <= i_timestamp_slow;
								when 5  =>
									s_hdr_data(31 downto 4) <= (others=>'0');
									s_hdr_data(3 downto 0) <= std_logic_vector(s_bcon_mode_reg_m1);
								when 6  =>
									s_hdr_data <= (others => '0');
								when 8 => 
									if i_data_out_ready = '1' then
										s_output_state <= SEND_FRAME;
									end if;
								when others => NULL;	
							end case;
						end if;
					when SEND_FRAME =>
						s_hdr_valid <= '0';
						if s_fifo_data_out(35) = '1' and s_fifo_data_empty = '0' and i_data_out_ready = '1' then
							s_output_state <= OUTPUT_IDLE;
							s_frame_index <= s_frame_index + 1;
						end if;
					when OTHERS => null;
				end case;
			end if;
		end if;
	end process send_header_data;

	output_fifo : dcfifo
	GENERIC MAP (
		intended_device_family => "Cyclone V",
		lpm_numwords => 256,
		lpm_showahead => "ON",
		lpm_type => "dcfifo",
		lpm_width => 36,
		lpm_widthu => 8,
		overflow_checking => "ON",
		rdsync_delaypipe => 4,
		underflow_checking => "ON",
		use_eab => "ON",
		wrsync_delaypipe => 4
	)
	PORT MAP (
		aclr	=> s_srst_reg,
		data	=> s_fifo_data_in,
		rdclk   => i_data_clock,
		rdreq   => s_fifo_data_rd,
		wrclk   => s_x_rx_clk,
		wrreq   => s_fifo_data_we,
		wrfull  => s_fifo_data_full,
		q       => s_fifo_data_out,
		rdempty => s_fifo_data_empty
	);

	x_5x7_inst : altlvdsrx_5x7
	PORT MAP
	(
		rx_channel_data_align	 => s_x_channel_data_align,
		rx_enable		 => s_x_enable,
		rx_in(3 downto 0)	 => i_bcon_x,
		rx_in(4)		 => i_bcon_xclk,
		rx_inclock		 => s_x_inclock,
		rx_out(27 downto 0)	 => s_x_out_preinv,
		rx_out(34 downto 28)	 => s_x_clkout_preinv
	);

	o_pixel_clock <= s_x_rx_clk;

	inv_inputlanes : for i in 0 to 6 generate
	begin
		s_x_clkout(i) <= s_x_clkout_preinv(i) xor g_lane_invert(0);
		s_x_out(i)    <= s_x_out_preinv(i)    xor g_lane_invert(1);
		s_x_out(7+i)  <= s_x_out_preinv(7+i)  xor g_lane_invert(2);
		s_x_out(14+i) <= s_x_out_preinv(14+i) xor g_lane_invert(3);
		s_x_out(21+i) <= s_x_out_preinv(21+i) xor g_lane_invert(4);
	end generate inv_inputlanes;

	pllx_5x7_inst : pll_1x7_reconfig
	port map
	(
		refclk			=> i_bcon_xclk,
		rst			=> s_pll_rst_reg,
		outclk_0		=> s_x_inclock_unbuf,
		outclk_1		=> s_x_enable_unbuf,
		outclk_2		=> s_x_rx_clk,
		locked			=> s_x_locked,
		reconfig_to_pll		=> reconfig_to_pll,
		reconfig_from_pll	=> reconfig_from_pll
	);

	LVDS_clock_buffer_inst0 : cyclonev_pll_lvds_output
	generic map (
		pll_loaden_enable_disable  => "true",
		pll_lvdsclk_enable_disable => "true"
	)
	port map (
		ccout(0)           => s_x_inclock_unbuf,
		ccout(1)           => s_x_enable_unbuf,
		loaden             => s_x_enable,
		lvdsclk            => s_x_inclock
	);

	-- use RX clock to bit align received data patterns
	clk_x_align : process(s_x_rx_clk)
	begin
		if rising_edge(s_x_rx_clk) then
			s_x_channel_data_align <= "00000";
			if s_x_locked = '1' then
				if s_align_clk = to_unsigned(0, s_align_clk'length) then
					if s_x_clkout /= "1100011" then
						s_x_channel_data_align <= "11111";
						s_xclk_locked_reg <= '0';
						s_align_clk <= s_align_clk + 1;
					else
						s_xclk_locked_reg <= '1';
					end if;
				else
					if s_align_clk = to_unsigned(4, s_align_clk'length) then
						s_align_clk <= (others=>'0');
					else
						s_align_clk <= s_align_clk + 1;
					end if;
				end if;
			else
				s_align_clk <= (others=>'0');
			end if;
		end if;
	end process;

	-- use Jeff's spiffy stuff
	cc_gen: trigger_generator PORT MAP (
		i_clk => i_register_clock,
		i_reset => i_rst,
		i_clk_div_reg => s_trig_clk_div_reg,
		i_clk_period => s_clk_period_reg,
		i_cc_compare_strt => s_cc_compare_strt_reg,
		i_cc_compare_end => s_cc_compare_end_reg,
		i_cc_en => s_cc_en_reg,
		i_cc_inv => s_cc_inv_reg,
		i_cc_sel => s_cc_sel_reg,
		o_cc(0) => o_bcon_cc,
		o_cc(3 downto 1) => open,
		o_to_fpga => o_fpga_trig
	);

end architecture; -- of bcon_input

