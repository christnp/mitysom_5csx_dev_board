# 50MHz board input clock
create_clock -period "100 MHz" [get_ports pcie_refclk_clk]
create_clock -period "125 MHz" -name {coreclk} {*coreclk*}

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

# False path for reset inputs
set_false_path -from [get_ports pcie_npor_pin_perst] -to *
set_false_path -from [get_ports pcie_npor_npor] -to *
### set_false_path -from [get_ports fpga_rst_n] -to *

#False path for reset output
### set_false_path -from * -to [get_ports pcie_perstn_out]
set_false_path -from * -to [get_ports pcie_npor_pin_perst]

# False path for LED low priority path
### set_false_path -from * -to [get_ports fpga_led_pio[*]]

# FPGA IO port constraints
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_button_pio[0]}]
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_button_pio[1]}]
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_dipsw_pio[0]}]
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_dipsw_pio[1]}]
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_dipsw_pio[2]}]
### set_input_delay -clock {fpga_clk_50} -add_delay 10 [get_ports {fpga_dipsw_pio[3]}]
### set_output_delay -clock {coreclk} -add_delay 10 [get_ports {fpga_led_pio[0]}]
### set_output_delay -clock {coreclk} -add_delay 10 [get_ports {fpga_led_pio[1]}]
### set_output_delay -clock {coreclk} -add_delay 10 [get_ports {fpga_led_pio[2]}]
### set_output_delay -clock {coreclk} -add_delay 10 [get_ports {fpga_led_pio[3]}]
### set_output_delay -clock {fpga_clk_50} -add_delay 10 [get_ports pcie_perstn_out]
set_output_delay -clock {pcie_refclk_clk} -add_delay 10 [get_ports pcie_npor_pin_perst]

# HPS peripherals port false path setting to workaround the unconstraint path (setting false_path for hps_0 ports will not affect the routing as it is hard silicon)

set_false_path -from * -to [get_ports {RGMII1_TX_CLK}]
set_false_path -from * -to [get_ports {RGMII1_TXD0}]
set_false_path -from * -to [get_ports {RGMII1_TXD1}]
set_false_path -from * -to [get_ports {RGMII1_TXD2}]
set_false_path -from * -to [get_ports {RGMII1_TXD3}]
set_false_path -from * -to [get_ports {RGMII1_RXD0}]
set_false_path -from * -to [get_ports {RGMII1_MDIO}]
set_false_path -from * -to [get_ports {RGMII1_MDC}]
set_false_path -from * -to [get_ports {RGMII1_RX_CTL}]
set_false_path -from * -to [get_ports {RGMII1_TX_CTL}]
set_false_path -from * -to [get_ports {RGMII1_RX_CLK}]
set_false_path -from * -to [get_ports {RGMII1_RXD1}]
set_false_path -from * -to [get_ports {RGMII1_RXD2}]
set_false_path -from * -to [get_ports {RGMII1_RXD3}]
set_false_path -from * -to [get_ports {RGMII1_RESETn}]
set_false_path -from * -to [get_ports {QSPI_DQ0}]
set_false_path -from * -to [get_ports {QSPI_DQ1}]
set_false_path -from * -to [get_ports {QSPI_DQ2}]
set_false_path -from * -to [get_ports {QSPI_DQ3}]
set_false_path -from * -to [get_ports {QSPI_SS0}]
set_false_path -from * -to [get_ports {QSPI_SS1}]
set_false_path -from * -to [get_ports {QSPI_CLK}]
set_false_path -from * -to [get_ports {SDMMC_CMD}]
set_false_path -from * -to [get_ports {SDMMC_D0}]
set_false_path -from * -to [get_ports {SDMMC_D1}]
set_false_path -from * -to [get_ports {SDMMC_CLK}]
set_false_path -from * -to [get_ports {SDMMC_D2}]
set_false_path -from * -to [get_ports {SDMMC_D3}]
set_false_path -from * -to [get_ports {USB1_ULPI_D0}]
set_false_path -from * -to [get_ports {USB1_ULPI_D1}]
set_false_path -from * -to [get_ports {USB1_ULPI_D2}]
set_false_path -from * -to [get_ports {USB1_ULPI_D3}]
set_false_path -from * -to [get_ports {USB1_ULPI_D4}]
set_false_path -from * -to [get_ports {USB1_ULPI_D5}]
set_false_path -from * -to [get_ports {USB1_ULPI_D6}]
set_false_path -from * -to [get_ports {USB1_ULPI_D7}]
set_false_path -from * -to [get_ports {USB1_ULPI_CLK}]
set_false_path -from * -to [get_ports {USB1_ULPI_STP}]
set_false_path -from * -to [get_ports {USB1_ULPI_DIR}]
set_false_path -from * -to [get_ports {USB1_ULPI_NXT}]
set_false_path -from * -to [get_ports {USB1_ULPI_CS}]
set_false_path -from * -to [get_ports {USB1_ULPI_RESET_N}]
set_false_path -from * -to [get_ports {B7A_UART0_RX}]
set_false_path -from * -to [get_ports {B7A_UART0_TX}]
set_false_path -from * -to [get_ports {B7A_I2C0_SDA}]
set_false_path -from * -to [get_ports {B7A_I2C0_SCL}]
set_false_path -from * -to [get_ports {B7A_CAN0_RX}]
set_false_path -from * -to [get_ports {B7A_CAN0_TX}]
set_false_path -from * -to [get_ports {B7A_CAN1_RX}]
set_false_path -from * -to [get_ports {B7A_CAN1_TX}]
set_false_path -from * -to [get_ports {I2C1_SCL}]
set_false_path -from * -to [get_ports {I2C1_SDA}]
set_false_path -from * -to [get_ports {LED1}]
set_false_path -from * -to [get_ports {LED2}]
set_false_path -from * -to [get_ports {LED3}]
set_false_path -from * -to [get_ports {SW1}]
set_false_path -from * -to [get_ports {SW2}]
set_false_path -from * -to [get_ports {SW3}]

### set_false_path -from * -to [get_ports {hps_emac1_TX_CLK}] 
### set_false_path -from * -to [get_ports {hps_emac1_TXD0}] 
### set_false_path -from * -to [get_ports {hps_emac1_TXD1}] 
### set_false_path -from * -to [get_ports {hps_emac1_TXD2}] 
### set_false_path -from * -to [get_ports {hps_emac1_TXD3}] 
### set_false_path -from * -to [get_ports {hps_emac1_MDC}] 
### set_false_path -from * -to [get_ports {hps_emac1_TX_CTL*}] 
### set_false_path -from * -to [get_ports {hps_qspi_SS0}] 
### set_false_path -from * -to [get_ports {hps_qspi_CLK}] 
### set_false_path -from * -to [get_ports {hps_sdio_CLK}] 
### set_false_path -from * -to [get_ports {hps_usb1_STP}] 
### set_false_path -from * -to [get_ports {hps_spim0_CLK}] 
### set_false_path -from * -to [get_ports {hps_spim0_MOSI}] 
### set_false_path -from * -to [get_ports {hps_spim0_SS0}] 
### set_false_path -from * -to [get_ports {hps_uart0_TX}] 
### set_false_path -from * -to [get_ports {hps_can0_TX}] 
### set_false_path -from * -to [get_ports {hps_trace_CLK}] 
### set_false_path -from * -to [get_ports {hps_trace_D0}] 
### set_false_path -from * -to [get_ports {hps_trace_D1}] 
### set_false_path -from * -to [get_ports {hps_trace_D2}] 
### set_false_path -from * -to [get_ports {hps_trace_D3}] 
### set_false_path -from * -to [get_ports {hps_trace_D4}] 
### set_false_path -from * -to [get_ports {hps_trace_D5}] 
### set_false_path -from * -to [get_ports {hps_trace_D6}] 
### set_false_path -from * -to [get_ports {hps_trace_D7}] 
### set_false_path -from * -to [get_ports {hps_emac1_MDIO}] 
### set_false_path -from * -to [get_ports {hps_qspi_IO0}] 
### set_false_path -from * -to [get_ports {hps_qspi_IO1}] 
### set_false_path -from * -to [get_ports {hps_qspi_IO2}] 
### set_false_path -from * -to [get_ports {hps_qspi_IO3}] 
### set_false_path -from * -to [get_ports {hps_sdio_CMD}] 
### set_false_path -from * -to [get_ports {hps_sdio_D0}] 
### set_false_path -from * -to [get_ports {hps_sdio_D1}] 
### set_false_path -from * -to [get_ports {hps_sdio_D2}] 
### set_false_path -from * -to [get_ports {hps_sdio_D3}] 
### set_false_path -from * -to [get_ports {hps_usb1_D0}] 
### set_false_path -from * -to [get_ports {hps_usb1_D1}] 
### set_false_path -from * -to [get_ports {hps_usb1_D2}] 
### set_false_path -from * -to [get_ports {hps_usb1_D3}] 
### set_false_path -from * -to [get_ports {hps_usb1_D4}] 
### set_false_path -from * -to [get_ports {hps_usb1_D5}] 
### set_false_path -from * -to [get_ports {hps_usb1_D6}] 
### set_false_path -from * -to [get_ports {hps_usb1_D7}] 
### set_false_path -from * -to [get_ports {hps_i2c0_SDA}] 
### set_false_path -from * -to [get_ports {hps_i2c0_SCL}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO09}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO35}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO41}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO42}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO43}] 
### set_false_path -from * -to [get_ports {hps_gpio_GPIO44}] 

set_false_path -from [get_ports {RGMII1_TX_CLK}] -to *
set_false_path -from [get_ports {RGMII1_TXD0}] -to *
set_false_path -from [get_ports {RGMII1_TXD1}] -to *
set_false_path -from [get_ports {RGMII1_TXD2}] -to *
set_false_path -from [get_ports {RGMII1_TXD3}] -to *
set_false_path -from [get_ports {RGMII1_RXD0}] -to *
set_false_path -from [get_ports {RGMII1_MDIO}] -to *
set_false_path -from [get_ports {RGMII1_MDC}] -to *
set_false_path -from [get_ports {RGMII1_RX_CTL}] -to *
set_false_path -from [get_ports {RGMII1_TX_CTL}] -to *
set_false_path -from [get_ports {RGMII1_RX_CLK}] -to *
set_false_path -from [get_ports {RGMII1_RXD1}] -to *
set_false_path -from [get_ports {RGMII1_RXD2}] -to *
set_false_path -from [get_ports {RGMII1_RXD3}] -to *
set_false_path -from [get_ports {RGMII1_RESETn}] -to *
set_false_path -from [get_ports {QSPI_DQ0}] -to *
set_false_path -from [get_ports {QSPI_DQ1}] -to *
set_false_path -from [get_ports {QSPI_DQ2}] -to *
set_false_path -from [get_ports {QSPI_DQ3}] -to *
set_false_path -from [get_ports {QSPI_SS0}] -to *
set_false_path -from [get_ports {QSPI_SS1}] -to *
set_false_path -from [get_ports {QSPI_CLK}] -to *
set_false_path -from [get_ports {SDMMC_CMD}] -to *
set_false_path -from [get_ports {SDMMC_D0}] -to *
set_false_path -from [get_ports {SDMMC_D1}] -to *
set_false_path -from [get_ports {SDMMC_CLK}] -to *
set_false_path -from [get_ports {SDMMC_D2}] -to *
set_false_path -from [get_ports {SDMMC_D3}] -to *
set_false_path -from [get_ports {USB1_ULPI_D0}] -to *
set_false_path -from [get_ports {USB1_ULPI_D1}] -to *
set_false_path -from [get_ports {USB1_ULPI_D2}] -to *
set_false_path -from [get_ports {USB1_ULPI_D3}] -to *
set_false_path -from [get_ports {USB1_ULPI_D4}] -to *
set_false_path -from [get_ports {USB1_ULPI_D5}] -to *
set_false_path -from [get_ports {USB1_ULPI_D6}] -to *
set_false_path -from [get_ports {USB1_ULPI_D7}] -to *
set_false_path -from [get_ports {USB1_ULPI_CLK}] -to *
set_false_path -from [get_ports {USB1_ULPI_STP}] -to *
set_false_path -from [get_ports {USB1_ULPI_DIR}] -to *
set_false_path -from [get_ports {USB1_ULPI_NXT}] -to *
set_false_path -from [get_ports {USB1_ULPI_CS}] -to *
set_false_path -from [get_ports {USB1_ULPI_RESET_N}] -to *
set_false_path -from [get_ports {B7A_UART0_RX}] -to *
set_false_path -from [get_ports {B7A_UART0_TX}] -to *
set_false_path -from [get_ports {B7A_I2C0_SDA}] -to *
set_false_path -from [get_ports {B7A_I2C0_SCL}] -to *
set_false_path -from [get_ports {B7A_CAN0_RX}] -to *
set_false_path -from [get_ports {B7A_CAN0_TX}] -to *
set_false_path -from [get_ports {B7A_CAN1_RX}] -to *
set_false_path -from [get_ports {B7A_CAN1_TX}] -to *
set_false_path -from [get_ports {I2C1_SCL}] -to *
set_false_path -from [get_ports {I2C1_SDA}] -to *
set_false_path -from [get_ports {LED1}] -to *
set_false_path -from [get_ports {LED2}] -to *
set_false_path -from [get_ports {LED3}] -to *
set_false_path -from [get_ports {SW1}] -to *
set_false_path -from [get_ports {SW2}] -to *
set_false_path -from [get_ports {SW3}] -to *

### set_false_path -from [get_ports {hps_emac1_MDIO}] -to *
### set_false_path -from [get_ports {hps_qspi_IO0}] -to *
### set_false_path -from [get_ports {hps_qspi_IO1}] -to *
### set_false_path -from [get_ports {hps_qspi_IO2}] -to *
### set_false_path -from [get_ports {hps_qspi_IO3}] -to *
### set_false_path -from [get_ports {hps_sdio_CMD}] -to *
### set_false_path -from [get_ports {hps_sdio_D0}] -to *
### set_false_path -from [get_ports {hps_sdio_D1}] -to *
### set_false_path -from [get_ports {hps_sdio_D2}] -to *
### set_false_path -from [get_ports {hps_sdio_D3}] -to *
### set_false_path -from [get_ports {hps_usb1_D0}] -to *
### set_false_path -from [get_ports {hps_usb1_D1}] -to *
### set_false_path -from [get_ports {hps_usb1_D2}] -to *
### set_false_path -from [get_ports {hps_usb1_D3}] -to *
### set_false_path -from [get_ports {hps_usb1_D4}] -to *
### set_false_path -from [get_ports {hps_usb1_D5}] -to *
### set_false_path -from [get_ports {hps_usb1_D6}] -to *
### set_false_path -from [get_ports {hps_usb1_D7}] -to *
### set_false_path -from [get_ports {hps_i2c0_SDA}] -to *
### set_false_path -from [get_ports {hps_i2c0_SCL}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO09}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO35}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO41}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO42}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO43}] -to *
### set_false_path -from [get_ports {hps_gpio_GPIO44}] -to *

### set_false_path -from [get_ports {hps_emac1_RX_CTL}] -to *
### set_false_path -from [get_ports {hps_emac1_RX_CLK}] -to *
### set_false_path -from [get_ports {hps_emac1_RXD0}] -to *
### set_false_path -from [get_ports {hps_emac1_RXD1}] -to *
### set_false_path -from [get_ports {hps_emac1_RXD2}] -to *
### set_false_path -from [get_ports {hps_emac1_RXD3}] -to *
### set_false_path -from [get_ports {hps_usb1_CLK}] -to *
### set_false_path -from [get_ports {hps_usb1_DIR}] -to *
### set_false_path -from [get_ports {hps_usb1_NXT}] -to *
### set_false_path -from [get_ports {hps_spim0_MISO}] -to *
### set_false_path -from [get_ports {hps_uart0_RX}] -to *
### set_false_path -from [get_ports {hps_can0_RX}] -to *

############################################################################
# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
create_clock -period "100MHz" -name {refclk_pci_express} {*refclk_*}
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

##############################################################################
# PHY IP reconfig controller constraints
# Set reconfig_xcvr clock
# this line will likely need to be modified to match the actual clock pin name
# used for this clock, and also changed to have the correct period set for the actually used clock
create_clock -period "125 MHz" -name {reconfig_xcvr_clk} {*reconfig_xcvr_clk*}

######################################################################
# HIP Soft reset controller SDC constraints
set_false_path -to   [get_registers *altpcie_rs_serdes|fifo_err_sync_r[0]]
set_false_path -from [get_registers *sv_xcvr_pipe_native*] -to [get_registers *altpcie_rs_serdes|*]

# HIP testin pins SDC constraints
set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]

# create fake clocks for SoC clock signals since it is not affecting router, please refer spec for its supported frequency
### create_clock -period 20  [get_ports hps_usb1_CLK]
### create_clock -period 100 [get_ports hps_i2c0_SCL]
create_clock -period 20  [get_ports USB1_ULPI_CLK]
create_clock -period 100 [get_ports B7A_I2C0_SCL]
create_clock -period 100 [get_ports I2C1_SCL]
create_clock -period 100 [get_ports I2C1_SDA]
create_clock -period 100 [get_ports SDMMC_CLK]
create_clock -period 100 [get_ports QSPI_CLK]

