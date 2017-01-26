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
create_clock -period 10.000 [get_ports CLK2DDR]
create_clock -period 10.000 [get_ports GXB_REFCLK0]
create_generated_clock -name clk50 -source [get_pins {u0|dp_0|dp_transceivers_0|clk50_|clk}] -divide_by 2 [get_pins {u0|dp_0|dp_transceivers_0|clk50_|q}]

# Constrain I2C to HDMI transmitter
create_generated_clock -name scl -source [get_pins {u0|hps_0|fpga_interfaces|peripheral_i2c2|out_clk}] -divide_by 250 [get_ports {B4A_RX_B74_P}]
set_output_delay -max 2 -clock [get_clocks {scl}] [get_ports {B4A_RX_B74_N}]
set_output_delay -min 1 -clock [get_clocks {scl}] [get_ports {B4A_RX_B74_N}] -add_delay


derive_pll_clocks
derive_clock_uncertainty

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

