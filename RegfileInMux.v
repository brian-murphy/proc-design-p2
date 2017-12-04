`include "Decoder.vh"

module RegfileInMux #(
    parameter DBITS = 32
) (
    input [DBITS - 1 : 0] alu,
    input [DBITS - 1 : 0] pc,
    input [DBITS - 1 : 0] mem,
    input [1 : 0] regfileInSel,

    output [DBITS - 1 : 0] out
);

    assign out = regfileInSel == `REGFILEINSEL_ALUOUT ? alu :
                regfileInSel == `REGFILEINSEL_PCPLUS4 ? pc :
                regfileInSel == `REGFILEINSEL_IO ? mem : 
                {DBITS{1'bz}};

endmodule
