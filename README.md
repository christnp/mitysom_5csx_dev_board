## Synopsis

This is a collection of examples for the MitySOM-5CSX Development Board. 

## Projects

### Base Project

The base project is the what is shipped on the SD card that comes with the development board. It utilizes Qsys in order to connect all function blocks together. The functions of the project are as follows:

* System ID, which can be accessed in linux by the **readysysid** example project located in the **software** folder
* Parallel I/O connected to the Full HSMC connector
* FPGA DDR controller, which is connected to the **HPS-to-FPGA AXI Bridge** so that the HPS can access the DDR that is attached to the FPGA. An example of accessing the FPGA DDR from linux can be found in *software/fpga_ddr_test*
* HPS DDR Test(BERT Test), which has a pattern generator and checker in the FPGA that is connected to the **SDRAM Bridge** so it can write and read from the HPS DDR
