# For enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdo]

# For async resets
set_false_path -from {dev_5csx_h6_42a:u0|altera_reset_controller:rst_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out} -to *

# HPS peripherals ignores, these are in hard silicon so they will not affect routing 
create_clock -period 10.000 [get_ports USB1_ULPI_CLK]
create_clock -period 10.000 [get_ports B7A_I2C0_SCL]
create_clock -period 10.000 [get_ports I2C1_SCL]

# Constrain I2C to HDMI transmitter
create_generated_clock -name scl -source [get_pins {u0|hps_0|fpga_interfaces|peripheral_i2c2|out_clk}] -divide_by 250 [get_ports {HSMC1_SMSCL}]
set_output_delay -max 2 -clock [get_clocks {scl}] [get_ports {HSMC1_SMSDA}]
set_output_delay -min 1 -clock [get_clocks {scl}] [get_ports {HSMC1_SMSDA}]


derive_pll_clocks
derive_clock_uncertainty


create_generated_clock -name HDMI_TX_CLK -source [get_pins {u0|hdmi_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] [get_ports {HSMC1_CLKOUT1}]

# Set output delays on data and control
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX11}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX16_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX16}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX16_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX16}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX15_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX15}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX14_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX14}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX13_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX13}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX12_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX12}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX11_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX11}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX10_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX10}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX9_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX9}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX8_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_RX8}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX8_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX8}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX7_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX7}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX10_N}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX11}]
set_output_delay -clock { HDMI_TX_CLK } 2 [get_ports {HSMC1_TX11_N}]

set_false_path -from * -to [get_ports {HSMC1_CLKOUT1}]

# Set false paths for HPS IO (it's in hard silicone)
set_false_path -from [get_ports {B7A_CAN0_RX}] -to *
set_false_path -from [get_ports {B7A_CAN1_RX}] -to *
set_false_path -from [get_ports {B7A_I2C0_SDA}] -to *
set_false_path -from [get_ports {B7A_UART0_RX}] -to *
set_false_path -from [get_ports {I2C1_SDA}] -to *
set_false_path -from [get_ports {LED1}] -to *
set_false_path -from [get_ports {LED2}] -to *
set_false_path -from [get_ports {LED3}] -to *
set_false_path -from [get_ports {QSPI_DQ0}] -to *
set_false_path -from [get_ports {QSPI_DQ1}] -to *
set_false_path -from [get_ports {QSPI_DQ2}] -to *
set_false_path -from [get_ports {QSPI_DQ3}] -to *
set_false_path -from [get_ports {RGMII1_MDIO}] -to *
set_false_path -from [get_ports {RGMII1_RESETn}] -to *
set_false_path -from [get_ports {RGMII1_RXD0}] -to *
set_false_path -from [get_ports {RGMII1_RXD1}] -to *
set_false_path -from [get_ports {RGMII1_RXD2}] -to *
set_false_path -from [get_ports {RGMII1_RXD3}] -to *
set_false_path -from [get_ports {RGMII1_RX_CLK}] -to *
set_false_path -from [get_ports {RGMII1_RX_CTL}] -to *
set_false_path -from [get_ports {SDMMC_CMD}] -to *
set_false_path -from [get_ports {SDMMC_D0}] -to *
set_false_path -from [get_ports {SDMMC_D1}] -to *
set_false_path -from [get_ports {SDMMC_D2}] -to *
set_false_path -from [get_ports {SDMMC_D3}] -to *
set_false_path -from [get_ports {SW1}] -to *
set_false_path -from [get_ports {SW2}] -to *
set_false_path -from [get_ports {SW3}] -to *
set_false_path -from [get_ports {USB1_ULPI_CLK}] -to *
set_false_path -from [get_ports {USB1_ULPI_CS}] -to *
set_false_path -from [get_ports {USB1_ULPI_D0}] -to *
set_false_path -from [get_ports {USB1_ULPI_D1}] -to *
set_false_path -from [get_ports {USB1_ULPI_D2}] -to *
set_false_path -from [get_ports {USB1_ULPI_D3}] -to *
set_false_path -from [get_ports {USB1_ULPI_D3}] -to *
set_false_path -from [get_ports {USB1_ULPI_D4}] -to *
set_false_path -from [get_ports {USB1_ULPI_D5}] -to *
set_false_path -from [get_ports {USB1_ULPI_D6}] -to *
set_false_path -from [get_ports {USB1_ULPI_D7}] -to *
set_false_path -from [get_ports {USB1_ULPI_DIR}] -to *
set_false_path -from [get_ports {USB1_ULPI_NXT}] -to *
set_false_path -from [get_ports {USB1_ULPI_RESET_N}] -to *

set_false_path -from * -to [get_ports {B7A_CAN0_TX}]
set_false_path -from * -to [get_ports {B7A_CAN1_TX}]
set_false_path -from * -to [get_ports {B7A_I2C0_SCL}]
set_false_path -from * -to [get_ports {B7A_I2C0_SDA}]
set_false_path -from * -to [get_ports {B7A_UART0_TX}]
set_false_path -from * -to [get_ports {I2C1_SCL}]
set_false_path -from * -to [get_ports {I2C1_SDA}]
set_false_path -from * -to [get_ports {LED1}]
set_false_path -from * -to [get_ports {LED2}]
set_false_path -from * -to [get_ports {LED3}]
set_false_path -from * -to [get_ports {LED3}]
set_false_path -from * -to [get_ports {QSPI_CLK}]
set_false_path -from * -to [get_ports {QSPI_DQ0}]
set_false_path -from * -to [get_ports {QSPI_DQ1}]
set_false_path -from * -to [get_ports {QSPI_DQ2}]
set_false_path -from * -to [get_ports {QSPI_DQ3}]
set_false_path -from * -to [get_ports {QSPI_SS0}]
set_false_path -from * -to [get_ports {QSPI_SS1}]
set_false_path -from * -to [get_ports {RGMII1_MDC}]
set_false_path -from * -to [get_ports {RGMII1_MDIO}]
set_false_path -from * -to [get_ports {RGMII1_RESETn}]
set_false_path -from * -to [get_ports {RGMII1_TXD0}]
set_false_path -from * -to [get_ports {RGMII1_TXD1}]
set_false_path -from * -to [get_ports {RGMII1_TXD2}]
set_false_path -from * -to [get_ports {RGMII1_TXD3}]
set_false_path -from * -to [get_ports {RGMII1_TX_CLK}]
set_false_path -from * -to [get_ports {RGMII1_TX_CTL}]
set_false_path -from * -to [get_ports {SDMMC_CLK}]
set_false_path -from * -to [get_ports {SDMMC_CMD}]
set_false_path -from * -to [get_ports {SDMMC_D0}]
set_false_path -from * -to [get_ports {SDMMC_D1}]
set_false_path -from * -to [get_ports {SDMMC_D2}]
set_false_path -from * -to [get_ports {SDMMC_D3}]
set_false_path -from * -to [get_ports {SW1}]
set_false_path -from * -to [get_ports {SW2}]
set_false_path -from * -to [get_ports {SW3}]
set_false_path -from * -to [get_ports {USB1_ULPI_CLK}]
set_false_path -from * -to [get_ports {USB1_ULPI_CS}]
set_false_path -from * -to [get_ports {USB1_ULPI_D0}]
set_false_path -from * -to [get_ports {USB1_ULPI_D1}]
set_false_path -from * -to [get_ports {USB1_ULPI_D2}]
set_false_path -from * -to [get_ports {USB1_ULPI_D3}]
set_false_path -from * -to [get_ports {USB1_ULPI_D4}]
set_false_path -from * -to [get_ports {USB1_ULPI_D5}]
set_false_path -from * -to [get_ports {USB1_ULPI_D6}]
set_false_path -from * -to [get_ports {USB1_ULPI_D7}]
set_false_path -from * -to [get_ports {USB1_ULPI_RESET_N}]
set_false_path -from * -to [get_ports {USB1_ULPI_STP}]

set_false_path -from [get_ports {HSMC1_TX0}] -to *
set_false_path -from [get_ports {HSMC1_TX1}] -to *
set_false_path -from [get_ports {HSMC1_TX2}] -to *
set_false_path -from [get_ports {HSMC1_TX3}] -to *
set_false_path -from [get_ports {HSMC1_TX4}] -to *
set_false_path -from [get_ports {HSMC1_TX5}] -to *
set_false_path -from [get_ports {HSMC1_TX6}] -to *
set_false_path -from [get_ports {HSMC1_TX9}] -to *
set_false_path -from [get_ports {HSMC1_TX10}] -to *
set_false_path -from [get_ports {HSMC1_TX12}] -to *
set_false_path -from [get_ports {HSMC1_TX14}] -to *
set_false_path -from [get_ports {HSMC1_TX15}] -to *
set_false_path -from [get_ports {HSMC1_TX0_N}] -to *
set_false_path -from [get_ports {HSMC1_TX1_N}] -to *
set_false_path -from [get_ports {HSMC1_TX2_N}] -to *
set_false_path -from [get_ports {HSMC1_TX3_N}] -to *
set_false_path -from [get_ports {HSMC1_TX4_N}] -to *
set_false_path -from [get_ports {HSMC1_TX5_N}] -to *
set_false_path -from [get_ports {HSMC1_TX6_N}] -to *
set_false_path -from [get_ports {HSMC1_TX9_N}] -to *
set_false_path -from [get_ports {HSMC1_TX12_N}] -to *
set_false_path -from [get_ports {HSMC1_TX14_N}] -to *
set_false_path -from [get_ports {HSMC1_TX15_N}] -to *
set_false_path -from [get_ports {HSMC1_CLKOUT0}] -to *
set_false_path -from [get_ports {HSMC1_CLKOUT2}] -to *
set_false_path -from [get_ports {HSMC1_CLKOUT1_N}] -to *
set_false_path -from [get_ports {HSMC1_CLKOUT2_N}] -to *
set_false_path -from [get_ports {HSMC1_D0}] -to *
set_false_path -from [get_ports {HSMC1_D2}] -to *
set_false_path -from [get_ports {HSMC1_RX0}] -to *
set_false_path -from [get_ports {HSMC1_RX1}] -to *
set_false_path -from [get_ports {HSMC1_RX2}] -to *
set_false_path -from [get_ports {HSMC1_RX3}] -to *
set_false_path -from [get_ports {HSMC1_RX4}] -to *
set_false_path -from [get_ports {HSMC1_RX5}] -to *
set_false_path -from [get_ports {HSMC1_RX6}] -to *
set_false_path -from [get_ports {HSMC1_RX7}] -to *
set_false_path -from [get_ports {HSMC1_RX0_N}] -to *
set_false_path -from [get_ports {HSMC1_RX1_N}] -to *
set_false_path -from [get_ports {HSMC1_RX2_N}] -to *
set_false_path -from [get_ports {HSMC1_RX3_N}] -to *
set_false_path -from [get_ports {HSMC1_RX4_N}] -to *
set_false_path -from [get_ports {HSMC1_RX5_N}] -to *
set_false_path -from [get_ports {HSMC1_RX6_N}] -to *
set_false_path -from [get_ports {HSMC1_RX7_N}] -to *
set_false_path -from [get_ports {HSMC1_CLKIN0}] -to *
set_false_path -from [get_ports {HSMC1_CLKIN1}] -to *
set_false_path -from [get_ports {HSMC1_CLKIN2}] -to *
set_false_path -from [get_ports {HSMC1_CLKIN1_N}] -to *
set_false_path -from [get_ports {HSMC1_CLKIN2_N}] -to *
set_false_path -from [get_ports {HSMC1_D1}] -to *
set_false_path -from [get_ports {HSMC1_D3}] -to *
set_false_path -from [get_ports {HSMC1_PRSNTn}] -to *
set_false_path -from [get_ports {HSMC2_SMSCL}] -to *
set_false_path -from [get_ports {HSMC2_D2_P}] -to *
set_false_path -from [get_ports {HSMC2_D2_N}] -to *
set_false_path -from [get_ports {HSMC2_RX0_P}] -to *
set_false_path -from [get_ports {HSMC2_RX0_N}] -to *
set_false_path -from [get_ports {HSMC2_RX1_P}] -to *
set_false_path -from [get_ports {HSMC2_RX1_N}] -to *
set_false_path -from [get_ports {HSMC2_PRSNTN}] -to *
set_false_path -from [get_ports {HSMC2_SMSDA}] -to *
set_false_path -from [get_ports {HSMC2_D1_P}] -to *
set_false_path -from [get_ports {HSMC2_D1_N}] -to *
set_false_path -from [get_ports {HSMC2_TX0_P}] -to *
set_false_path -from [get_ports {HSMC2_TX0_N}] -to *
set_false_path -from [get_ports {HSMC2_TX1}] -to *

set_false_path -from [get_ports {HSMC1_SMSCL}] -to *
set_false_path -from [get_ports {HSMC1_SMSDA}] -to *

set_false_path -from * -to [get_ports {HSMC1_SMSCL}]
set_false_path -from * -to [get_ports {HSMC1_TX0}]
set_false_path -from * -to [get_ports {HSMC1_TX1}]
set_false_path -from * -to [get_ports {HSMC1_TX2}]
set_false_path -from * -to [get_ports {HSMC1_TX3}]
set_false_path -from * -to [get_ports {HSMC1_TX4}]
set_false_path -from * -to [get_ports {HSMC1_TX5}]
set_false_path -from * -to [get_ports {HSMC1_TX6}]
set_false_path -from * -to [get_ports {HSMC1_TX9}]
set_false_path -from * -to [get_ports {HSMC1_TX10}]
set_false_path -from * -to [get_ports {HSMC1_TX12}]
set_false_path -from * -to [get_ports {HSMC1_TX14}]
set_false_path -from * -to [get_ports {HSMC1_TX15}]
set_false_path -from * -to [get_ports {HSMC1_TX0_N}]
set_false_path -from * -to [get_ports {HSMC1_TX1_N}]
set_false_path -from * -to [get_ports {HSMC1_TX2_N}]
set_false_path -from * -to [get_ports {HSMC1_TX3_N}]
set_false_path -from * -to [get_ports {HSMC1_TX4_N}]
set_false_path -from * -to [get_ports {HSMC1_TX5_N}]
set_false_path -from * -to [get_ports {HSMC1_TX6_N}]
set_false_path -from * -to [get_ports {HSMC1_TX9_N}]
set_false_path -from * -to [get_ports {HSMC1_TX12_N}]
set_false_path -from * -to [get_ports {HSMC1_TX14_N}]
set_false_path -from * -to [get_ports {HSMC1_TX15_N}]
set_false_path -from * -to [get_ports {HSMC1_CLKOUT0}]
set_false_path -from * -to [get_ports {HSMC1_CLKOUT2}]
set_false_path -from * -to [get_ports {HSMC1_CLKOUT1_N}]
set_false_path -from * -to [get_ports {HSMC1_CLKOUT2_N}]
set_false_path -from * -to [get_ports {HSMC1_D0}]
set_false_path -from * -to [get_ports {HSMC1_D2}]
set_false_path -from * -to [get_ports {HSMC1_RX0}]
set_false_path -from * -to [get_ports {HSMC1_RX1}]
set_false_path -from * -to [get_ports {HSMC1_RX2}]
set_false_path -from * -to [get_ports {HSMC1_RX3}]
set_false_path -from * -to [get_ports {HSMC1_RX4}]
set_false_path -from * -to [get_ports {HSMC1_RX5}]
set_false_path -from * -to [get_ports {HSMC1_RX6}]
set_false_path -from * -to [get_ports {HSMC1_RX7}]
set_false_path -from * -to [get_ports {HSMC1_RX0_N}]
set_false_path -from * -to [get_ports {HSMC1_RX1_N}]
set_false_path -from * -to [get_ports {HSMC1_RX2_N}]
set_false_path -from * -to [get_ports {HSMC1_RX3_N}]
set_false_path -from * -to [get_ports {HSMC1_RX4_N}]
set_false_path -from * -to [get_ports {HSMC1_RX5_N}]
set_false_path -from * -to [get_ports {HSMC1_RX6_N}]
set_false_path -from * -to [get_ports {HSMC1_RX7_N}]
set_false_path -from * -to [get_ports {HSMC1_CLKIN0}]
set_false_path -from * -to [get_ports {HSMC1_CLKIN1}]
set_false_path -from * -to [get_ports {HSMC1_CLKIN2}]
set_false_path -from * -to [get_ports {HSMC1_CLKIN1_N}]
set_false_path -from * -to [get_ports {HSMC1_CLKIN2_N}]
set_false_path -from * -to [get_ports {HSMC1_D1}]
set_false_path -from * -to [get_ports {HSMC1_D3}]
set_false_path -from * -to [get_ports {HSMC1_PRSNTn}]
set_false_path -from * -to [get_ports {HSMC2_SMSCL}]
set_false_path -from * -to [get_ports {HSMC2_D2_P}]
set_false_path -from * -to [get_ports {HSMC2_D2_N}]
set_false_path -from * -to [get_ports {HSMC2_RX0_P}]
set_false_path -from * -to [get_ports {HSMC2_RX0_N}]
set_false_path -from * -to [get_ports {HSMC2_RX1_P}]
set_false_path -from * -to [get_ports {HSMC2_RX1_N}]
set_false_path -from * -to [get_ports {HSMC2_PRSNTN}]
set_false_path -from * -to [get_ports {HSMC2_SMSDA}]
set_false_path -from * -to [get_ports {HSMC2_D1_P}]
set_false_path -from * -to [get_ports {HSMC2_D1_N}]
set_false_path -from * -to [get_ports {HSMC2_TX0_P}]
set_false_path -from * -to [get_ports {HSMC2_TX0_N}]
set_false_path -from * -to [get_ports {HSMC2_TX1}]
