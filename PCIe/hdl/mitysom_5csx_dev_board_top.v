module mitysom_5csx_dev_board_top (
	// HPS memory controller ports
	output wire [14:0 ] HPS_DDR_A,
	output wire [2:0] HPS_DDR_BAS,
	output wire HPS_DDR_CK_P,
	output wire HPS_DDR_CK_N,
	output wire HPS_DDR_CKE,
	output wire HPS_DDR_CS0_N,
	output wire HPS_DDR_RAS_N,
	output wire HPS_DDR_CAS_N,
	output wire HPS_DDR_WE_N,
	output wire HPS_DDR_RESET_N,
	inout wire [39:0] HPS_DDR_D,
	inout wire [4:0] HPS_DDR_DQS_P,
	inout wire [4:0] HPS_DDR_DQS_N,
	output wire [4:0] HPS_DDR_DQM,
	input wire HPS_RZQ0,
	output wire HPS_ODT,
	// RGMII1                                                       
	output wire RGMII1_TX_CLK,
	output wire RGMII1_TXD0,
	output wire RGMII1_TXD1,
	output wire RGMII1_TXD2,
	output wire RGMII1_TXD3,
	input wire RGMII1_RXD0,
	inout wire RGMII1_MDIO,
	output wire RGMII1_MDC,
	input wire RGMII1_RX_CTL,
	output wire RGMII1_TX_CTL,
	input wire RGMII1_RX_CLK,
	input wire RGMII1_RXD1,
	input wire RGMII1_RXD2,
	input wire RGMII1_RXD3,
	inout wire RGMII1_RESET_N,
	// QSPI                                                         
	inout wire QSPI_DQ0,
	inout wire QSPI_DQ1,
	inout wire QSPI_DQ2,
	inout wire QSPI_DQ3,
	output wire QSPI_SS0,
	output wire QSPI_SS1,
	output wire QSPI_CLK,
	// SDMMC                                                        
	inout wire SDMMC_CMD,
	inout wire SDMMC_D0,
	inout wire SDMMC_D1,
	output wire SDMMC_CLK,
	inout wire SDMMC_D2,
	inout wire SDMMC_D3,
	// UART0                                                        
	input wire B7A_UART0_RX,
	output wire B7A_UART0_TX,
	// I2C0                                                         
	inout wire B7A_I2C0_SDA,
	inout wire B7A_I2C0_SCL,
	// I2C1                                                         
	inout wire I2C1_SCL,
	inout wire I2C1_SDA,

	// mSATA related
	input SSD_PRESENT, //TODO: Connect me to something! // Active high indication that mSATA card is plugged in?

	// PCIe signals
	input wire pcie_refclk_clk,                          
	inout wire pcie_npor_pin_perst,                      
	input wire pcie_hip_rx_in0,                   
	input wire pcie_hip_rx_in1,                   
	input wire pcie_hip_rx_in2,                   
	input wire pcie_hip_rx_in3,                   
	output wire pcie_hip_tx_out0,                  
	output wire pcie_hip_tx_out1,                  
	output wire pcie_hip_tx_out2,                  
	output wire pcie_hip_tx_out3
);

	// internal wires and registers declaration
	wire fpga_led_internal;
	wire hps_fpga_reset_n;
	wire pcie_npor_npor;
	wire [4:0] pipe_sim_ltssmstate;
	wire sync_pcie_por;
	wire sync_pcie_por_n;
	wire coreclk_fan_clk;
	wire coreclk_fan_reset_n;
	wire pcie_reconfig_clk_locked_fixedclk_locked;
	wire [2:0] hps_reset_req;
	wire hps_cold_reset;
	wire hps_warm_reset;
	wire hps_debug_reset;
	wire pcie_reset; 

	// connection of internal logics
	assign pcie_npor_pin_perst = pcie_reset ? ~pcie_reset : 1'bz;
	assign pcie_npor_npor = hps_fpga_reset_n & pcie_npor_pin_perst; // & fpga_rst_n;

	// SoC sub-system module
	mitysom_5csx_dev_board soc_inst (
		.memory_mem_a                                           (HPS_DDR_A), //hps_memory_mem_a),                               
		.memory_mem_ba                                          (HPS_DDR_BAS), //hps_memory_mem_ba),                         
		.memory_mem_ck                                          (HPS_DDR_CK_P), //hps_memory_mem_ck),                         
		.memory_mem_ck_n                                        (HPS_DDR_CK_N), //hps_memory_mem_ck_n),                       
		.memory_mem_cke                                         (HPS_DDR_CKE), //hps_memory_mem_cke),                        
		.memory_mem_cs_n                                        (HPS_DDR_CS0_N), //hps_memory_mem_cs_n),                       
		.memory_mem_ras_n                                       (HPS_DDR_RAS_N), //hps_memory_mem_ras_n),                      
		.memory_mem_cas_n                                       (HPS_DDR_CAS_N), //hps_memory_mem_cas_n),                      
		.memory_mem_we_n                                        (HPS_DDR_WE_N), //hps_memory_mem_we_n),                       
		.memory_mem_reset_n                                     (HPS_DDR_RESET_N), //hps_memory_mem_reset_n),                    
		.memory_mem_dq                                          (HPS_DDR_D), //hps_memory_mem_dq),                         
		.memory_mem_dqs                                         (HPS_DDR_DQS_P), //hps_memory_mem_dqs),                        
		.memory_mem_dqs_n                                       (HPS_DDR_DQS_N), //hps_memory_mem_dqs_n),                      
		.memory_mem_odt                                         (HPS_ODT), //hps_memory_mem_odt),                        
		.memory_mem_dm                                          (HPS_DDR_DQM), //hps_memory_mem_dm),                         
		.memory_oct_rzqin                                       (HPS_RZQ0), //hps_memory_oct_rzqin),                      
		.pio_led_external_connection_in_port                    (fpga_led_internal),
		.pio_led_external_connection_out_port                   (fpga_led_internal),                   
		.hps_0_hps_io_hps_io_emac1_inst_TX_CLK                  (RGMII1_TX_CLK),
		.hps_0_hps_io_hps_io_emac1_inst_TXD0                    (RGMII1_TXD0),
		.hps_0_hps_io_hps_io_emac1_inst_TXD1                    (RGMII1_TXD1),
		.hps_0_hps_io_hps_io_emac1_inst_TXD2                    (RGMII1_TXD2),
		.hps_0_hps_io_hps_io_emac1_inst_TXD3                    (RGMII1_TXD3),
		.hps_0_hps_io_hps_io_emac1_inst_RXD0                    (RGMII1_RXD0),
		.hps_0_hps_io_hps_io_emac1_inst_MDIO                    (RGMII1_MDIO),
		.hps_0_hps_io_hps_io_emac1_inst_MDC                     (RGMII1_MDC),
		.hps_0_hps_io_hps_io_emac1_inst_RX_CTL                  (RGMII1_RX_CTL),
		.hps_0_hps_io_hps_io_emac1_inst_TX_CTL                  (RGMII1_TX_CTL),
		.hps_0_hps_io_hps_io_emac1_inst_RX_CLK                  (RGMII1_RX_CLK),
		.hps_0_hps_io_hps_io_emac1_inst_RXD1                    (RGMII1_RXD1),
		.hps_0_hps_io_hps_io_emac1_inst_RXD2                    (RGMII1_RXD2),
		.hps_0_hps_io_hps_io_emac1_inst_RXD3                    (RGMII1_RXD3),
		.hps_0_hps_io_hps_io_qspi_inst_SS1                      (QSPI_SS1),
		.hps_0_hps_io_hps_io_qspi_inst_IO0                      (QSPI_DQ0),
		.hps_0_hps_io_hps_io_qspi_inst_IO1                      (QSPI_DQ1),
		.hps_0_hps_io_hps_io_qspi_inst_IO2                      (QSPI_DQ2),
		.hps_0_hps_io_hps_io_qspi_inst_IO3                      (QSPI_DQ3),
		.hps_0_hps_io_hps_io_qspi_inst_SS0                      (QSPI_SS0),
		.hps_0_hps_io_hps_io_qspi_inst_CLK                      (QSPI_CLK),
		.hps_0_hps_io_hps_io_sdio_inst_CMD                      (SDMMC_CMD),
		.hps_0_hps_io_hps_io_sdio_inst_D0                       (SDMMC_D0),
		.hps_0_hps_io_hps_io_sdio_inst_D1                       (SDMMC_D1),
		.hps_0_hps_io_hps_io_sdio_inst_CLK                      (SDMMC_CLK),
		.hps_0_hps_io_hps_io_sdio_inst_D2                       (SDMMC_D2),
		.hps_0_hps_io_hps_io_sdio_inst_D3                       (SDMMC_D3),
		.hps_0_hps_io_hps_io_uart0_inst_RX                      (B7A_UART0_RX),
		.hps_0_hps_io_hps_io_uart0_inst_TX                      (B7A_UART0_TX),
		.hps_0_hps_io_hps_io_i2c0_inst_SDA                      (B7A_I2C0_SDA),
		.hps_0_hps_io_hps_io_i2c0_inst_SCL                      (B7A_I2C0_SCL),
		.hps_0_hps_io_hps_io_i2c1_inst_SDA                      (I2C1_SCL),
		.hps_0_hps_io_hps_io_i2c1_inst_SCL                      (I2C1_SDA),
		.hps_0_hps_io_hps_io_gpio_inst_GPIO28                   (RGMII1_RESET_N),
		.pcie_cv_hip_avmm_0_refclk_clk                          (pcie_refclk_clk),
		.pcie_cv_hip_avmm_0_npor_npor                           (pcie_npor_npor),
		.pcie_cv_hip_avmm_0_npor_pin_perst                      (pcie_npor_pin_perst),
		.pcie_cv_hip_avmm_0_reconfig_clk_locked_fixedclk_locked (pcie_reconfig_clk_locked_fixedclk_locked),
		.pcie_cv_hip_avmm_0_hip_serial_rx_in0                   (pcie_hip_rx_in0),
		.pcie_cv_hip_avmm_0_hip_serial_rx_in1                   (pcie_hip_rx_in1),
		.pcie_cv_hip_avmm_0_hip_serial_rx_in2                   (pcie_hip_rx_in2),
		.pcie_cv_hip_avmm_0_hip_serial_rx_in3                   (pcie_hip_rx_in3),
		.pcie_cv_hip_avmm_0_hip_serial_tx_out0                  (pcie_hip_tx_out0),
		.pcie_cv_hip_avmm_0_hip_serial_tx_out1                  (pcie_hip_tx_out1),
		.pcie_cv_hip_avmm_0_hip_serial_tx_out2                  (pcie_hip_tx_out2),
		.pcie_cv_hip_avmm_0_hip_serial_tx_out3                  (pcie_hip_tx_out3),
		.pcie_cv_hip_avmm_0_hip_pipe_sim_pipe_pclk_in           (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_sim_ltssmstate             (pipe_sim_ltssmstate),
		.pcie_cv_hip_avmm_0_hip_pipe_phystatus0                 (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_phystatus1                 (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_phystatus2                 (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_phystatus3                 (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdata0                    (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdata1                    (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdata2                    (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdata3                    (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdatak0                   (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdatak1                   (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdatak2                   (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxdatak3                   (8'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxelecidle0                (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxelecidle1                (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxelecidle2                (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxelecidle3                (1'b0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxstatus0                  (3'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxstatus1                  (3'h0),
		.pcie_cv_hip_avmm_0_hip_pipe_rxstatus2                  (3'h0),  
		.pcie_cv_hip_avmm_0_hip_pipe_rxstatus3                  (3'h0),  
		.pcie_cv_hip_avmm_0_hip_pipe_rxvalid0                   (1'b0),  
		.pcie_cv_hip_avmm_0_hip_pipe_rxvalid1                   (1'b0),  
		.pcie_cv_hip_avmm_0_hip_pipe_rxvalid2                   (1'b0),  
		.pcie_cv_hip_avmm_0_hip_pipe_rxvalid3                   (1'b0),  
		.alt_xcvr_reconfig_0_reconfig_mgmt_address              (7'h0),  
		.alt_xcvr_reconfig_0_reconfig_mgmt_read                 (1'b0),  
		.alt_xcvr_reconfig_0_reconfig_mgmt_write                (1'b0),  
		.alt_xcvr_reconfig_0_reconfig_mgmt_writedata            (32'h0),  

		.coreclk_fan_clk_clk                                    (coreclk_fan_clk),
		.coreclk_fan_reset_reset_n                              (coreclk_fan_reset_n),
		.hps_0_h2f_reset_reset_n                                (hps_fpga_reset_n),
		.reset_1_reset_n(hps_fpga_reset_n),
		.pio_pcie_reset_export(pcie_reset),
		.hps_0_uart1_cts(1'b1),
		.hps_0_uart1_dsr(1'b1),
		.hps_0_uart1_dcd(1'b1),
		.hps_0_uart1_ri(1'b0),
		//.hps_0_uart1_dtr(),
		//.hps_0_uart1_rts(),
		//.hps_0_uart1_out1_n(),
		//.hps_0_uart1_out2_n(),
		.hps_0_uart1_rxd(GPS_UART_TX_2V5),
		.hps_0_uart1_txd(GPS_UART_RX_2V5)
		);  

endmodule
