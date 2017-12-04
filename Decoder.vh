`ifndef _decoder_vh_
`define _decoder_vh_

`define ALUR    4'b1111
`define ALUI    4'b1011
`define LOAD    4'b1001
`define STORE   4'b1000
`define CMPR    4'b1110
`define CMPI    4'b1010
`define BRANCH  4'b0000
`define JAL     4'b0001

`define INSTR_ADD 4'b0011
`define INSTR_SUB 4'b0010
`define INSTR_AND 4'b0111
`define INSTR_OR 4'b0110
`define INSTR_XOR 4'b0101
`define INSTR_NAND 4'b1011
`define INSTR_NOR 4'b1010
`define INSTR_XNOR 4'b1001
`define INSTR_MVHI 4'b1111

`define INSTR_F 4'b0011
`define INSTR_EQ 4'b1100
`define INSTR_LT 4'b1101
`define INSTR_LTE 4'b0010
`define INSTR_T 4'b1111
`define INSTR_NE 4'b0000
`define INSTR_GTE 4'b0001
`define INSTR_GT 4'b1110

`define INSTR_BF 4'b0011
`define INSTR_BEQ 4'b1100
`define INSTR_BLT 4'b1101
`define INSTR_BLTE 4'b0010
`define INSTR_BEQZ 4'b1000
`define INSTR_BLTZ 4'b1001
`define INSTR_BLTEZ 4'b0110
`define INSTR_BT 4'b1111
`define INSTR_BNE 4'b0000
`define INSTR_BGTE 4'b0001
`define INSTR_BGT 4'b1110
`define INSTR_BNEZ 4'b0100
`define INSTR_BGTEZ 4'b0101
`define INSTR_BGTZ 4'b1010

`define ALUIN2SEL_REG 2'b00
`define ALUIN2SEL_IMM 2'b01
`define ALUIN2SEL_ZERO 2'b10

`define REGFILEINSEL_ALUOUT     2'b00
`define REGFILEINSEL_PCPLUS4    2'b01
`define REGFILEINSEL_IO         2'b10

`define NOOP 32'h3b000099

`endif