`timescale 1ns/1ps

`include "Alu.vh"
`include "Decoder.vh"

module ExecStage_tb();

    parameter DBITS = 32;
    parameter REG_INDEX_BIT_WIDTH = 4;

    reg [DBITS - 1 : 0] regfileOut1;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] regno1;
    reg [DBITS - 1 : 0] regfileOut2;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] regno2;
    reg [DBITS - 1 : 0] imm;
    reg [1 : 0] aluIn2Sel;
    reg [`FUNC_BITS - 1 : 0] aluFunc;
    reg [DBITS - 1 : 0] memFwdValue;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] memFwdRegno;
    reg memFwdWrtEn;
    reg [DBITS - 1 : 0] wbFwdValue;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] wbFwdRegno;
    reg wbFwdWrtEn;

    wire [DBITS - 1 : 0] aluResult;
    wire [DBITS - 1 : 0] resolvedRs1;
    wire [DBITS - 1 : 0] resolvedRs2;

    ExecStage #(DBITS, REG_INDEX_BIT_WIDTH) execStage(
        regfileOut1,
        regno1,
        regfileOut2,
        regno2,
        imm,
        aluIn2Sel,
        aluFunc,
        memFwdValue,
        memFwdRegno,
        memFwdWrtEn,
        wbFwdValue,
        wbFwdRegno,
        wbFwdWrtEn,
        aluResult,
        resolvedRs1,
        resolvedRs2
    );

    initial begin
      
        regfileOut1 = 3;
        regfileOut2 = 5;
        regno1 = 1;
        regno2 = 2;
        imm = 0;
        aluIn2Sel = `ALUIN2SEL_REG;
        aluFunc = `AND;
        memFwdValue = 9;
        memFwdRegno = 9;
        memFwdWrtEn = 1'b1;
        wbFwdValue = 2;
        wbFwdRegno = 9;
        wbFwdWrtEn = 1'b1;

        #1;
        $display("testing simple AND R1,R2: expected: 1, actual: %d", aluResult);

        memFwdRegno = 2;
        aluFunc = `OR;
        #1;
        $display("testing OR R1,R2 with forwarding: expected: 11, actual: %d", aluResult);
        $display("Expect RS2 forwarded 9. Acutal: %d", resolvedRs2);

        aluIn2Sel = `ALUIN2SEL_IMM;
        regfileOut1 = 0;
        imm = 3;
        aluFunc = `AND;
        memFwdRegno = 1;
        wbFwdRegno = 1;
        #1;
        $display("testing ANDI with two possibilities for forwarding: expected: 1, actual: %d", aluResult);
        $display("Expecting RS1 forwarded 9. Actual: %d", resolvedRs1);

        aluIn2Sel = `ALUIN2SEL_ZERO;
        aluFunc = `EQ;
        wbFwdWrtEn = 1'b0;
        memFwdWrtEn = 1'b0;
        #1;
        $display("testing BEQZ with no forwarding: expected: 1, actual: %d", aluResult);


    end

endmodule
