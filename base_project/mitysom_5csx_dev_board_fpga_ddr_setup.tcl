# CLK2DDR
set_location_assignment PIN_Y13 -to CLK2DDR
	
# FPGA_DDR_A
set_location_assignment PIN_AA20 -to FPGA_DDR_A[0]
set_location_assignment PIN_W21 -to FPGA_DDR_A[1]
set_location_assignment PIN_AF26 -to FPGA_DDR_A[2]
set_location_assignment PIN_W20 -to FPGA_DDR_A[3]
set_location_assignment PIN_AA23 -to FPGA_DDR_A[4]
set_location_assignment PIN_AE25 -to FPGA_DDR_A[5]
set_location_assignment PIN_AD26 -to FPGA_DDR_A[6]
set_location_assignment PIN_Y24 -to FPGA_DDR_A[7]
set_location_assignment PIN_AA26 -to FPGA_DDR_A[8]
set_location_assignment PIN_W24 -to FPGA_DDR_A[9]
set_location_assignment PIN_V16 -to FPGA_DDR_A[10]
set_location_assignment PIN_AA24 -to FPGA_DDR_A[11]
set_location_assignment PIN_AC24 -to FPGA_DDR_A[12]
set_location_assignment PIN_AE26 -to FPGA_DDR_A[13]
set_location_assignment PIN_Y4 -to FPGA_DDR_A[14]
set_location_assignment PIN_W8 -to FPGA_DDR_A[15]

# FPGA_DDR_BAS
set_location_assignment PIN_Y19 -to FPGA_DDR_BAS[0]
set_location_assignment PIN_AB23 -to FPGA_DDR_BAS[1]
set_location_assignment PIN_Y18 -to FPGA_DDR_BAS[2]

# FPGA_DDR_CAS_N
set_location_assignment PIN_Y16 -to FPGA_DDR_CAS_N[0]

# FPGA_DDR_CKE
set_location_assignment PIN_AA4 -to FPGA_DDR_CKE[0]

# FPGA_DDR_CK_N
set_location_assignment PIN_AA11 -to FPGA_DDR_CK_N[0]

# FPGA_DDR_CK_P
set_location_assignment PIN_Y11 -to FPGA_DDR_CK_P[0]

# FPGA_DDR_DQM0
set_location_assignment PIN_AC4 -to FPGA_DDR_DQM0[0]

# FPGA_DDR_D
set_location_assignment PIN_Y8 -to FPGA_DDR_D[0] 
set_location_assignment PIN_Y5 -to FPGA_DDR_D[1]
set_location_assignment PIN_U10 -to FPGA_DDR_D[2]
set_location_assignment PIN_AB4 -to FPGA_DDR_D[3]
set_location_assignment PIN_AE6 -to FPGA_DDR_D[4]
set_location_assignment PIN_AD4 -to FPGA_DDR_D[5]
set_location_assignment PIN_V10 -to FPGA_DDR_D[6]
set_location_assignment PIN_AD5 -to FPGA_DDR_D[7]

# FPGA_DDR_DQS0_N
set_location_assignment PIN_T8 -to FPGA_DDR_DQS0_N[0]

## FPGA_DDR_DQS0_P
set_location_assignment PIN_U9 -to FPGA_DDR_DQS0_P[0]

# FPGA_DDR_RAS_N
set_location_assignment PIN_V15 -to FPGA_DDR_RAS_N[0]

# FPGA_DDR_RESET_N
set_location_assignment PIN_AB26 -to FPGA_DDR_RESET_N

# FPGA_DDR_WE_N
set_location_assignment PIN_Y17 -to FPGA_DDR_WE_N[0]

# RZQ_2
set_location_assignment PIN_AB25 -to RZQ_2

# FPGA_DDR_CS_N
set_location_assignment PIN_W15 -to FPGA_DDR_CS_N[0]

# Setup IO Voltages
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[3] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[3] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[3] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[4] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[4] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[4] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[5] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[5] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[5] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[6] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[6] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[6] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[7] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[7] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[7] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_DQS0_P[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_P[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_P[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_DQS0_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_CK_P[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CK_P[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_CK_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CK_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[10] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[10] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[11] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[11] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[12] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[12] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[13] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[13] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[14] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[14] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[3] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[3] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[4] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[4] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[5] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[5] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[6] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[6] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[7] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[7] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[8] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[8] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[9] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[9] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[1] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[2] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_WE_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_WE_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_RAS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_RAS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CAS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CAS_N[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CKE[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CKE[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_RESET_N -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_RESET_N -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_DQM0[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQM0[0] -tag __mitysom_5csx_dev_board_fpga_ddr_p0

