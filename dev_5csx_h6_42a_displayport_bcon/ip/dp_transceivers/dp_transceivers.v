// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// *********************************************************************
//
// DisplayPort IP HW Demo
// 
// Description
//
// This is a simple HW demo which instantiates the altera_dp core and
// appropriate assisting IP including:
//   * Video PLL (altera_pll)
//   * XCVR PLL (altera_pll)
//   * XCVR reconfiguration IP
//   * Nios Link Master controller
//   * XCVR PHY IP (TX/RX)
// 
// *********************************************************************


// synthesis translate_off
`timescale 1ps / 1ps
// synthesis translate_on
`default_nettype none

module dp_transceivers # (
    parameter LANES = 4,
    parameter TX_SYMBOLS_PER_CLOCK = 2,
    parameter RX_SYMBOLS_PER_CLOCK = 2,
    parameter TX_POLINV = 0
)(
    // top-level clocks & reset
    input wire clk,
    input wire xcvr_pll_refclk,
    input wire resetn,

	output wire video_clk,
	output wire aux_clk,
    output wire clk50,
    output wire system_resetn,

    // XCVR pins
    output wire [LANES-1:0] tx_serial_data, 

    // Connections from DP core to the reconfig management FSM
    input wire [1:0] tx_link_rate,
    input wire [7:0] tx_link_rate_8bits,
    input wire tx_reconfig_req,
    output wire tx_reconfig_ack,
    output wire tx_reconfig_busy,
	
	input wire [LANES*10*TX_SYMBOLS_PER_CLOCK-1:0] tx_parallel_data,
	input wire tx_pll_powerdown,
	input wire [LANES-1:0] tx_analogreset,
	input wire [LANES-1:0] tx_digitalreset,
	output wire [LANES-1:0] tx_cal_busy,
	output wire [LANES-1:0] tx_std_clkout,
	output wire tx_pll_locked
);

    wire reset, system_resetn_;
    reg clk50_;
    reg [15:0] video_pll_locked_counter;

    // Aux pin connections
    wire tx_aux_in;
    wire tx_aux_out;
    wire tx_aux_oe;

    // outputs from the Video & XCVR PLLs
	wire video_pll_locked;
	wire clk162, clk270;
	wire [1:0] xcvr_refclk;
	wire xcvr_pll_locked;
	reg stable_pll_lock;
	wire xcvr_pll_locked_162;
	wire xcvr_pll_locked_270;

	wire [LANES-1:0] tx_pll_locked_;
	
    assign xcvr_pll_locked = xcvr_pll_locked_162 & xcvr_pll_locked_270;
    assign xcvr_refclk[0] = clk162;
    assign xcvr_refclk[1] = clk270;
	assign system_resetn = system_resetn_;


    // Connections from the reconfig management FSM to the XCVR reconfig IP
    wire mgmt_waitrequest;
    wire [6:0] mgmt_address;
    wire [31:0] mgmt_writedata;
    wire mgmt_write;
    wire reconfig_busy;

    // Connections from DP to the reconfig IP
    wire [559:0] reconfig_to_xcvr;
    wire [367:0] reconfig_from_xcvr;

    // Connections from the CVO to the DP TX
    wire tx_vid_v_sync;
    wire tx_vid_h_sync;
    wire tx_vid_datavalid;
    wire [23:0] tx_vid_data;

    // Connections between DP and PHY
//    wire [LANES*10*TX_SYMBOLS_PER_CLOCK-1:0] tx_parallel_data;
//    wire [LANES-1:0] tx_pll_powerdown;
//    wire [LANES-1:0] tx_analogreset;
//    wire [LANES-1:0] tx_digitalreset;
//    wire [LANES-1:0] tx_cal_busy;
//    wire [LANES-1:0] tx_std_clkout;
//    wire [LANES-1:0] tx_pll_locked;
	
    wire scl_ctl, sda_ctl;

	reg [3:0] aux_in_shift;
	reg [2:0] aux_cnt;
	reg aux_in;
   
    always @ (posedge clk)
	 begin
		clk50_ = ~clk50_;
	 end
	 assign clk50 = clk50_;
	 
    // Positive edge reset for the PLLs
    assign reset = !resetn;

    // Wait for 32K locks before releasing reset on the control system
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
            // Reset the locked counter on reset
            video_pll_locked_counter <= 16'h0000;
        else if (!video_pll_locked || !xcvr_pll_locked)
            // Reset the locked counter if we lost lock
            video_pll_locked_counter <= 16'h0000;
        else if (video_pll_locked_counter < 16'hffff)
            // Increment counter if not at maximum
            video_pll_locked_counter <= video_pll_locked_counter + 16'h0001;
    end
	
    // Clear reset when we've seen 32K good locks
    assign system_resetn_ = video_pll_locked_counter[15];

    // Check if we lose lock on either PLL after we release system reset
    always @ (posedge clk or negedge system_resetn_)
    begin
        if (!system_resetn_)
            // Reset the stable_pll_lock signal
            stable_pll_lock <= 1'b1;
        else if (!video_pll_locked || !xcvr_pll_locked)
            // If either PLL goes out of lock once the system reset is released, flag it
            stable_pll_lock <= 1'b0;
    end

    // Instantiate the Nios system containing the VIP datapath, DP source/sink and the TX link master
 //   cv_control u0 (
  //      .resetn_reset_n(system_resetn_),
   //     .clk_clk(clk),
        //.clk_vip_clk(video_clk),

        // AUX interfaces
        //.clk_aux_clk(aux_clk),
        //.dp_tx_aux_aux_in(aux_tx_in),
        //.dp_tx_aux_aux_out(aux_tx_out),
        //.dp_tx_aux_aux_oe(aux_tx_oe),
        //.dp_tx_aux_hpd(tx_hpd),
        //.oc_i2c_master_0_conduit_start_scl_pad_io(scl_ctl),
        //.oc_i2c_master_0_conduit_start_sda_pad_io(sda_ctl),

        // XCVR reconfiguration interfaces
        //.dp_xcvr_mgmt_clk_clk(clk),
        //.dp_tx_reconfig_link_rate(tx_link_rate),
        //.dp_tx_reconfig_reconfig_req(tx_reconfig_req),
        //.dp_tx_reconfig_reconfig_ack(tx_reconfig_ack),
        //.dp_tx_reconfig_reconfig_busy(tx_reconfig_busy),

        // Video out from CVO to TX source
//        .cvo_clocked_video_vid_clk(video_clk),
//        .cvo_clocked_video_vid_data(tx_vid_data),
//        .cvo_clocked_video_underflow(),                     // Unused
//        .cvo_clocked_video_vid_datavalid(tx_vid_datavalid),
//        .cvo_clocked_video_vid_v_sync(tx_vid_v_sync),
//        .cvo_clocked_video_vid_h_sync(tx_vid_h_sync),
//        .cvo_clocked_video_vid_f(),                         // Unused
//        .cvo_clocked_video_vid_h(),                         // Unused
//        .cvo_clocked_video_vid_v(),                         // Unused
//        .dp_tx_vid_clk_clk(video_clk),
//        .dp_tx_video_in_v_sync(tx_vid_v_sync),
//        .dp_tx_video_in_h_sync(tx_vid_h_sync),
//        .dp_tx_video_in_de(tx_vid_datavalid),
//        .dp_tx_video_in_data(tx_vid_data),

        // Connections between DP and PHY
//        .dp_tx_xcvr_interface_parallel_data(tx_parallel_data),
//        .dp_tx_xcvr_interface_pll_powerdown(tx_pll_powerdown),
//        .dp_tx_xcvr_interface_analogreset(tx_analogreset),
//        .dp_tx_xcvr_interface_digitalreset(tx_digitalreset),
//        .dp_tx_xcvr_interface_cal_busy(tx_cal_busy),
//        .dp_tx_xcvr_interface_std_clkout(tx_std_clkout),
//        .dp_tx_xcvr_interface_pll_locked(tx_pll_locked),
//		.dp_clk_cal_clk(clk50),
//    );

    localparam RECONFIG_TO_XCVR_RX_OFFSET   = LANES*70;
    localparam RECONFIG_FROM_XCVR_RX_OFFSET = LANES*46;
    
    // Instantiate the TX PHY IP   
    genvar i;
    generate begin    
        for (i = 0; i < LANES; i = i + 1) begin : TX_PHY_GEN
            cv_native_phy_tx u_tx_phy (
                .pll_powerdown(tx_pll_powerdown),
                .tx_analogreset(tx_analogreset[i]),
                .tx_digitalreset(tx_digitalreset[i]),
                .tx_pll_refclk(xcvr_refclk),  
                .tx_serial_data(tx_serial_data[i]), 
                .pll_locked(tx_pll_locked_[i]),
                .tx_std_coreclkin(tx_std_clkout[0]),	
                .tx_std_clkout(tx_std_clkout[i]),
                .tx_std_polinv((TX_POLINV==1)),
                .tx_cal_busy(tx_cal_busy[i]),
                .reconfig_to_xcvr({reconfig_to_xcvr[( (LANES*70)+(70*i) ) +: 70], reconfig_to_xcvr[(70*i) +: 70]}),
                .reconfig_from_xcvr({reconfig_from_xcvr[( (LANES*46)+(46*i) ) +: 46], reconfig_from_xcvr[(46*i) +: 46]}),
                .tx_parallel_data(tx_parallel_data[10*TX_SYMBOLS_PER_CLOCK*i +: 10*TX_SYMBOLS_PER_CLOCK]),
                .unused_tx_parallel_data()		
            );
        end
    end
    endgenerate

	assign tx_pll_locked = tx_pll_locked_[0];

    // Instantiate the PLLs
    cv_video_pll video_pll_inst (
        .refclk(clk),
        .rst(reset),    
        .outclk_0(video_clk),
        .outclk_1(aux_clk),
        .locked(video_pll_locked)
    );

    cv_pll_162 xcvr_pll_162_inst (
        .refclk(xcvr_pll_refclk),
        .rst(reset),    
        .outclk_0(clk162),
        .locked(xcvr_pll_locked_162)
    );
	
    cv_pll_270 xcvr_pll_270_inst (
        .refclk(xcvr_pll_refclk),
        .rst(reset),    
        .outclk_0(clk270),
        .locked(xcvr_pll_locked_270)
    );

    // Instantiate the reconfig management FSM
    reconfig_mgmt_hw_ctrl #(
        .DEVICE_FAMILY("Cyclone V"),
        .RX_LANES(0),
        .TX_LANES(LANES),
        .TX_PLLS(LANES)
    ) mgmt (
        .clk(clk),
        .reset(!system_resetn_),

        .tx_reconfig_req(tx_reconfig_req),
        .tx_link_rate(tx_link_rate),
        .tx_reconfig_ack(tx_reconfig_ack),
        .tx_reconfig_busy(tx_reconfig_busy),

        // Disable vod & emp for Bitec Rev 4+ daughter cards with re-drivers
        .tx_analog_reconfig_req(1'b0),
        .vod(8'b00000000),
        .emp(8'b00000000),	
        .tx_analog_reconfig_ack(),  // unused
        .tx_analog_reconfig_busy(), // unused

        .mgmt_address(mgmt_address),		
        .mgmt_writedata(mgmt_writedata),	
        .mgmt_write(mgmt_write),				
        .mgmt_waitrequest(mgmt_waitrequest),		
        .reconfig_busy(reconfig_busy)			
     );

     // Instantiate the XCVR reconfig IP
     cv_xcvr_reconfig reconfig (
        .reconfig_busy(reconfig_busy),            
        .mgmt_clk_clk(clk),              
        .mgmt_rst_reset(!system_resetn_),           
        .reconfig_mgmt_address(mgmt_address),
        .reconfig_mgmt_read(),  
        .reconfig_mgmt_readdata(),
        .reconfig_mgmt_waitrequest(mgmt_waitrequest),
        .reconfig_mgmt_write(mgmt_write),     
        .reconfig_mgmt_writedata(mgmt_writedata),  
        .reconfig_to_xcvr(reconfig_to_xcvr),         
        .reconfig_from_xcvr(reconfig_from_xcvr)        
     );
endmodule

`default_nettype wire
