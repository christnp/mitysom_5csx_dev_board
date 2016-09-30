module top (
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
  
  	emac_mdio,
	emac_mdc,
	emac_tx_ctl,
	emac_tx_clk,
	emac_txd,
  	emac_rx_ctl,
	emac_rx_clk,
  	emac_rxd,
  	
	qspi_dq0         ,
	qspi_dq1         ,
	qspi_dq2         ,
	qspi_dq3         ,
	qspi_ss0         ,
	qspi_ss1         ,
	qspi_clk         ,

	usb1_ulpi_d0     ,
	usb1_ulpi_d1     ,
	usb1_ulpi_d2     ,
	usb1_ulpi_d3     ,
	usb1_ulpi_d4     ,
	usb1_ulpi_d5     ,
	usb1_ulpi_d6     ,
	usb1_ulpi_d7     ,
	usb1_ulpi_clk    ,
	usb1_ulpi_stp    ,
	usb1_ulpi_dir    ,
	usb1_ulpi_nxt    ,
	usb1_ulpi_cs     ,
	usb1_ulpi_reset_n,
	i2c0_sda     ,
	i2c0_scl     ,
	can0_rx      ,
	can0_tx      ,
	can1_rx      ,
	can1_tx      ,
	i2c1_scl         ,
	i2c1_sda         ,
	sw1              ,
	sw2              ,
	sw3              ,
  	sd_cmd,
  	sd_clk,
  	sd_d,
  	uart_rx,
  	uart_tx,
  	led,
  	rgmii1_resetn

);
  
  output wire [14:0] 	memory_mem_a;
  output wire [2:0] 	memory_mem_ba;
  output wire 		memory_mem_ck;
  output wire 		memory_mem_ck_n;
  output wire 		memory_mem_cke;
  output wire 		memory_mem_cs_n;
  output wire 		memory_mem_ras_n;
  output wire 		memory_mem_cas_n;
  output wire 		memory_mem_we_n;
  output wire 		memory_mem_reset_n;
  inout  wire [39:0] 	memory_mem_dq;
  inout  wire [4:0] 	memory_mem_dqs;
  inout  wire [4:0] 	memory_mem_dqs_n;
  output wire 		memory_mem_odt;
  output wire [4:0] 	memory_mem_dm;
  input  wire 		memory_oct_rzqin;

  inout  wire 		emac_mdio;
  output wire 		emac_mdc;
  output wire 		emac_tx_ctl;
  output wire 		emac_tx_clk;
  output wire [3:0] 	emac_txd;
  input  wire 		emac_rx_ctl;
  input  wire 		emac_rx_clk;
  input  wire [3:0] 	emac_rxd;
  inout wire		rgmii1_resetn;

  inout  wire 		sd_cmd;
  output wire 		sd_clk;
  inout  wire [3:0] 	sd_d;
  input  wire 		uart_rx;
  output wire 		uart_tx;
  inout  wire [2:0] 	led;
  inout  wire 		i2c0_scl;
  inout  wire 		i2c0_sda;
  inout  wire 		i2c1_scl;
  inout  wire 		i2c1_sda;
  
  inout wire 		qspi_dq0         ;
  inout wire 		qspi_dq1         ;
  inout wire 		qspi_dq2         ;
  inout wire 		qspi_dq3         ;
  output wire 		qspi_ss0         ;
  output wire 		qspi_ss1         ;
  output wire 		qspi_clk         ;
  inout wire 		usb1_ulpi_d0     ;
  inout wire 		usb1_ulpi_d1     ;
  inout wire 		usb1_ulpi_d2     ;
  inout wire 		usb1_ulpi_d3     ;
  inout wire 		usb1_ulpi_d4     ;
  inout wire 		usb1_ulpi_d5     ;
  inout wire 		usb1_ulpi_d6     ;
  inout wire 		usb1_ulpi_d7     ;
  inout wire 		usb1_ulpi_clk    ;
  output wire 		usb1_ulpi_stp    ;
  inout wire 		usb1_ulpi_dir    ;
  inout wire 		usb1_ulpi_nxt    ;
  inout wire 		usb1_ulpi_cs     ;
  inout wire 		usb1_ulpi_reset_n;
  input wire can0_rx;
  output wire can0_tx;
  input wire can1_rx;
  output wire can1_tx;
  inout wire sw1;
  inout wire sw2;
  inout wire sw3;

  wire	[29:0]	fpga_internal_led;
  wire		kernel_clk;

    system the_system (
        .kernel_clk_clk                      (kernel_clk),                      // kernel_clk.clk
	.memory_mem_a                        			(memory_mem_a),
	.memory_mem_ba                       			(memory_mem_ba),
	.memory_mem_ck                       			(memory_mem_ck),
	.memory_mem_ck_n                     			(memory_mem_ck_n),
	.memory_mem_cke                      			(memory_mem_cke),
	.memory_mem_cs_n                     			(memory_mem_cs_n),
	.memory_mem_ras_n                    			(memory_mem_ras_n),
	.memory_mem_cas_n                    			(memory_mem_cas_n),
	.memory_mem_we_n                     			(memory_mem_we_n),
	.memory_mem_reset_n                  			(memory_mem_reset_n),
	.memory_mem_dq                       			(memory_mem_dq),
	.memory_mem_dqs                      			(memory_mem_dqs),
	.memory_mem_dqs_n                    			(memory_mem_dqs_n),
	.memory_mem_odt                      			(memory_mem_odt),
	.memory_mem_dm                       			(memory_mem_dm),
	.memory_oct_rzqin                    			(memory_oct_rzqin),
    	.peripheral_hps_io_emac1_inst_MDIO   			(emac_mdio),
    	.peripheral_hps_io_emac1_inst_MDC    			(emac_mdc),
    	.peripheral_hps_io_emac1_inst_TX_CLK 			(emac_tx_clk),
    	.peripheral_hps_io_emac1_inst_TX_CTL 			(emac_tx_ctl),
    	.peripheral_hps_io_emac1_inst_TXD0   			(emac_txd[0]),
    	.peripheral_hps_io_emac1_inst_TXD1   			(emac_txd[1]),
    	.peripheral_hps_io_emac1_inst_TXD2   			(emac_txd[2]),
    	.peripheral_hps_io_emac1_inst_TXD3   			(emac_txd[3]),
    	.peripheral_hps_io_emac1_inst_RX_CLK 			(emac_rx_clk),
    	.peripheral_hps_io_emac1_inst_RX_CTL 			(emac_rx_ctl),
    	.peripheral_hps_io_emac1_inst_RXD0   			(emac_rxd[0]),
    	.peripheral_hps_io_emac1_inst_RXD1   			(emac_rxd[1]),
    	.peripheral_hps_io_emac1_inst_RXD2   			(emac_rxd[2]),
    	.peripheral_hps_io_emac1_inst_RXD3   			(emac_rxd[3]),
        .peripheral_hps_io_qspi_inst_SS1     (qspi_ss0),     //           .hps_io_qspi_inst_ss1
        .peripheral_hps_io_qspi_inst_IO0     (qspi_dq0),     //           .hps_io_qspi_inst_io0
        .peripheral_hps_io_qspi_inst_IO1     (qspi_dq1),     //           .hps_io_qspi_inst_io1
        .peripheral_hps_io_qspi_inst_IO2     (qspi_dq2),     //           .hps_io_qspi_inst_io2
        .peripheral_hps_io_qspi_inst_IO3     (qspi_dq3),     //           .hps_io_qspi_inst_io3
        .peripheral_hps_io_qspi_inst_SS0     (qspi_ss1),     //           .hps_io_qspi_inst_ss0
        .peripheral_hps_io_qspi_inst_CLK     (qspi_clk),     //           .hps_io_qspi_inst_clk
    	.peripheral_hps_io_sdio_inst_CMD     (sd_cmd),
    	.peripheral_hps_io_sdio_inst_CLK     (sd_clk),
    	.peripheral_hps_io_sdio_inst_D0      (sd_d[0]),
    	.peripheral_hps_io_sdio_inst_D1      (sd_d[1]),
    	.peripheral_hps_io_sdio_inst_D2      (sd_d[2]),
    	.peripheral_hps_io_sdio_inst_D3      (sd_d[3]),
    	.peripheral_hps_io_uart0_inst_RX     (uart_rx),
    	.peripheral_hps_io_uart0_inst_TX     (uart_tx),
	.peripheral_hps_io_i2c0_inst_SDA     (i2c0_sda),
	.peripheral_hps_io_i2c0_inst_SCL     (i2c0_scl),
        .peripheral_hps_io_usb1_inst_D0      (usb1_ulpi_d0),      //           .hps_io_usb1_inst_d0
        .peripheral_hps_io_usb1_inst_D1      (usb1_ulpi_d1),      //           .hps_io_usb1_inst_d1
        .peripheral_hps_io_usb1_inst_D2      (usb1_ulpi_d2),      //           .hps_io_usb1_inst_d2
        .peripheral_hps_io_usb1_inst_D3      (usb1_ulpi_d3),      //           .hps_io_usb1_inst_d3
        .peripheral_hps_io_usb1_inst_D4      (usb1_ulpi_d4),      //           .hps_io_usb1_inst_d4
        .peripheral_hps_io_usb1_inst_D5      (usb1_ulpi_d5),      //           .hps_io_usb1_inst_d5
        .peripheral_hps_io_usb1_inst_D6      (usb1_ulpi_d6),      //           .hps_io_usb1_inst_d6
        .peripheral_hps_io_usb1_inst_D7      (usb1_ulpi_d7),      //           .hps_io_usb1_inst_d7
        .peripheral_hps_io_usb1_inst_CLK     (usb1_ulpi_clk),     //           .hps_io_usb1_inst_clk
        .peripheral_hps_io_usb1_inst_STP     (usb1_ulpi_stp),     //           .hps_io_usb1_inst_stp
        .peripheral_hps_io_usb1_inst_DIR     (usb1_ulpi_dir),     //           .hps_io_usb1_inst_dir
        .peripheral_hps_io_usb1_inst_NXT     (usb1_ulpi_nxt),     //           .hps_io_usb1_inst_nxt
        .peripheral_hps_io_i2c1_inst_SDA     (i2c1_sda),     //           .hps_io_i2c1_inst_sda
        .peripheral_hps_io_i2c1_inst_SCL     (i2c1_scl),     //           .hps_io_i2c1_inst_scl
        .peripheral_hps_io_can0_inst_RX      (can0_rx),      //           .hps_io_can0_inst_rx
        .peripheral_hps_io_can0_inst_TX      (can0_tx),      //           .hps_io_can0_inst_tx
        .peripheral_hps_io_can1_inst_RX      (can1_rx),      //           .hps_io_can1_inst_rx
        .peripheral_hps_io_can1_inst_TX      (can1_tx),      //           .hps_io_can1_inst_tx
        .peripheral_hps_io_gpio_inst_GPIO00  (usb1_ulpi_cs),  //           .hps_io_gpio_inst_gpio00
        .peripheral_hps_io_gpio_inst_GPIO09  (usb1_ulpi_reset_n),  //           .hps_io_gpio_inst_gpio09
        .peripheral_hps_io_gpio_inst_GPIO28  (rgmii1_resetn),  //           .hps_io_gpio_inst_gpio28
        .peripheral_hps_io_gpio_inst_GPIO37  (sw1),  //           .hps_io_gpio_inst_gpio37
        .peripheral_hps_io_gpio_inst_GPIO40  (sw2),  //           .hps_io_gpio_inst_gpio40
        .peripheral_hps_io_gpio_inst_GPIO41  (sw3),  //           .hps_io_gpio_inst_gpio41
        .peripheral_hps_io_gpio_inst_GPIO48  (led[2]),  //           .hps_io_gpio_inst_gpio48
        .peripheral_hps_io_gpio_inst_GPIO49  (led[1]),  //           .hps_io_gpio_inst_gpio49
        .peripheral_hps_io_gpio_inst_GPIO50  (led[0])   //           .hps_io_gpio_inst_gpio50
    );

endmodule



