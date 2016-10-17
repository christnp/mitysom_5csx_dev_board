
module system (
	kernel_clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	peripheral_hps_io_emac1_inst_TX_CLK,
	peripheral_hps_io_emac1_inst_TXD0,
	peripheral_hps_io_emac1_inst_TXD1,
	peripheral_hps_io_emac1_inst_TXD2,
	peripheral_hps_io_emac1_inst_TXD3,
	peripheral_hps_io_emac1_inst_RXD0,
	peripheral_hps_io_emac1_inst_MDIO,
	peripheral_hps_io_emac1_inst_MDC,
	peripheral_hps_io_emac1_inst_RX_CTL,
	peripheral_hps_io_emac1_inst_TX_CTL,
	peripheral_hps_io_emac1_inst_RX_CLK,
	peripheral_hps_io_emac1_inst_RXD1,
	peripheral_hps_io_emac1_inst_RXD2,
	peripheral_hps_io_emac1_inst_RXD3,
	peripheral_hps_io_qspi_inst_SS1,
	peripheral_hps_io_qspi_inst_IO0,
	peripheral_hps_io_qspi_inst_IO1,
	peripheral_hps_io_qspi_inst_IO2,
	peripheral_hps_io_qspi_inst_IO3,
	peripheral_hps_io_qspi_inst_SS0,
	peripheral_hps_io_qspi_inst_CLK,
	peripheral_hps_io_sdio_inst_CMD,
	peripheral_hps_io_sdio_inst_D0,
	peripheral_hps_io_sdio_inst_D1,
	peripheral_hps_io_sdio_inst_CLK,
	peripheral_hps_io_sdio_inst_D2,
	peripheral_hps_io_sdio_inst_D3,
	peripheral_hps_io_usb1_inst_D0,
	peripheral_hps_io_usb1_inst_D1,
	peripheral_hps_io_usb1_inst_D2,
	peripheral_hps_io_usb1_inst_D3,
	peripheral_hps_io_usb1_inst_D4,
	peripheral_hps_io_usb1_inst_D5,
	peripheral_hps_io_usb1_inst_D6,
	peripheral_hps_io_usb1_inst_D7,
	peripheral_hps_io_usb1_inst_CLK,
	peripheral_hps_io_usb1_inst_STP,
	peripheral_hps_io_usb1_inst_DIR,
	peripheral_hps_io_usb1_inst_NXT,
	peripheral_hps_io_uart0_inst_RX,
	peripheral_hps_io_uart0_inst_TX,
	peripheral_hps_io_i2c0_inst_SDA,
	peripheral_hps_io_i2c0_inst_SCL,
	peripheral_hps_io_i2c1_inst_SDA,
	peripheral_hps_io_i2c1_inst_SCL,
	peripheral_hps_io_can0_inst_RX,
	peripheral_hps_io_can0_inst_TX,
	peripheral_hps_io_can1_inst_RX,
	peripheral_hps_io_can1_inst_TX,
	peripheral_hps_io_gpio_inst_GPIO00,
	peripheral_hps_io_gpio_inst_GPIO09,
	peripheral_hps_io_gpio_inst_GPIO28,
	peripheral_hps_io_gpio_inst_GPIO37,
	peripheral_hps_io_gpio_inst_GPIO40,
	peripheral_hps_io_gpio_inst_GPIO41,
	peripheral_hps_io_gpio_inst_GPIO48,
	peripheral_hps_io_gpio_inst_GPIO49,
	peripheral_hps_io_gpio_inst_GPIO50);	

	output		kernel_clk_clk;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[39:0]	memory_mem_dq;
	inout	[4:0]	memory_mem_dqs;
	inout	[4:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[4:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output		peripheral_hps_io_emac1_inst_TX_CLK;
	output		peripheral_hps_io_emac1_inst_TXD0;
	output		peripheral_hps_io_emac1_inst_TXD1;
	output		peripheral_hps_io_emac1_inst_TXD2;
	output		peripheral_hps_io_emac1_inst_TXD3;
	input		peripheral_hps_io_emac1_inst_RXD0;
	inout		peripheral_hps_io_emac1_inst_MDIO;
	output		peripheral_hps_io_emac1_inst_MDC;
	input		peripheral_hps_io_emac1_inst_RX_CTL;
	output		peripheral_hps_io_emac1_inst_TX_CTL;
	input		peripheral_hps_io_emac1_inst_RX_CLK;
	input		peripheral_hps_io_emac1_inst_RXD1;
	input		peripheral_hps_io_emac1_inst_RXD2;
	input		peripheral_hps_io_emac1_inst_RXD3;
	output		peripheral_hps_io_qspi_inst_SS1;
	inout		peripheral_hps_io_qspi_inst_IO0;
	inout		peripheral_hps_io_qspi_inst_IO1;
	inout		peripheral_hps_io_qspi_inst_IO2;
	inout		peripheral_hps_io_qspi_inst_IO3;
	output		peripheral_hps_io_qspi_inst_SS0;
	output		peripheral_hps_io_qspi_inst_CLK;
	inout		peripheral_hps_io_sdio_inst_CMD;
	inout		peripheral_hps_io_sdio_inst_D0;
	inout		peripheral_hps_io_sdio_inst_D1;
	output		peripheral_hps_io_sdio_inst_CLK;
	inout		peripheral_hps_io_sdio_inst_D2;
	inout		peripheral_hps_io_sdio_inst_D3;
	inout		peripheral_hps_io_usb1_inst_D0;
	inout		peripheral_hps_io_usb1_inst_D1;
	inout		peripheral_hps_io_usb1_inst_D2;
	inout		peripheral_hps_io_usb1_inst_D3;
	inout		peripheral_hps_io_usb1_inst_D4;
	inout		peripheral_hps_io_usb1_inst_D5;
	inout		peripheral_hps_io_usb1_inst_D6;
	inout		peripheral_hps_io_usb1_inst_D7;
	input		peripheral_hps_io_usb1_inst_CLK;
	output		peripheral_hps_io_usb1_inst_STP;
	input		peripheral_hps_io_usb1_inst_DIR;
	input		peripheral_hps_io_usb1_inst_NXT;
	input		peripheral_hps_io_uart0_inst_RX;
	output		peripheral_hps_io_uart0_inst_TX;
	inout		peripheral_hps_io_i2c0_inst_SDA;
	inout		peripheral_hps_io_i2c0_inst_SCL;
	inout		peripheral_hps_io_i2c1_inst_SDA;
	inout		peripheral_hps_io_i2c1_inst_SCL;
	input		peripheral_hps_io_can0_inst_RX;
	output		peripheral_hps_io_can0_inst_TX;
	input		peripheral_hps_io_can1_inst_RX;
	output		peripheral_hps_io_can1_inst_TX;
	inout		peripheral_hps_io_gpio_inst_GPIO00;
	inout		peripheral_hps_io_gpio_inst_GPIO09;
	inout		peripheral_hps_io_gpio_inst_GPIO28;
	inout		peripheral_hps_io_gpio_inst_GPIO37;
	inout		peripheral_hps_io_gpio_inst_GPIO40;
	inout		peripheral_hps_io_gpio_inst_GPIO41;
	inout		peripheral_hps_io_gpio_inst_GPIO48;
	inout		peripheral_hps_io_gpio_inst_GPIO49;
	inout		peripheral_hps_io_gpio_inst_GPIO50;
endmodule
