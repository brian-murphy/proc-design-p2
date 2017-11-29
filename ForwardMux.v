module ForwardMux #(
    parameter DBITS = 32,
    parameter REG_INDEX_BIT_WIDTH = 4
) (
    input [DBITS - 1 : 0] regData,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] regno,
    input [DBITS - 1 : 0] memData,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] memRd,
    input memWrtEn,
    input [DBITS - 1 : 0] wbData,
    input [REG_INDEX_BIT_WIDTH - 1 : 0] wbRd,
    input wbWrtEn,

    output [DBITS - 1 : 0] out
);

    wire memMatch = regno == memRd && memWrtEn == 1'b1 ? 1'b1 : 1'b0;
    wire wbMatch = regno == wbRd && wbWrtEn == 1'b1 ? 1'b1 : 1'b0;

    assign out = memMatch == 1'b1 ? memData :
                 wbMatch == 1'b1 ? wbData :
                 regData;

endmodule
