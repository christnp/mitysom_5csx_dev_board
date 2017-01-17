-------------------------------------------------------------------------------
-- Title      : dev_5csx_h6_4ya_top
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
-- Last update: 2016-05-25
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top level entity for the mitysom-5CSX Development Board
-------------------------------------------------------------------------------
-- Copyright (c) 2015 Critical Link, LLC
-------------------------------------------------------------------------------
-- Revisions  :
-- Date			Version	Author	Description
-- 2013-07-28	0.1		Dan V		Initial
-- 2013-09-11	0.2		Dan V		Base Dev Board with probes for Full HSMC
--											Loopback
--	2013-10-09	0.3		Dan V		Moved HSMC IO to PIO core connected to HPS
-- 2014-05-01	0.4		Dan V		Added FPGA DDR, HPS BERT Test,Renamed to mitysom
-- 2014-05-02	1.0		Dan V		Updated to use 5CSXFC6CU23C7, added DDR 
--											termination settings to tcl scripts
-- 2014-12-19	1.1		Dan V		Moved HSMC2 to PIO core
-- 2015-05-25	1.2		Dan V		-Renamed project dev_5csx_h6_4ya
--									-Changed HSMC IO to be bi directional
--									-Changed address location for PIO blocks
--									-Made PIO continuous blocks
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library altera;
use altera.altera_primitives_components.all;

-------------------------------------------------------------------------------

entity dev_5csx_h6_4ya_top is
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

		-- HSMC1
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
end entity dev_5csx_h6_4ya_top;

-------------------------------------------------------------------------------

architecture rtl of dev_5csx_h6_4ya_top is
	component dev_5csx_h6_4ya is
		port (
			hps_ddr_mem_a                              : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_ddr_mem_ba                             : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_ddr_mem_ck                             : out   std_logic;                                        -- mem_ck
			hps_ddr_mem_ck_n                           : out   std_logic;                                        -- mem_ck_n
			hps_ddr_mem_cke                            : out   std_logic;                                        -- mem_cke
			hps_ddr_mem_cs_n                           : out   std_logic;                                        -- mem_cs_n
			hps_ddr_mem_ras_n                          : out   std_logic;                                        -- mem_ras_n
			hps_ddr_mem_cas_n                          : out   std_logic;                                        -- mem_cas_n
			hps_ddr_mem_we_n                           : out   std_logic;                                        -- mem_we_n
			hps_ddr_mem_reset_n                        : out   std_logic;                                        -- mem_reset_n
			hps_ddr_mem_dq                             : inout std_logic_vector(39 downto 0) := (others => 'X'); -- mem_dq
			hps_ddr_mem_dqs                            : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs
			hps_ddr_mem_dqs_n                          : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_ddr_mem_odt                            : out   std_logic;                                        -- mem_odt
			hps_ddr_mem_dm                             : out   std_logic_vector(4 downto 0);                     -- mem_dm
			hps_ddr_oct_rzqin                          : in    std_logic                     := 'X';             -- oct_rzqin
			hps_io_hps_io_emac1_inst_TX_CLK            : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0              : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1              : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2              : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3              : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO              : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC               : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL            : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_SS1                : out   std_logic;                                        -- hps_io_qspi_inst_SS1
			hps_io_hps_io_qspi_inst_IO0                : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1                : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2                : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3                : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0                : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK                : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD                : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0                 : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1                 : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK                : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2                 : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3                 : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7                 : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK                : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP                : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR                : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT                : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX                : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX                : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA                : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL                : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA                : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL                : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_can0_inst_RX                 : in    std_logic                     := 'X';             -- hps_io_can0_inst_RX
			hps_io_hps_io_can0_inst_TX                 : out   std_logic;                                        -- hps_io_can0_inst_TX
			hps_io_hps_io_can1_inst_RX                 : in    std_logic                     := 'X';             -- hps_io_can1_inst_RX
			hps_io_hps_io_can1_inst_TX                 : out   std_logic;                                        -- hps_io_can1_inst_TX
			hps_io_hps_io_gpio_inst_GPIO00             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO28             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO28
			hps_io_hps_io_gpio_inst_GPIO37             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO37
			hps_io_hps_io_gpio_inst_GPIO40             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO48             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO49             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50             : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO50
			bcon_input_0_bcon_bm_interface_i_bcon_x    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_xclk : in    std_logic                     := 'X';             -- i_bcon_xclk
			bcon_input_0_bcon_bm_interface_o_bcon_cc   : out   std_logic;                                        -- o_bcon_cc
			bcon_input_0_bcon_bm_interface_o_fpga_trig : out   std_logic;                                        -- o_fpga_trig
--			bcon_input_1_bcon_bm_interface_i_bcon_x    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- i_bcon_x
--			bcon_input_1_bcon_bm_interface_i_bcon_xclk : in    std_logic                     := 'X';             -- i_bcon_xclk
--			bcon_input_1_bcon_bm_interface_o_bcon_cc   : out   std_logic;                                        -- o_bcon_cc
--			bcon_input_1_bcon_bm_interface_o_fpga_trig : out   std_logic                                        -- o_fpga_trig
			hps_0_i2c2_out_data                        : out   std_logic;                                        -- out_data
			hps_0_i2c2_sda                             : in    std_logic                     := 'X';             -- sda
			hps_0_i2c2_clk_clk                         : out   std_logic;                                        -- clk
			hps_0_i2c2_scl_in_clk                      : in    std_logic                     := 'X'              -- clk
		);
	end component dev_5csx_h6_4ya;
	
	component gbl_clock is
		port (
			inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
			outclk : out std_logic         -- altclkctrl_output.outclk
		);
	end component gbl_clock;
	
	signal gclk_x : std_logic := '0';
	signal HSMC1_SDA_OUT : std_logic := '1';
	signal HSMC1_SCL_OUT : std_logic := '1';

begin                                   -- architecture rtl

	----------------------------------------------------------------------------
	-- Component instantiations
	----------------------------------------------------------------------------

	u0 : component dev_5csx_h6_4ya
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
			-- Can only use 1 connector at a time at the moment.
			bcon_input_0_bcon_bm_interface_i_bcon_x(0)    => HSMC1_RX7,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(1)    => HSMC1_RX6,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(2)    => HSMC1_RX5,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_x(3)    => HSMC1_RX4,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
			bcon_input_0_bcon_bm_interface_i_bcon_xclk => HSMC1_RX14, --                               .i_bcon_xclk
			bcon_input_0_bcon_bm_interface_o_bcon_cc   => HSMC1_TX7,   --                               .o_bcon_cc
			bcon_input_0_bcon_bm_interface_o_fpga_trig => open,  --                               .o_fpga_trig
--			bcon_input_0_bcon_bm_interface_i_bcon_x(0)    => HSMC1_RX16,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_0_bcon_bm_interface_i_bcon_x(1)    => HSMC1_RX11,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_0_bcon_bm_interface_i_bcon_x(2)    => HSMC1_RX12,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_0_bcon_bm_interface_i_bcon_x(3)    => HSMC1_RX13,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_0_bcon_bm_interface_i_bcon_xclk => HSMC1_RX15, --                               .i_bcon_xclk
--			bcon_input_0_bcon_bm_interface_o_bcon_cc   => HSMC1_TX16,   --                               .o_bcon_cc
--			bcon_input_0_bcon_bm_interface_o_fpga_trig => open,  --                               .o_fpga_trig
--			bcon_input_1_bcon_bm_interface_i_bcon_x(0)    => HSMC1_RX7,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_1_bcon_bm_interface_i_bcon_x(1)    => HSMC1_RX6,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_1_bcon_bm_interface_i_bcon_x(2)    => HSMC1_RX5,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_1_bcon_bm_interface_i_bcon_x(3)    => HSMC1_RX4,    -- bcon_input_1_bcon_bm_interface.i_bcon_x
--			bcon_input_1_bcon_bm_interface_i_bcon_xclk => gclk_x, -- HSMC1_RX14, --                               .i_bcon_xclk
--			bcon_input_1_bcon_bm_interface_o_bcon_cc   => HSMC1_TX7,   --                               .o_bcon_cc
--			bcon_input_1_bcon_bm_interface_o_fpga_trig => open  --                               .o_fpga_trig

			hps_0_i2c2_out_data                 => HSMC1_SDA_OUT, -- : out   std_logic;                                        -- out_data
			hps_0_i2c2_sda                      => HSMC1_SMSDA, -- : in    std_logic                     := 'X';             -- sda
			hps_0_i2c2_clk_clk                  => HSMC1_SCL_OUT, -- : out   std_logic;                                        -- clk
			hps_0_i2c2_scl_in_clk               => HSMC1_SMSCL -- : in    std_logic                     := 'X'              -- clk
			
		);
		
		HSMC1_SMSCL_OD : OPNDRN	port map (a_in => not HSMC1_SCL_OUT, a_out => HSMC1_SMSCL);
		HSMC1_SMSDA_OD : OPNDRN	port map (a_in => not HSMC1_SDA_OUT, a_out => HSMC1_SMSDA);
		
		--gc : gbl_clock
		--	port map (
		--		inclk  => HSMC1_RX14,
		--		outclk => gclk_x
		--	);
				
end architecture rtl;

-------------------------------------------------------------------------------
