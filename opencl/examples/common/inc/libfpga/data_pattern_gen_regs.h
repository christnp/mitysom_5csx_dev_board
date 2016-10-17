/**
 * \file data_pattern_gen_regs.h
 *
 * \brief register defines for data pattern generator.
 *
 * \copyright Critical Link LLC 2013-2014
 *
 */
#define OFFSET_ENABLE		0
#define OFFSET_PATTERN_SEL	1
#define OFFSET_INJECT_ERR	2
#define OFFSET_PREAMBLE_CTRL	3
#define OFFSET_PREAMBLE_CH_LOW	4
#define OFFSET_PREAMBLE_CH_HIGH	5

#define REG_ENABLE_ENABLE	1

#define REG_PATTERN_SEL_PRBS7	1
#define REG_PATTERN_SEL_PRBS15	2
#define REG_PATTERN_SEL_PRBS23	4
#define REG_PATTERN_SEL_PRBS31	8
#define REG_PATTERN_SEL_HF	0x10
#define REG_PATTERN_SEL_LF	0x20

#define REG_INJECT_ERR		1

#define REG_PREAMBLE_CTRL_EN	1
#define REG_PREAMBLE_CTLR_NUM_BEATS_SHIFT	8
#define REG_PREAMBLE_CTLR_NUM_BEATS_MASK	0x0FF
