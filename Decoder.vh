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

`define ALUIN2_REG 1'b0
`define ALUIN2_IMM 1'b1

`endif