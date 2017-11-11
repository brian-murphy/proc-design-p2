`include "Alu.vh"
`include "Decoder.vh"

module Decoder (
    input [`WORD_SIZE - 1 : 0] instruction,

    output [`FUNC_BITS : 0] alu_func,
    output alu_in2_mux,
    output [3 : 0] regno1,
    output [3 : 0] regno2,
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
) : 5'bzzzzz;

assign regno1 = rs1;
assign regno2 = rs2;
assign alu_in2_mux = opcode == `ALUR || opcode == `CMPR ? `ALUIN2_REG :
                    opcode == `ALUI || opcode == `CMPI ? `ALUIN2_IMM :
                    1'bz;
assign regfile_wrtEn = 1'b1; //TODO All current operations write; modify later
assign regfile_wrtRegno = rd;

endmodule
