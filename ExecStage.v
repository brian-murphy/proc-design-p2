`include "Alu.vh"
`include "Decoder.vh"

module ExecStage #(
    parameter DBITS = 32,
    parameter REG_INDEX_BIT_WIDTH = 4
) (
    input [DBITS - 1 : 0] regfileOut1,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] regno1,
    input [DBITS - 1 : 0] regfileOut2,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] regno2,
    input [DBITS - 1 : 0] imm,
    input [1 : 0] aluIn2Sel,
    input [`FUNC_BITS - 1 : 0] aluFunc,
    input [DBITS - 1 : 0] memFwdValue,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] memFwdRegno,
    input memFwdWrtEn,
    input [DBITS - 1 : 0] wbFwdValue,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] wbFwdRegno,
    input wbFwdWrtEn,

    output [DBITS - 1 : 0] aluResult,
    output [DBITS - 1 : 0] resolvedRs1,
    output [DBITS - 1 : 0] resolvedRs2
);


    wire [DBITS - 1 : 0] aluIn2 = aluIn2Sel == `ALUIN2SEL_REG ? resolvedRs2 :
                                aluIn2Sel == `ALUIN2SEL_IMM ? imm :
                                aluIn2Sel == `ALUIN2SEL_ZERO ? {DBITS{1'b0}} :
                                {DBITS{1'bz}};
    
    


    
    Alu #(DBITS) alu(resolvedRs1, aluIn2, aluFunc, aluResult);


    ForwardMux #(DBITS, REG_INDEX_BIT_WIDTH) rs1FwdMux(
        regfileOut1,
        regno1,
        memFwdValue,
        memFwdRegno,
        memFwdWrtEn,
        wbFwdValue,
        wbFwdRegno,
        wbFwdWrtEn,
        resolvedRs1
    );

    ForwardMux #(DBITS, REG_INDEX_BIT_WIDTH) rs2FwdMux(
        regfileOut2,
        regno2,
        memFwdValue,
        memFwdRegno,
        memFwdWrtEn,
        wbFwdValue,
        wbFwdRegno,
        wbFwdWrtEn,
        resolvedRs2
    );

endmodule
