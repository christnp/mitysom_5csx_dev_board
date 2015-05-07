# Setup Device
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSXFC6C6U23C7

# Setup Bank Voltages
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3A
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3B
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 4A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5B
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7A
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7C
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7D
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 8A

# Setup Pin Voltages
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDC
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDIO
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RESETn
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ1
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ2
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ3
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CMD
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CS
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D4
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D5
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D6
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D7
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_NXT
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_RESET_N
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW3
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_MISO
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_MOSI
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_SS0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED3
