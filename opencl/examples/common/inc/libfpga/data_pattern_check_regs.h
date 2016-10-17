/**
 * \file data_pattern_check_regs.h
 *
 * \brief register definitions for Altera Data Pattern Check core
 *
 * \copyright Critical Link LLC 2013-2014
 */
#define OFFSET_ENABLE		0
#define OFFSET_PATTERN_SEL	1
#define OFFSET_COUNTER_CTRL	2
#define OFFSET_NUM_BITS_LOW	3
#define OFFSET_NUM_BITS_HIGH	4
#define OFFSET_NUM_ERROR_LOW	5
#define OFFSET_NUM_ERROR_HIGH	6
#define OFFSET_CLOCK_SENSOR	7

#define REG_ENABLE_ENABLE	1
#define REG_ENABLE_LOCK_MASK	2

#define REG_PATTERN_SEL_PRBS7	1
#define REG_PATTERN_SEL_PRBS15	2
#define REG_PATTERN_SEL_PRBS23	4
#define REG_PATTERN_SEL_PRBS31	8
#define REG_PATTERN_SEL_HF	0x10
#define REG_PATTERN_SEL_LF	0x20

#define REG_COUNTER_CTRL_SNAP	1
#define REG_COUNTER_CTRL_CLEAR	2
#define REG_COUNTER_CTRL_VALID	0x100

