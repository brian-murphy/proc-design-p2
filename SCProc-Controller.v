`include "Alu.vh"
`include "Decoder.vh"
`include "PcApparatus.vh"

module Decoder (
    input [`WORD_SIZE - 1 : 0] instruction,

    output [`FUNC_BITS : 0] alu_func,
    output [1 : 0]pc_mux,
    output alu_in1_mux,
    output alu_in2_mux,
    output [1 : 0] regfile_in_mux,
    output [3 : 0] regno1,
    output [3 : 0] regno2,
    output [`WORD_SIZE - 1 : 0] immOut,
    output regfile_wrtEn,
    output [3 : 0] regfile_wrtRegno
);

wire [3 : 0] rd, rs1, rs2;
wire [15 : 0] imm;
wire [3 : 0] fn;
wire [3 : 0] opcode;

assign fn = instruction[31:28];
assign opcode = instruction[27:24];
assign imm = instruction[23:8];
assign rs2 = instruction[11:8];
assign rs1 = instruction[7:4];
assign rd = instruction[3:0];


assign alu_func = opcode == `ALUR || opcode == `ALUI ? (
    fn == `INSTR_ADD ? `ADD :
    fn == `INSTR_SUB ? `SUB :
    fn == `INSTR_AND ? `AND :
    fn == `INSTR_OR ? `OR :
    fn == `INSTR_XOR ? `XOR :
    fn == `INSTR_NAND ? `NAND :
    fn == `INSTR_NOR ? `NOR :
    fn == `INSTR_XNOR ? `XNOR :
    fn == `INSTR_MVHI ? `MVHI :
    5'bzzzzz
) : opcode == `CMPR || opcode == `CMPI ? (
    fn == `INSTR_F ? `F :
    fn == `INSTR_EQ ? `EQ :
    fn == `INSTR_LT ? `LT :
    fn == `INSTR_LTE ? `LTE :
    fn == `INSTR_T ? `T :
    fn == `INSTR_NE ? `NE :
    fn == `INSTR_GTE ? `GTE :
    fn == `INSTR_GT ? `GT :
    5'bzzzzz
) : opcode == `BRANCH ? (
    fn == `INSTR_BF ? `F :
    fn == `INSTR_BEQ ? `EQ :
    fn == `INSTR_BLT ? `LT :
    fn == `INSTR_BLTE ? `LTE :
    fn == `INSTR_BEQZ ? `EQ :
    fn == `INSTR_BLTZ ? `LT :
    fn == `INSTR_BLTEZ ? `LTE :
    fn == `INSTR_BT ? `T :
    fn == `INSTR_BNE ? `NE :
    fn == `INSTR_BGTE ? `GTE :
    fn == `INSTR_BGT ? `GT :
    fn == `INSTR_BNEZ ? `NE :
    fn == `INSTR_BGTEZ ? `GTE :
    fn == `INSTR_BGTZ ? `GT :
    5'bzzzzz
) : 5'bzzzzz;

assign pc_mux = 
    opcode == `ALUI || opcode == `ALUR || opcode == `CMPR || opcode == `CMPI ||
        opcode == `LOAD || opcode == `STORE ? `PCSEL_PCPLUSFOUR : 
    opcode == `BRANCH ? `PCSEL_PCOFFSET :
    opcode == `JAL ? `PCSEL_REGOFFSET : 
    2'bzz;

assign regno1 = rs1;
assign regno2 = rs2;

assign alu_in1_mux = 
opcode == `ALUR || opcode == `ALUI || opcode == `CMPR || opcode == `CMPI ? `ALUIN1SEL_REG : 
opcode == `BRANCH ? (
    fn == `INSTR_BF ? `ALUIN1SEL_REG :
    fn == `INSTR_BEQ ? `ALUIN1SEL_REG :
    fn == `INSTR_BLT ? `ALUIN1SEL_REG :
    fn == `INSTR_BLTE ? `ALUIN1SEL_REG :
    fn == `INSTR_BEQZ ? `ALUIN1SEL_ZERO :
    fn == `INSTR_BLTZ ? `ALUIN1SEL_ZERO :
    fn == `INSTR_BLTEZ ? `ALUIN1SEL_ZERO :
    fn == `INSTR_BT ? `ALUIN1SEL_REG :
    fn == `INSTR_BNE ? `ALUIN1SEL_REG :
    fn == `INSTR_BGTE ? `ALUIN1SEL_REG :
    fn == `INSTR_BGT ? `ALUIN1SEL_REG :
    fn == `INSTR_BNEZ ? `ALUIN1SEL_ZERO :
    fn == `INSTR_BGTEZ ? `ALUIN1SEL_ZERO :
    fn == `INSTR_BGTZ ? `ALUIN1SEL_ZERO :
    1'bz
) : 1'bz;

assign alu_in2_mux = opcode == `ALUR || opcode == `CMPR ? `ALUIN2SEL_REG :
                     opcode == `ALUI || opcode == `CMPI ? `ALUIN2SEL_IMM :
                     1'bz;

assign regfile_in_mux = opcode == `ALUR || opcode == `ALUI || opcode == `CMPR || opcode == `CMPI
                        ? `REGFILEINSEL_ALUOUT :
                        opcode == `JAL ? `REGFILEINSEL_PCPLUS4 : 
                        opcode == `LOAD ? `REGFILEINSEL_IO :
                        2'bzz;
assign regfile_wrtEn = opcode == `ALUR || opcode == `ALUI || opcode == `CMPR || opcode == `CMPI
                        ? 1'b1 : 1'bz;
assign regfile_wrtRegno = rd;

SignExtension #(.IN_BIT_WIDTH(16), .OUT_BIT_WIDTH(`WORD_SIZE)) immSext(imm, immOut);

endmodule
