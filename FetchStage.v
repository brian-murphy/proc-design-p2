`include "PcApparatus.vh"
`include "Decoder.vh"

module FetchStage #(
    parameter DBITS = 32,
    parameter START_PC = 64
) (
    input clk,
    input reset,
    input [DBITS - 1 : 0] iMemIn,
    input [DBITS - 1 : 0] execStageImm,
    input [DBITS - 1 : 0] execStageRs1,
    input execStageCmp,
    
    output [DBITS - 1 : 0] pc,
    output [DBITS - 1 : 0] instruction
);

    wire [3 : 0] opcode = iMemIn[27:24];

    wire [1 : 0] pcSel = 
        opcode == `ALUI || opcode == `ALUR || opcode == `CMPR || opcode == `CMPI ||
            opcode == `LOAD || opcode == `STORE ? `PCSEL_PCPLUSFOUR : 
        opcode == `BRANCH ? `PCSEL_PCOFFSET :
        opcode == `JAL ? `PCSEL_REGOFFSET : 
        2'bzz;

    wire isBranchOrJal = 
        opcode == `BRANCH || opcode == `JAL ? 1'b1 :
        opcode == `ALUI || opcode == `ALUR || opcode == `CMPR || opcode == `CMPI ||
            opcode == `LOAD || opcode == `STORE ? 1'b0 :
        1'bz;

    wire [1 : 0] counterOut;

    wire pcWrtEn = ~isBranchOrJal || counterOut == 2 ? 1'b1 : 1'b0;


    assign instruction = counterOut == 0 ? iMemIn : `NOOP;

    counter #(.SIZE(2), .MAX_VALUE(2)) branchWaitCounter(
        .clk    (clk),
        .reset  (reset),
        .enable (isBranchOrJal),
        .count  (counterOut)        
    );

    PcApparatus #(DBITS, START_PC) pcApparatus(
        clk,
        reset,
        pcWrtEn,
        execStageCmp,
        execStageImm,
        pcSel,
        execStageRs1,
        pc
    );

endmodule
