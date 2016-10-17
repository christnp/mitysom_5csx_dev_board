/*
  Enhanced features off:

  Bytes     Access Type     Description
  -----     -----------     -----------
  0-3       R/Clr           Status(1)
  4-7       R/W             Control(2)
  8-12      R               Descriptor Fill Level(write fill level[15:0], read fill level[15:0])
  13-15     R               Response Fill Level[15:0]
  16-31     N/A             <Reserved>


  Enhanced features on:

  Bytes     Access Type     Description
  -----     -----------     -----------
  0-3       R/Clr           Status(1)
  4-7       R/W             Control(2)
  8-12      R               Descriptor Fill Level (write fill level[15:0], read fill level[15:0])
  13-15     R               Response Fill Level[15:0]
  16-20     R               Sequence Number (write sequence number[15:0], read sequence number[15:0])
  21-31     N/A             <Reserved>

  (1)  Writing a '1' to the interrupt bit of the status register clears the interrupt bit (when applicable), all other bits are unaffected by writes
  (2)  Writing to the software reset bit will clear the entire register (as well as all the registers for the entire SGDMA)

  Status Register:

  Bits      Description
  ----      -----------
  0         Busy
  1         Descriptor Buffer Empty
  2         Descriptor Buffer Full
  3         Response Buffer Empty
  4         Response Buffer Full
  5         Stop State
  6         Reset State
  7         Stopped on Error
  8         Stopped on Early Termination
  9         IRQ
  10-31     <Reserved>

  Control Register:

  Bits      Description
  ----      -----------
  0         Stop (will also be set if a stop on error/early termination condition occurs)
  1         Software Reset
  2         Stop on Error
  3         Stop on Early Termination
  4         Global Interrupt Enable Mask
  5         Stop dispatcher (stops the dispatcher from issuing more read/write commands)
  6-31      <Reserved>
*/

#ifndef SGDMA_DISPATCHER_REGS_H
#define SGDMA_DISPATCHER_REGS_H

#define CSR_STATUS_REG                          (0x0)
#define CSR_CONTROL_REG                         (0x4)
#define CSR_DESCRIPTOR_FILL_LEVEL_REG           (0x8)
#define CSR_RESPONSE_FILL_LEVEL_REG             (0xC)
#define CSR_SEQUENCE_NUMBER_REG                 (0x10)  // this register only exists when the enhanced features are enabled


// masks for the status register bits
#define CSR_BUSY_MASK                           (1)
#define CSR_BUSY_OFFSET                         (0)
#define CSR_DESCRIPTOR_BUFFER_EMPTY_MASK        (1<<1)
#define CSR_DESCRIPTOR_BUFFER_EMPTY_OFFSET      (1)
#define CSR_DESCRIPTOR_BUFFER_FULL_MASK         (1<<2)
#define CSR_DESCRIPTOR_BUFFER_FULL_OFFSET       (2)
#define CSR_RESPONSE_BUFFER_EMPTY_MASK          (1<<3)
#define CSR_RESPONSE_BUFFER_EMPTY_OFFSET        (3)
#define CSR_RESPONSE_BUFFER_FULL_MASK           (1<<4)
#define CSR_RESPONSE_BUFFER_FULL_OFFSET         (4)
#define CSR_STOP_STATE_MASK                     (1<<5)
#define CSR_STOP_STATE_OFFSET                   (5)
#define CSR_RESET_STATE_MASK                    (1<<6)
#define CSR_RESET_STATE_OFFSET                  (6)
#define CSR_STOPPED_ON_ERROR_MASK               (1<<7)
#define CSR_STOPPED_ON_ERROR_OFFSET             (7)
#define CSR_STOPPED_ON_EARLY_TERMINATION_MASK   (1<<8)
#define CSR_STOPPED_ON_EARLY_TERMINATION_OFFSET (8)
#define CSR_IRQ_SET_MASK                        (1<<9)
#define CSR_IRQ_SET_OFFSET                      (9)

// masks for the control register bits
#define CSR_STOP_MASK                           (1)
#define CSR_STOP_OFFSET                         (0)
#define CSR_RESET_MASK                          (1<<1)
#define CSR_RESET_OFFSET                        (1)
#define CSR_STOP_ON_ERROR_MASK                  (1<<2)
#define CSR_STOP_ON_ERROR_OFFSET                (2)
#define CSR_STOP_ON_EARLY_TERMINATION_MASK      (1<<3)
#define CSR_STOP_ON_EARLY_TERMINATION_OFFSET    (3)
#define CSR_GLOBAL_INTERRUPT_MASK               (1<<4)
#define CSR_GLOBAL_INTERRUPT_OFFSET             (4)
#define CSR_STOP_DESCRIPTORS_MASK               (1<<5)
#define CSR_STOP_DESCRIPTORS_OFFSET             (5)

// masks for the FIFO fill levels and sequence number
#define CSR_READ_FILL_LEVEL_MASK                (0xFFFF)
#define CSR_READ_FILL_LEVEL_OFFSET              (0)
#define CSR_WRITE_FILL_LEVEL_MASK               (0xFFFF0000)
#define CSR_WRITE_FILL_LEVEL_OFFSET             (16)
#define CSR_RESPONSE_FILL_LEVEL_MASK            (0xFFFF)
#define CSR_RESPONSE_FILL_LEVEL_OFFSET          (0)
#define CSR_READ_SEQUENCE_NUMBER_MASK           (0xFFFF)
#define CSR_READ_SEQUENCE_NUMBER_OFFSET         (0)
#define CSR_WRITE_SEQUENCE_NUMBER_MASK          (0xFFFF0000)
#define CSR_WRITE_SEQUENCE_NUMBER_OFFSET        (16)


// read/write macros for each 32 bit register of the CSR port
#if 0
#define WR_CSR_STATUS(base, data)              IOWR_32DIRECT(base, CSR_STATUS_REG, data)
#define WR_CSR_CONTROL(base, data)             IOWR_32DIRECT(base, CSR_CONTROL_REG, data)
#define RD_CSR_STATUS(base)                    IORD_32DIRECT(base, CSR_STATUS_REG)
#define RD_CSR_CONTROL(base)                   IORD_32DIRECT(base, CSR_CONTROL_REG)
#define RD_CSR_DESCRIPTOR_FILL_LEVEL(base)     IORD_32DIRECT(base, CSR_DESCRIPTOR_FILL_LEVEL_REG)
#define RD_CSR_RESPONSE_FILL_LEVEL(base)       IORD_32DIRECT(base, CSR_RESPONSE_FILL_LEVEL_REG)
#define RD_CSR_SEQUENCE_NUMBER(base)           IORD_32DIRECT(base, CSR_SEQUENCE_NUMBER_REG)
#endif

#define DESCRIPTOR_READ_ADDRESS_REG                      (0x0)
#define DESCRIPTOR_WRITE_ADDRESS_REG                     (0x4)
#define DESCRIPTOR_LENGTH_REG                            (0x8)
#define DESCRIPTOR_CONTROL_STANDARD_REG                  (0xC)
#define DESCRIPTOR_SEQUENCE_NUMBER_REG                   (0xC)
#define DESCRIPTOR_READ_BURST_REG                        (0xE)
#define DESCRIPTOR_WRITE_BURST_REG                       (0xF)
#define DESCRIPTOR_READ_STRIDE_REG                       (0x10)
#define DESCRIPTOR_WRITE_STRIDE_REG                      (0x12)
#define DESCRIPTOR_READ_ADDRESS_HIGH_REG                 (0x14)
#define DESCRIPTOR_WRITE_ADDRESS_HIGH_REG                (0x18)
#define DESCRIPTOR_CONTROL_ENHANCED_REG                  (0x1C)


// masks and offsets for the sequence number and programmable burst counts
#define DESCRIPTOR_SEQUENCE_NUMBER_MASK                  (0xFFFF)
#define DESCRIPTOR_SEQUENCE_NUMBER_OFFSET                (0)
#define DESCRIPTOR_READ_BURST_COUNT_MASK                 (0x00FF0000)
#define DESCRIPTOR_READ_BURST_COUNT_OFFSET               (16)
#define DESCRIPTOR_WRITE_BURST_COUNT_MASK                (0xFF000000)
#define DESCRIPTOR_WRITE_BURST_COUNT_OFFSET              (24)


// masks and offsets for the read and write strides
#define DESCRIPTOR_READ_STRIDE_MASK                      (0xFFFF)
#define DESCRIPTOR_READ_STRIDE_OFFSET                    (0)
#define DESCRIPTOR_WRITE_STRIDE_MASK                     (0xFFFF0000)
#define DESCRIPTOR_WRITE_STRIDE_OFFSET                   (16)


// masks and offsets for the bits in the descriptor control field
#define DESCRIPTOR_CONTROL_TRANSMIT_CHANNEL_MASK         (0xFF)
#define DESCRIPTOR_CONTROL_TRANSMIT_CHANNEL_OFFSET       (0)
#define DESCRIPTOR_CONTROL_GENERATE_SOP_MASK             (1<<8)
#define DESCRIPTOR_CONTROL_GENERATE_SOP_OFFSET           (8)
#define DESCRIPTOR_CONTROL_GENERATE_EOP_MASK             (1<<9)
#define DESCRIPTOR_CONTROL_GENERATE_EOP_OFFSET           (9)
#define DESCRIPTOR_CONTROL_PARK_READS_MASK               (1<<10)
#define DESCRIPTOR_CONTROL_PARK_READS_OFFSET             (10)
#define DESCRIPTOR_CONTROL_PARK_WRITES_MASK              (1<<11)
#define DESCRIPTOR_CONTROL_PARK_WRITES_OFFSET            (11)
#define DESCRIPTOR_CONTROL_END_ON_EOP_MASK               (1<<12)
#define DESCRIPTOR_CONTROL_END_ON_EOP_OFFSET             (12)
#define DESCRIPTOR_CONTROL_TRANSFER_COMPLETE_IRQ_MASK    (1<<14)
#define DESCRIPTOR_CONTROL_TRANSFER_COMPLETE_IRQ_OFFSET  (14)
#define DESCRIPTOR_CONTROL_EARLY_TERMINATION_IRQ_MASK    (1<<15)
#define DESCRIPTOR_CONTROL_EARLY_TERMINATION_IRQ_OFFSET  (15)
#define DESCRIPTOR_CONTROL_ERROR_IRQ_MASK                (0xFF<<16)  // the read master will use this as the transmit error, the dispatcher will use this to generate an interrupt if any of the error bits are asserted by the write master
#define DESCRIPTOR_CONTROL_ERROR_IRQ_OFFSET              (16)
#define DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_MASK        (1<<24)
#define DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_OFFSET      (24)
#define DESCRIPTOR_CONTROL_GO_MASK                       (1<<31)  // at a minimum you always have to write '1' to this bit as it commits the descriptor to the dispatcher
#define DESCRIPTOR_CONTROL_GO_OFFSET                     (31)


/* Each register is byte lane accessible so the some of the values that are
 * less than 32 bits wide are written to according to the field width.
 */
#if 0
#define WR_DESCRIPTOR_READ_ADDRESS(base, data)           IOWR_32DIRECT(base, DESCRIPTOR_READ_ADDRESS_REG, data)
#define WR_DESCRIPTOR_WRITE_ADDRESS(base, data)          IOWR_32DIRECT(base, DESCRIPTOR_WRITE_ADDRESS_REG, data)
#define WR_DESCRIPTOR_LENGTH(base, data)                 IOWR_32DIRECT(base, DESCRIPTOR_LENGTH_REG, data)
#define WR_DESCRIPTOR_CONTROL_STANDARD(base, data)       IOWR_32DIRECT(base, DESCRIPTOR_CONTROL_STANDARD_REG, data)   // this pushes the descriptor into the read/write FIFOs when standard descriptors are used
#define WR_DESCRIPTOR_SEQUENCE_NUMBER(base, data)        IOWR_16DIRECT(base, DESCRIPTOR_SEQUENCE_NUMBER_REG, data)
#define WR_DESCRIPTOR_READ_BURST(base, data)             IOWR_8DIRECT(base, DESCRIPTOR_READ_BURST_REG, data)
#define WR_DESCRIPTOR_WRITE_BURST(base, data)            IOWR_8DIRECT(base, DESCRIPTOR_WRITE_BURST_REG, data)
#define WR_DESCRIPTOR_READ_STRIDE(base, data)            IOWR_16DIRECT(base, DESCRIPTOR_READ_STRIDE_REG, data)
#define WR_DESCRIPTOR_WRITE_STRIDE(base, data)           IOWR_16DIRECT(base, DESCRIPTOR_WRITE_STRIDE_REG, data)
#define WR_DESCRIPTOR_READ_ADDRESS_HIGH(base, data)      IOWR_32DIRECT(base, DESCRIPTOR_READ_ADDRESS_HIGH_REG, data)
#define WR_DESCRIPTOR_WRITE_ADDRESS_HIGH(base, data)     IOWR_32DIRECT(base, DESCRIPTOR_WRITE_ADDRESS_HIGH_REG, data)
#define WR_DESCRIPTOR_CONTROL_ENHANCED(base, data)       IOWR_32DIRECT(base, DESCRIPTOR_CONTROL_ENHANCED_REG, data)   // this pushes the descriptor into the read/write FIFOs when the extended descriptors are used
#endif

#define RESPONSE_ACTUAL_BYTES_TRANSFERRED_REG    (0x0)
#define RESPONSE_ERRORS_REG                      (0x4)

// bits making up the "errors" register
#define RESPONSE_ERROR_MASK                      (0xFF)
#define RESPONSE_ERROR_OFFSET                    (0)
#define RESPONSE_EARLY_TERMINATION_MASK          (1<<8)
#define RESPONSE_EARLY_TERMINATION_OFFSET        (8)

typedef union
{
	struct
	{
		unsigned int tx_chan			: 8;
		unsigned int gen_sop    		: 1;
		unsigned int gen_eop   			: 1;
		unsigned int park_rd			: 1;	
		unsigned int park_wr			: 1;	
		unsigned int end_on_eop			: 1;	
		unsigned int reserved_1			: 1;	
		unsigned int tx_cmplte_mask		: 1;	
		unsigned int early_term_mask	: 1;	
		unsigned int tx_error_mask		: 8;	
		unsigned int early_done			: 1;	
		unsigned int reserved_2			: 6;	
		unsigned int go					: 1;	
	} msBits;
	unsigned int mnWord;
} tuSGDMADescCtrl;

struct tsSGDMADescriptor
{
	unsigned int read_addr;
	unsigned int write_addr;
	unsigned int length;
	tuSGDMADescCtrl control;
};

typedef union
{
	struct
	{
		unsigned int busy 			: 1;
		unsigned int desc_buf_empty	: 1;
		unsigned int desc_buf_full 	: 1;
		unsigned int desc_res_empty : 1;
		unsigned int desc_res_full 	: 1;
		unsigned int stopped 		: 1;
		unsigned int resetting 		: 1;
		unsigned int stop_on_err 	: 1;
		unsigned int stop_on_early 	: 1;
		unsigned int irq 			: 1;
		unsigned int reserved 		: 22;
	} msBits;
	unsigned int mnWord;
} tuSgdmaStatus;

typedef union
{
	struct
	{
		unsigned int stop_dispatcher 	: 1;
		unsigned int reset_dispatcher	: 1;
		unsigned int stop_on_err 		: 1;
		unsigned int stop_on_early 		: 1;
		unsigned int gl_int_en 			: 1;
		unsigned int stop_desc 			: 1;
		unsigned int reserved 			: 1;
	} msBits;
	unsigned int mnWord;
} tuSgdmaCtrl;

#endif /*SGDMA_DISPATCHER_REGS_H*/

