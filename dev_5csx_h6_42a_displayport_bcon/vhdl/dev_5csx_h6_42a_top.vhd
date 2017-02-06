-------------------------------------------------------------------------------
-- Title      : dev_5csx_h6_42a_top
-- Project    : 
-------------------------------------------------------------------------------
--
--     o  0                          
--     | /       Copyright (c) 2015
--    (CL)---o   Critical Link, LLC  
--      \                            
--       O                           
--
-- File       : mitysom-5csx_dev_board_top.vhd
-- Company    : Critical Link, LLC
-- Created    : 2013-07-29
-- Last update: 2016-05-17
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top level entity for the mitysom-5CSX Development Board using
-- the Critical Link DisplayPort adapter
-------------------------------------------------------------------------------
-- Copyright (c) 2017 Critical Link, LLC
-------------------------------------------------------------------------------
-- Revisions  :
-- Date			Version	Author	Description
-- 2017-01-19	1.0		Dan V		Initial
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library altera;
use altera.altera_primitives_components.all;
-------------------------------------------------------------------------------

entity dev_5csx_h6_42a_top is
	port(
		-- HPS DDR
		HPS_DDR_A         : out   std_logic_vector(14 downto 0);
		HPS_DDR_BAS       : out   std_logic_vector(2 downto 0);
		HPS_DDR_CK_P      : out   std_logic;
		HPS_DDR_CK_N      : out   std_logic;
		HPS_DDR_CKE       : out   std_logic;
		HPS_DDR_CS0_N     : out   std_logic;
		HPS_DDR_RAS_N     : out   std_logic;
		HPS_DDR_CAS_N     : out   std_logic;
		HPS_DDR_WE_N      : out   std_logic;
		HPS_DDR_RESET_N   : out   std_logic;
		HPS_DDR_D         : inout std_logic_vector(39 downto 0) := (others => 'X');
		HPS_DDR_DQS_P     : inout std_logic_vector(4 downto 0)  := (others => 'X');
		HPS_DDR_DQS_N     : inout std_logic_vector(4 downto 0)  := (others => 'X');
		HPS_DDR_DQM       : out   std_logic_vector(4 downto 0);
		HPS_RZQ0          : in    std_logic                     := 'X';
		HPS_ODT           : out   std_logic;
		-- RGMII1
		RGMII1_TX_CLK     : out   std_logic;
		RGMII1_TXD0       : out   std_logic;
		RGMII1_TXD1       : out   std_logic;
		RGMII1_TXD2       : out   std_logic;
		RGMII1_TXD3       : out   std_logic;
		RGMII1_RXD0       : in    std_logic                     := 'X';
		RGMII1_MDIO       : inout std_logic                     := 'X';
		RGMII1_MDC        : out   std_logic;
		RGMII1_RX_CTL     : in    std_logic                     := 'X';
		RGMII1_TX_CTL     : out   std_logic;
		RGMII1_RX_CLK     : in    std_logic                     := 'X';
		RGMII1_RXD1       : in    std_logic                     := 'X';
		RGMII1_RXD2       : in    std_logic                     := 'X';
		RGMII1_RXD3       : in    std_logic                     := 'X';
		RGMII1_RESETn     : inout std_logic;
		-- QSPI
		QSPI_DQ0          : inout std_logic                     := 'X';
		QSPI_DQ1          : inout std_logic                     := 'X';
		QSPI_DQ2          : inout std_logic                     := 'X';
		QSPI_DQ3          : inout std_logic                     := 'X';
		QSPI_SS0          : out   std_logic;
		QSPI_SS1          : out   std_logic;
		QSPI_CLK          : out   std_logic;
		-- SDMMC
		SDMMC_CMD         : inout std_logic                     := 'X';
		SDMMC_D0          : inout std_logic                     := 'X';
		SDMMC_D1          : inout std_logic                     := 'X';
		SDMMC_CLK         : out   std_logic;
		SDMMC_D2          : inout std_logic                     := 'X';
		SDMMC_D3          : inout std_logic                     := 'X';
		-- USB1
		USB1_ULPI_D0      : inout std_logic                     := 'X';
		USB1_ULPI_D1      : inout std_logic                     := 'X';
		USB1_ULPI_D2      : inout std_logic                     := 'X';
		USB1_ULPI_D3      : inout std_logic                     := 'X';
		USB1_ULPI_D4      : inout std_logic                     := 'X';
		USB1_ULPI_D5      : inout std_logic                     := 'X';
		USB1_ULPI_D6      : inout std_logic                     := 'X';
		USB1_ULPI_D7      : inout std_logic                     := 'X';
		USB1_ULPI_CLK     : in    std_logic                     := 'X';
		USB1_ULPI_STP     : out   std_logic;
		USB1_ULPI_DIR     : in    std_logic                     := 'X';
		USB1_ULPI_NXT     : in    std_logic                     := 'X';
		USB1_ULPI_CS      : inout std_logic;
		USB1_ULPI_RESET_N : inout std_logic;
		-- UART0
		B7A_UART0_RX      : in    std_logic                     := 'X';
		B7A_UART0_TX      : out   std_logic;
		-- I2C0
		B7A_I2C0_SDA      : inout std_logic                     := 'X';
		B7A_I2C0_SCL      : inout std_logic                     := 'X';
		-- CAN0
		B7A_CAN0_RX       : in    std_logic                     := 'X';
		B7A_CAN0_TX       : out   std_logic;
		-- CAN1
		B7A_CAN1_RX       : in    std_logic                     := 'X';
		B7A_CAN1_TX       : out   std_logic;
		-- I2C1
		I2C1_SCL          : inout std_logic;
		I2C1_SDA          : inout std_logic;
		-- LEDs
		LED1              : inout std_logic;
		LED2              : inout std_logic;
		LED3              : inout std_logic;
		-- Switches
		SW1               : inout std_logic;
		SW2               : inout std_logic;
		SW3               : inout std_logic;

		-- 100Mhz clock input
		CLK2DDR           : in    std_logic                     := 'X';

		-- Displayport 
		B4A_RX_B55_N  : out std_logic;
		B3B_TX_B37_N  : out std_logic;
		B5A_PERSTL1_N : in  std_logic;
		B4A_RX_B66_P  : in  std_logic;
		GXB_TX_0      : out std_logic;
		GXB_TX_1      : out std_logic;
		GXB_TX_2      : out std_logic;
		GXB_TX_3      : out std_logic;
		GXB_REFCLK0   : in  std_logic;
		PCIE_SMDAT    : inout std_logic;
		PCIE_SMCLK    : inout std_logic;

		-- HSMC1 BCON adapter
		HSMC1_CLKIN1      : in std_logic;
		HSMC1_CLKIN2      : in std_logic;

		HSMC1_SMSDA       : inout std_logic;
		HSMC1_SMSCL       : inout std_logic;

		HSMC1_RX4         : in std_logic;
		HSMC1_RX5         : in std_logic;
		HSMC1_RX6         : in std_logic;
		HSMC1_RX7         : in std_logic;
		HSMC1_TX7         : out std_logic;

		HSMC1_RX11        : in std_logic;
		HSMC1_RX12        : in std_logic;
		HSMC1_RX13        : in std_logic;
		HSMC1_RX14        : in std_logic; -- CLK1
		HSMC1_RX15        : in std_logic;  --CLK0
		HSMC1_RX16        : in std_logic;
		HSMC1_TX16        : out std_logic
	);

end entity dev_5csx_h6_42a_top;

-------------------------------------------------------------------------------

architecture rtl of dev_5csx_h6_42a_top is
	component dev_5csx_h6_42a is
		port(
			hps_ddr_mem_a                     : out   std_logic_vector(14 downto 0); -- mem_a
			hps_ddr_mem_ba                    : out   std_logic_vector(2 downto 0); -- mem_ba
			hps_ddr_mem_ck                    : out   std_logic; -- mem_ck
			hps_ddr_mem_ck_n                  : out   std_logic; -- mem_ck_n
			hps_ddr_mem_cke                   : out   std_logic; -- mem_cke
			hps_ddr_mem_cs_n                  : out   std_logic; -- mem_cs_n
			hps_ddr_mem_ras_n                 : out   std_logic; -- mem_ras_n
			hps_ddr_mem_cas_n                 : out   std_logic; -- mem_cas_n
			hps_ddr_mem_we_n                  : out   std_logic; -- mem_we_n
			hps_ddr_mem_reset_n               : out   std_logic; -- mem_reset_n
			hps_ddr_mem_dq                    : inout std_logic_vector(39 downto 0) := (others => 'X'); -- mem_dq
			hps_ddr_mem_dqs                   : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs
			hps_ddr_mem_dqs_n                 : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_ddr_mem_odt                   : out   std_logic; -- mem_odt
			hps_ddr_mem_dm                    : out   std_logic_vector(4 downto 0); -- mem_dm
			hps_ddr_oct_rzqin                 : in    std_logic                     := 'X'; -- oct_rzqin
			hps_io_hps_io_emac1_inst_TX_CLK   : out   std_logic; -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0     : out   std_logic; -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1     : out   std_logic; -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2     : out   std_logic; -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3     : out   std_logic; -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0     : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO     : inout std_logic                     := 'X'; -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC      : out   std_logic; -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL   : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL   : out   std_logic; -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK   : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1     : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2     : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3     : in    std_logic                     := 'X'; -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_SS1       : out   std_logic; -- hps_io_qspi_inst_SS1
			hps_io_hps_io_qspi_inst_IO0       : inout std_logic                     := 'X'; -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1       : inout std_logic                     := 'X'; -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2       : inout std_logic                     := 'X'; -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3       : inout std_logic                     := 'X'; -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0       : out   std_logic; -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK       : out   std_logic; -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD       : inout std_logic                     := 'X'; -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0        : inout std_logic                     := 'X'; -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1        : inout std_logic                     := 'X'; -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK       : out   std_logic; -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2        : inout std_logic                     := 'X'; -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3        : inout std_logic                     := 'X'; -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7        : inout std_logic                     := 'X'; -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK       : in    std_logic                     := 'X'; -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP       : out   std_logic; -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR       : in    std_logic                     := 'X'; -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT       : in    std_logic                     := 'X'; -- hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX       : in    std_logic                     := 'X'; -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX       : out   std_logic; -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA       : inout std_logic                     := 'X'; -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL       : inout std_logic                     := 'X'; -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA       : inout std_logic                     := 'X'; -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL       : inout std_logic                     := 'X'; -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_can0_inst_RX        : in    std_logic                     := 'X'; -- hps_io_can0_inst_RX
			hps_io_hps_io_can0_inst_TX        : out   std_logic; -- hps_io_can0_inst_TX
			hps_io_hps_io_can1_inst_RX        : in    std_logic                     := 'X'; -- hps_io_can1_inst_RX
			hps_io_hps_io_can1_inst_TX        : out   std_logic; -- hps_io_can1_inst_TX
			hps_io_hps_io_gpio_inst_GPIO00    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO28    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO28
			hps_io_hps_io_gpio_inst_GPIO37    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO37
			hps_io_hps_io_gpio_inst_GPIO40    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO48    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO49    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50    : inout std_logic                     := 'X'; -- hps_io_gpio_inst_GPIO50
			clk_100mhz_clk                          : in    std_logic                     := 'X';             -- clk
			dp_0_xcvr_refclk_clk                    : in    std_logic                     := 'X';             -- clk
			dp_0_tx_xcvr_interface_tx_serial_data   : out   std_logic_vector(3 downto 0);                     -- tx_serial_data
			dp_0_tx_xcvr_interface_tx_parallel_data : in    std_logic_vector(79 downto 0) := (others => 'X'); -- tx_parallel_data
			dp_0_tx_xcvr_interface_tx_pll_powerdown : in    std_logic                     := 'X';             -- tx_pll_powerdown
			dp_0_tx_xcvr_interface_tx_analogreset   : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- tx_analogreset
			dp_0_tx_xcvr_interface_tx_digitalreset  : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- tx_digitalreset
			dp_0_tx_xcvr_interface_tx_cal_busy      : out   std_logic_vector(3 downto 0);                     -- tx_cal_busy
			dp_0_tx_xcvr_interface_tx_std_clkout    : out   std_logic_vector(3 downto 0);                     -- tx_std_clkout
			dp_0_tx_xcvr_interface_tx_pll_locked    : out   std_logic;                                        -- tx_pll_locked
			dp_0_tx_reconfig_tx_link_rate           : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- tx_link_rate
			dp_0_tx_reconfig_tx_link_rate_8bits     : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- tx_link_rate_8bits
			dp_0_tx_reconfig_tx_reconfig_req        : in    std_logic                     := 'X';             -- tx_reconfig_req
			dp_0_tx_reconfig_tx_reconfig_ack        : out   std_logic;                                        -- tx_reconfig_ack
			dp_0_tx_reconfig_tx_reconfig_busy       : out   std_logic;                                        -- tx_reconfig_busy
			dp_0_oc_i2c_scl_pad_io                  : inout std_logic                     := 'X';             -- scl_pad_io
			dp_0_oc_i2c_sda_pad_io                  : inout std_logic                     := 'X';             -- sda_pad_io
			dp_0_dp_tx_xcvr_interface_parallel_data : out   std_logic_vector(79 downto 0);                    -- parallel_data
			dp_0_dp_tx_xcvr_interface_pll_powerdown : out   std_logic;                                        -- pll_powerdown
			dp_0_dp_tx_xcvr_interface_analogreset   : out   std_logic_vector(3 downto 0);                     -- analogreset
			dp_0_dp_tx_xcvr_interface_digitalreset  : out   std_logic_vector(3 downto 0);                     -- digitalreset
			dp_0_dp_tx_xcvr_interface_cal_busy      : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- cal_busy
			dp_0_dp_tx_xcvr_interface_std_clkout    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- std_clkout
			dp_0_dp_tx_xcvr_interface_pll_locked    : in    std_logic                     := 'X';             -- pll_locked
			dp_0_dp_tx_video_in_data                : in    std_logic_vector(23 downto 0) := (others => 'X'); -- data
			dp_0_dp_tx_video_in_v_sync              : in    std_logic                     := 'X';             -- v_sync
			dp_0_dp_tx_video_in_h_sync              : in    std_logic                     := 'X';             -- h_sync
			dp_0_dp_tx_video_in_de                  : in    std_logic                     := 'X';             -- de
			dp_0_dp_tx_reconfig_link_rate           : out   std_logic_vector(1 downto 0);                     -- link_rate
			dp_0_dp_tx_reconfig_link_rate_8bits     : out   std_logic_vector(7 downto 0);                     -- link_rate_8bits
			dp_0_dp_tx_reconfig_reconfig_req        : out   std_logic;                                        -- reconfig_req
			dp_0_dp_tx_reconfig_reconfig_ack        : in    std_logic                     := 'X';             -- reconfig_ack
			dp_0_dp_tx_reconfig_reconfig_busy       : in    std_logic                     := 'X';             -- reconfig_busy
			dp_0_dp_tx_aux_aux_in                   : in    std_logic                     := 'X';             -- aux_in
			dp_0_dp_tx_aux_aux_out                  : out   std_logic;                                        -- aux_out
			dp_0_dp_tx_aux_aux_oe                   : out   std_logic;                                        -- aux_oe
       			dp_0_dp_tx_aux_hpd                      : in    std_logic                     := 'X';             -- hpd
			dp_0_cvo_clocked_video_vid_data         : out   std_logic_vector(23 downto 0);                    -- vid_data
			dp_0_cvo_clocked_video_underflow        : out   std_logic;                                        -- underflow
			dp_0_cvo_clocked_video_vid_datavalid    : out   std_logic;                                        -- vid_datavalid
			dp_0_cvo_clocked_video_vid_v_sync       : out   std_logic;                                        -- vid_v_sync
			dp_0_cvo_clocked_video_vid_h_sync       : out   std_logic;                                        -- vid_h_sync
			dp_0_cvo_clocked_video_vid_f            : out   std_logic;                                        -- vid_f
			dp_0_cvo_clocked_video_vid_h            : out   std_logic;                                        -- vid_h
			dp_0_cvo_clocked_video_vid_v            : out   std_logic;                                        -- vid_v
			alt_vip_cl_cvi_0_clocked_video_vid_clk            : in    std_logic                     := 'X';             -- vid_clk
			alt_vip_cl_cvi_0_clocked_video_vid_data           : in    std_logic_vector(23 downto 0) := (others => 'X'); -- vid_data
			alt_vip_cl_cvi_0_clocked_video_vid_de             : in    std_logic                     := 'X';             -- vid_de
			alt_vip_cl_cvi_0_clocked_video_vid_datavalid      : in    std_logic                     := 'X';             -- vid_datavalid
			alt_vip_cl_cvi_0_clocked_video_vid_locked         : in    std_logic                     := 'X';             -- vid_locked
			alt_vip_cl_cvi_0_clocked_video_vid_f              : in    std_logic                     := 'X';             -- vid_f
			alt_vip_cl_cvi_0_clocked_video_vid_v_sync         : in    std_logic                     := 'X';             -- vid_v_sync
			alt_vip_cl_cvi_0_clocked_video_vid_h_sync         : in    std_logic                     := 'X';             -- vid_h_sync
			alt_vip_cl_cvi_0_clocked_video_vid_std            : in    std_logic                     := 'X';             -- vid_std
			alt_vip_cl_cvi_0_clocked_video_vid_color_encoding : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- vid_color_encoding
			alt_vip_cl_cvi_0_clocked_video_vid_bit_width      : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- vid_bit_width
			alt_vip_cl_cvi_0_clocked_video_sof                : out   std_logic;                                        -- sof
			alt_vip_cl_cvi_0_clocked_video_sof_locked         : out   std_logic;                                        -- sof_locked
			alt_vip_cl_cvi_0_clocked_video_refclk_div         : out   std_logic;                                        -- refclk_div
			alt_vip_cl_cvi_0_clocked_video_overflow           : out   std_logic;                                        -- overflow
			alt_vip_cl_cvi_1_clocked_video_vid_clk            : in    std_logic                     := 'X';             -- vid_clk
			alt_vip_cl_cvi_1_clocked_video_vid_data           : in    std_logic_vector(23 downto 0) := (others => 'X'); -- vid_data
			alt_vip_cl_cvi_1_clocked_video_vid_de             : in    std_logic                     := 'X';             -- vid_de
			alt_vip_cl_cvi_1_clocked_video_vid_datavalid      : in    std_logic                     := 'X';             -- vid_datavalid
			alt_vip_cl_cvi_1_clocked_video_vid_locked         : in    std_logic                     := 'X';             -- vid_locked
			alt_vip_cl_cvi_1_clocked_video_vid_f              : in    std_logic                     := 'X';             -- vid_f
			alt_vip_cl_cvi_1_clocked_video_vid_v_sync         : in    std_logic                     := 'X';             -- vid_v_sync
			alt_vip_cl_cvi_1_clocked_video_vid_h_sync         : in    std_logic                     := 'X';             -- vid_h_sync
			alt_vip_cl_cvi_1_clocked_video_vid_std            : in    std_logic                     := 'X';             -- vid_std
			alt_vip_cl_cvi_1_clocked_video_vid_color_encoding : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- vid_color_encoding
			alt_vip_cl_cvi_1_clocked_video_vid_bit_width      : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- vid_bit_width
			alt_vip_cl_cvi_1_clocked_video_sof                : out   std_logic;                                        -- sof
			alt_vip_cl_cvi_1_clocked_video_sof_locked         : out   std_logic;                                        -- sof_locked
			alt_vip_cl_cvi_1_clocked_video_refclk_div         : out   std_logic;                                        -- refclk_div
			alt_vip_cl_cvi_1_clocked_video_overflow           : out   std_logic;                                        -- overflow
			bcon_input_0_bcon_bm_interface_i_bcon_x           : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_xclk        : in    std_logic                     := 'X';             -- i_bcon_xclk
			bcon_input_0_bcon_bm_interface_o_bcon_cc          : out   std_logic;                                        -- o_bcon_cc
			bcon_input_0_bcon_bm_interface_o_fpga_trig        : out   std_logic;                                        -- o_fpga_trig
			bcon_input_0_data_out_data                        : out   std_logic_vector(31 downto 0);                    -- data
			bcon_input_0_data_out_valid                       : out   std_logic;                                        -- valid
			bcon_input_0_data_out_endofpacket                 : out   std_logic;                                        -- endofpacket
			bcon_input_0_data_out_startofpacket               : out   std_logic;                                        -- startofpacket
			bcon_input_0_data_out_ready                       : in    std_logic                     := 'X';             -- ready
			bcon_input_0_video_out_line_valid                 : out   std_logic;                                        -- line_valid
			bcon_input_0_video_out_frame_valid                : out   std_logic;                                        -- frame_valid
			bcon_input_0_video_out_data_valid                 : out   std_logic;                                        -- data_valid
			bcon_input_0_video_out_data                       : out   std_logic_vector(23 downto 0);                    -- data
			bcon_input_0_pixel_clock_clk                      : out   std_logic;                                        -- clk
			bcon_input_0_data_clock_clk                       : in    std_logic                     := 'X';             -- clk
			i2c2_out_data                                     : out   std_logic;                                        -- out_data
			i2c2_sda                                          : in    std_logic                     := 'X';             -- sda
			i2c2_clk_clk                                      : out   std_logic;                                        -- clk
			i2c2_scl_in_clk                                   : in    std_logic                     := 'X';              -- clk
			i2c3_out_data                                     : out   std_logic;                                        -- out_data
			i2c3_sda                                          : in    std_logic                     := 'X';             -- sda
			i2c3_scl_in_clk                                   : in    std_logic                     := 'X';             -- clk
			id2c3_clk_clk                                     : out   std_logic                                         -- clk

		);
	end component dev_5csx_h6_42a;
	
	signal tx_xcvr_interface_tx_parallel_data : std_logic_vector(79 downto 0) := (others => 'X'); -- tx_parallel_data
	signal tx_xcvr_interface_tx_pll_powerdown : std_logic                     := 'X';             -- tx_pll_powerdown
	signal tx_xcvr_interface_tx_analogreset   : std_logic_vector(3 downto 0)  := (others => 'X'); -- tx_analogreset
	signal tx_xcvr_interface_tx_digitalreset  : std_logic_vector(3 downto 0)  := (others => 'X'); -- tx_digitalreset
	signal tx_xcvr_interface_tx_cal_busy      : std_logic_vector(3 downto 0);                     -- tx_cal_busy
	signal tx_xcvr_interface_tx_std_clkout    : std_logic_vector(3 downto 0);                     -- tx_std_clkout
	signal tx_xcvr_interface_tx_pll_locked    : std_logic;                                        -- tx_pll_locked

	signal tx_reconfig_link_rate           : std_logic_vector(1 downto 0);                     -- link_rate
	signal tx_reconfig_link_rate_8bits     : std_logic_vector(7 downto 0);                     -- link_rate_8bits
	signal tx_reconfig_reconfig_req        : std_logic;                                        -- reconfig_req
	signal tx_reconfig_reconfig_ack        : std_logic                     := 'X';             -- reconfig_ack
	signal tx_reconfig_reconfig_busy       : std_logic                     := 'X';             -- reconfig_busy

	signal tx_video_in_data                : std_logic_vector(23 downto 0) := (others => 'X'); -- data
	signal tx_video_in_v_sync              : std_logic                     := 'X';             -- v_sync
	signal tx_video_in_h_sync              : std_logic                     := 'X';             -- h_sync
	signal tx_video_in_de                  : std_logic                     := 'X';             -- de

	signal dp_0_oc_i2c_scl_pad_io                  :  std_logic                     := 'X';             -- scl_pad_io
	signal dp_0_oc_i2c_sda_pad_io                  :  std_logic                     := 'X';             -- sda_pad_io

	signal s_vid_data, s_data : std_logic_vector(23 downto 0);
	signal s_vid_de, s_data_valid : std_logic;
	signal s_vid_datavalid : std_logic;
	signal s_vid_v_sync, s_frame_valid : std_logic;
	signal s_vid_h_sync, s_line_valid : std_logic;
	signal s_vid_clk : std_logic;
	signal HSMC1_SDA_OUT : std_logic := '1';
	signal HSMC1_SCL_OUT : std_logic := '1';
	signal PCIE_SMDAT_OUT : std_logic := '1';
	signal PCIE_SMCLK_OUT : std_logic := '1';

begin                                   -- architecture rtl

	----------------------------------------------------------------------------
	-- Component instantiations
	---------------------------------------------------------------------------

	u0 : component dev_5csx_h6_42a
		port map(
			hps_ddr_mem_a                     => HPS_DDR_A, -- hps_ddr.mem_a
			hps_ddr_mem_ba                    => HPS_DDR_BAS, --       .mem_ba
			hps_ddr_mem_ck                    => HPS_DDR_CK_P, --       .mem_ck
			hps_ddr_mem_ck_n                  => HPS_DDR_CK_N, --       .mem_ck_n
			hps_ddr_mem_cke                   => HPS_DDR_CKE, --       .mem_cke
			hps_ddr_mem_cs_n                  => HPS_DDR_CS0_N, --       .mem_cs_n
			hps_ddr_mem_ras_n                 => HPS_DDR_RAS_N, --       .mem_ras_n
			hps_ddr_mem_cas_n                 => HPS_DDR_CAS_N, --       .mem_cas_n
			hps_ddr_mem_we_n                  => HPS_DDR_WE_N, --       .mem_we_n
			hps_ddr_mem_reset_n               => HPS_DDR_RESET_N, --       .mem_reset_n
			hps_ddr_mem_dq                    => HPS_DDR_D, --       .mem_dq
			hps_ddr_mem_dqs                   => HPS_DDR_DQS_P, --       .mem_dqs
			hps_ddr_mem_dqs_n                 => HPS_DDR_DQS_N, --       .mem_dqs_n
			hps_ddr_mem_odt                   => HPS_ODT, --       .mem_odt
			hps_ddr_mem_dm                    => HPS_DDR_DQM, --       .mem_dm
			hps_ddr_oct_rzqin                 => HPS_RZQ0, --       .oct_rzqin
			hps_io_hps_io_emac1_inst_TX_CLK   => RGMII1_TX_CLK, -- hps_io.hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0     => RGMII1_TXD0, --       .hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1     => RGMII1_TXD1, --       .hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2     => RGMII1_TXD2, --       .hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3     => RGMII1_TXD3, --       .hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0     => RGMII1_RXD0, --       .hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_RXD1     => RGMII1_RXD1, --       .hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2     => RGMII1_RXD2, --       .hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3     => RGMII1_RXD3, --       .hps_io_emac1_inst_RXD3
			hps_io_hps_io_emac1_inst_MDIO     => RGMII1_MDIO, --       .hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC      => RGMII1_MDC, --       .hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL   => RGMII1_RX_CTL, --       .hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL   => RGMII1_TX_CTL, --       .hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK   => RGMII1_RX_CLK, --       .hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_qspi_inst_SS1       => QSPI_SS1, -- hps_io.hps_io_qspi_inst_SS1
			hps_io_hps_io_qspi_inst_IO0       => QSPI_DQ0, --       .hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1       => QSPI_DQ1, --       .hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2       => QSPI_DQ2, --       .hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3       => QSPI_DQ3, --       .hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0       => QSPI_SS0, --       .hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK       => QSPI_CLK, --       .hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD       => SDMMC_CMD, --       .hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0        => SDMMC_D0, --       .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1        => SDMMC_D1, --       .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_D2        => SDMMC_D2, --       .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3        => SDMMC_D3, --       .hps_io_sdio_inst_D3
			hps_io_hps_io_sdio_inst_CLK       => SDMMC_CLK, --       .hps_io_sdio_inst_CLK
			hps_io_hps_io_usb1_inst_D0        => USB1_ULPI_D0, --       .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1        => USB1_ULPI_D1, --       .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2        => USB1_ULPI_D2, --       .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3        => USB1_ULPI_D3, --       .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4        => USB1_ULPI_D4, --       .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5        => USB1_ULPI_D5, --       .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6        => USB1_ULPI_D6, --       .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7        => USB1_ULPI_D7, --       .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK       => USB1_ULPI_CLK, --       .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP       => USB1_ULPI_STP, --       .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR       => USB1_ULPI_DIR, --       .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT       => USB1_ULPI_NXT, --       .hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX       => B7A_UART0_RX, --       .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX       => B7A_UART0_TX, --       .hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA       => B7A_I2C0_SDA, --       .hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL       => B7A_I2C0_SCL, --       .hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA       => I2C1_SDA, -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL       => I2C1_SCL, -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_can0_inst_RX        => B7A_CAN0_RX, --       .hps_io_can0_inst_RX
			hps_io_hps_io_can0_inst_TX        => B7a_CAN0_TX, --       .hps_io_can0_inst_TX
			hps_io_hps_io_can1_inst_RX        => B7A_CAN1_RX, --       .hps_io_can1_inst_RX
			hps_io_hps_io_can1_inst_TX        => B7A_CAN1_TX, --       .hps_io_can1_inst_TX
			hps_io_hps_io_gpio_inst_GPIO00    => USB1_ULPI_CS, --       .hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09    => USB1_ULPI_RESET_N, --       .hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO48    => LED3, --       .hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO28    => RGMII1_RESETn, -- hps_io_gpio_inst_GPIO28
			hps_io_hps_io_gpio_inst_GPIO37    => SW1, -- hps_io_gpio_inst_GPIO37
			hps_io_hps_io_gpio_inst_GPIO40    => SW2, -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41    => SW3, -- hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO49    => LED2, -- hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50    => LED1, -- hps_io_gpio_inst_GPIO50
			
			clk_100mhz_clk  => CLK2DDR,
			dp_0_xcvr_refclk_clk  => GXB_REFCLK0,
				
       			dp_0_tx_xcvr_interface_tx_serial_data(0) => GXB_TX_0,
			dp_0_tx_xcvr_interface_tx_serial_data(1) => GXB_TX_1,
			-- 2 and 3 are switched on purpose
			dp_0_tx_xcvr_interface_tx_serial_data(2) => GXB_TX_3,
			dp_0_tx_xcvr_interface_tx_serial_data(3) => GXB_TX_2,
				
			dp_0_tx_xcvr_interface_tx_parallel_data => tx_xcvr_interface_tx_parallel_data,
			dp_0_tx_xcvr_interface_tx_pll_powerdown => tx_xcvr_interface_tx_pll_powerdown,
			dp_0_tx_xcvr_interface_tx_analogreset   => tx_xcvr_interface_tx_analogreset,
			dp_0_tx_xcvr_interface_tx_digitalreset  => tx_xcvr_interface_tx_digitalreset,
			dp_0_tx_xcvr_interface_tx_cal_busy      => tx_xcvr_interface_tx_cal_busy,
			dp_0_tx_xcvr_interface_tx_std_clkout    => tx_xcvr_interface_tx_std_clkout,
			dp_0_tx_xcvr_interface_tx_pll_locked    => tx_xcvr_interface_tx_pll_locked,      
				----------------------------------------------------------------------
			dp_0_dp_tx_xcvr_interface_parallel_data => tx_xcvr_interface_tx_parallel_data,
			dp_0_dp_tx_xcvr_interface_pll_powerdown => tx_xcvr_interface_tx_pll_powerdown,
			dp_0_dp_tx_xcvr_interface_analogreset   => tx_xcvr_interface_tx_analogreset,
			dp_0_dp_tx_xcvr_interface_digitalreset  => tx_xcvr_interface_tx_digitalreset,
			dp_0_dp_tx_xcvr_interface_cal_busy      => tx_xcvr_interface_tx_cal_busy,
			dp_0_dp_tx_xcvr_interface_std_clkout    => tx_xcvr_interface_tx_std_clkout,
			dp_0_dp_tx_xcvr_interface_pll_locked    => tx_xcvr_interface_tx_pll_locked,      
            
			dp_0_dp_tx_reconfig_link_rate        => tx_reconfig_link_rate,     
			dp_0_dp_tx_reconfig_link_rate_8bits  => tx_reconfig_link_rate_8bits,
			dp_0_dp_tx_reconfig_reconfig_req     => tx_reconfig_reconfig_req,   
			dp_0_dp_tx_reconfig_reconfig_ack     => tx_reconfig_reconfig_ack,   
			dp_0_dp_tx_reconfig_reconfig_busy    => tx_reconfig_reconfig_busy,     
				----------------------------------------------------------------------
			dp_0_tx_reconfig_tx_link_rate         => tx_reconfig_link_rate,     
			dp_0_tx_reconfig_tx_link_rate_8bits   => tx_reconfig_link_rate_8bits,
			dp_0_tx_reconfig_tx_reconfig_req      => tx_reconfig_reconfig_req,   
			dp_0_tx_reconfig_tx_reconfig_ack      => tx_reconfig_reconfig_ack,   
			dp_0_tx_reconfig_tx_reconfig_busy     => tx_reconfig_reconfig_busy,     
				
			dp_0_oc_i2c_scl_pad_io                => dp_0_oc_i2c_scl_pad_io,
			dp_0_oc_i2c_sda_pad_io                => dp_0_oc_i2c_sda_pad_io,
				
            
			dp_0_dp_tx_aux_aux_in   => B5A_PERSTL1_N,
			dp_0_dp_tx_aux_aux_out => B3B_TX_B37_N,              
			dp_0_dp_tx_aux_aux_oe  => B4A_RX_B55_N,             
			dp_0_dp_tx_aux_hpd     => B4A_RX_B66_P,               
				
			dp_0_dp_tx_video_in_data      =>  tx_video_in_data,        
			dp_0_dp_tx_video_in_de        =>  tx_video_in_de,          
			dp_0_dp_tx_video_in_v_sync    =>  tx_video_in_v_sync,      
			dp_0_dp_tx_video_in_h_sync    =>  tx_video_in_h_sync,     
				----------------------------------------------------------------------
			dp_0_cvo_clocked_video_vid_data         =>  tx_video_in_data,  
			dp_0_cvo_clocked_video_vid_datavalid    =>  tx_video_in_de,    
			dp_0_cvo_clocked_video_vid_v_sync       =>  tx_video_in_v_sync,
			dp_0_cvo_clocked_video_vid_h_sync       =>  tx_video_in_h_sync,
			dp_0_cvo_clocked_video_underflow        => open, 
			dp_0_cvo_clocked_video_vid_f            => open,
			dp_0_cvo_clocked_video_vid_h            => open, 
			dp_0_cvo_clocked_video_vid_v            => open,
			bcon_input_0_bcon_bm_interface_i_bcon_x(0)    => HSMC1_RX7,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(1)    => HSMC1_RX6,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(2)    => HSMC1_RX5,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(3)    => HSMC1_RX4,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_xclk => HSMC1_RX14, --                               .i_bcon_xclk
			bcon_input_0_bcon_bm_interface_o_bcon_cc   => HSMC1_TX7,   --                               .o_bcon_cc
			bcon_input_0_bcon_bm_interface_o_fpga_trig => open,

			alt_vip_cl_cvi_0_clocked_video_vid_clk            => s_vid_clk,
			alt_vip_cl_cvi_0_clocked_video_vid_data           => s_vid_data,
			alt_vip_cl_cvi_0_clocked_video_vid_de             => s_vid_de,
			alt_vip_cl_cvi_0_clocked_video_vid_datavalid      => s_vid_datavalid,
			alt_vip_cl_cvi_0_clocked_video_vid_locked         => '1',
			alt_vip_cl_cvi_0_clocked_video_vid_f              => '0',
			alt_vip_cl_cvi_0_clocked_video_vid_v_sync         => s_vid_v_sync,
			alt_vip_cl_cvi_0_clocked_video_vid_h_sync         => s_vid_h_sync,
			alt_vip_cl_cvi_0_clocked_video_vid_std            => '0',
			alt_vip_cl_cvi_0_clocked_video_vid_color_encoding => (others=>'0'),
			alt_vip_cl_cvi_0_clocked_video_vid_bit_width      => (others=>'0'),
			alt_vip_cl_cvi_0_clocked_video_sof                => open,
			alt_vip_cl_cvi_0_clocked_video_sof_locked         => open,
			alt_vip_cl_cvi_0_clocked_video_refclk_div         => open,
			alt_vip_cl_cvi_0_clocked_video_overflow           => open,
			alt_vip_cl_cvi_1_clocked_video_vid_clk            => s_vid_clk,
			alt_vip_cl_cvi_1_clocked_video_vid_data           => s_vid_data,
			alt_vip_cl_cvi_1_clocked_video_vid_de             => s_vid_de,
			alt_vip_cl_cvi_1_clocked_video_vid_datavalid      => s_vid_datavalid,
			alt_vip_cl_cvi_1_clocked_video_vid_locked         => '1',
			alt_vip_cl_cvi_1_clocked_video_vid_f              => '0',
			alt_vip_cl_cvi_1_clocked_video_vid_v_sync         => s_vid_v_sync,
			alt_vip_cl_cvi_1_clocked_video_vid_h_sync         => s_vid_h_sync,
			alt_vip_cl_cvi_1_clocked_video_vid_std            => '0',
			alt_vip_cl_cvi_1_clocked_video_vid_color_encoding => (others=>'0'),
			alt_vip_cl_cvi_1_clocked_video_vid_bit_width      => (others=>'0'),
			alt_vip_cl_cvi_1_clocked_video_sof                => open,
			alt_vip_cl_cvi_1_clocked_video_sof_locked         => open,
			alt_vip_cl_cvi_1_clocked_video_refclk_div         => open,
			alt_vip_cl_cvi_1_clocked_video_overflow           => open,
			bcon_input_0_pixel_clock_clk                      => s_vid_clk,
			bcon_input_0_data_clock_clk                       => s_vid_clk,
			bcon_input_0_data_out_data                        => open,
			bcon_input_0_data_out_valid                       => open,
			bcon_input_0_data_out_endofpacket                 => open,
			bcon_input_0_data_out_startofpacket               => open,
			bcon_input_0_data_out_ready                       => '1',
			bcon_input_0_video_out_line_valid                 => s_line_valid,
			bcon_input_0_video_out_frame_valid                => s_frame_valid,
			bcon_input_0_video_out_data_valid                 => s_data_valid,
			bcon_input_0_video_out_data                       => s_data,
			i2c2_out_data                	  => HSMC1_SDA_OUT,
			i2c2_sda				    	        => HSMC1_SMSDA,
			i2c2_clk_clk					     => HSMC1_SCL_OUT,
			i2c2_scl_in_clk					  => HSMC1_SMSCL,
			i2c3_out_data                   => PCIE_SMDAT_OUT,
			i2c3_sda                        => PCIE_SMDAT,  -- sda
			i2c3_scl_in_clk                 => PCIE_SMCLK,    -- clk
			id2c3_clk_clk                   => PCIE_SMCLK_OUT      -- clk
		);

	-- for RGB, data is output on camera as BGR (B=bit 23-16). VIPII wants RGB(R=bit23-16)
	s_vid_data(23 downto 16) <= s_data(7 downto 0);
	s_vid_data(15 downto 8)  <= s_data(15 downto 8);
	s_vid_data(7 downto 0)   <= s_data(23 downto 16);
	
	s_vid_de <= s_data_valid;
	s_vid_datavalid <= '1';
	s_vid_v_sync <= not s_frame_valid;
	s_vid_h_sync <= not s_line_valid;
	HSMC1_SMSCL_OD : OPNDRN	port map (a_in => not HSMC1_SCL_OUT, a_out => HSMC1_SMSCL);
	HSMC1_SMSDA_OD : OPNDRN	port map (a_in => not HSMC1_SDA_OUT, a_out => HSMC1_SMSDA);

	PCIE_SMDAT_OD : OPNDRN	port map (a_in => not PCIE_SMDAT_OUT, a_out => PCIE_SMDAT);
	PCIE_SMCLK_OD : OPNDRN	port map (a_in => not PCIE_SMCLK_OUT, a_out => PCIE_SMCLK);

end architecture rtl;

-------------------------------------------------------------------------------
