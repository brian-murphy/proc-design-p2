`include "PcApparatus.vh"

module PcApparatus #(
    parameter DBITS = 32,
    parameter START_PC = 64
) (
    input clk,
    input reset,
    input cmp,
    input [DBITS - 1 : 0] imm,
    input [1 : 0] pcSel,
    input [DBITS - 1 : 0] reg1,
    output [DBITS - 1 : 0] pcOut
);

    wire [DBITS - 1 : 0] pcIn;

    assign pcIn = (pcSel == `PCSEL_PCPLUSFOUR) ? (pcOut + 4) : 
                  (pcSel == `PCSEL_PCOFFSET) ? (
                      (cmp == 1'b1) ? (pcOut + 4 + (imm << 2)) : (pcOut + 4)
                  ) : 
                  (pcSel == `PCSEL_REGOFFSET) ? (reg1 + (imm << 2)) : 
                  {DBITS{1'bz}};

    Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, 1'b1, pcIn, pcOut);


endmodule
