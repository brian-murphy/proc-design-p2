`include "UiController.vh"
`include "IoController.vh"

module IoController #(
    parameter DBITS = 32,
    parameter DMEMADDRBITS = 13,
    parameter DMEMWORDBITS = 2,
    parameter ADDR_KEY = 32'hf0000010,
    parameter ADDR_SW = 32'hf0000014,
    parameter ADDR_HEX = 32'hf0000000,
    parameter ADDR_LEDR = 32'hf0000004
) (
    input [DBITS - 1 : 0] addr,
    input [DBITS - 1 : 0] dataIn,
    input load_store,
    input [DBITS - 1 : 0] uiIn,
    input [DBITS - 1 : 0] dMemIn,

    output [DBITS - 1 : 0] uiOut,
    output uiWrtEn,
    output [1 : 0] uiDevice,
    output [DBITS - 1 : 0] dMemOut,
    output [DMEMADDRBITS - DMEMWORDBITS - 1 : 0] dMemAddr,
    output dMemWrtEn,
    output [DBITS - 1 : 0] dataOut
);

wire isUiAddr = addr == ADDR_HEX || addr == ADDR_LEDR || addr == ADDR_KEY || addr == ADDR_SW;

assign uiOut = dataIn;
assign uiWrtEn = isUiAddr == 1'b1 && load_store == `IO_STORE ? 1'b1 : 1'b0;
assign uiDevice = addr == ADDR_HEX ? `UI_HEX :
                  addr == ADDR_SW ? `UI_SW :
                  addr == ADDR_KEY ? `UI_KEY :
                  addr == ADDR_LEDR ? `UI_LEDR :
                  2'bzz;

assign dMemOut = dataIn;
assign dMemAddr = addr[DMEMADDRBITS - 1 : DMEMWORDBITS];
assign dMemWrtEn = isUiAddr == 1'b0 && load_store == `IO_STORE ? 1'b1 : 1'b0;

assign dataOut = isUiAddr ? uiIn :
                 addr < (1 << DMEMADDRBITS) ? dMemIn :
                {DBITS{1'bz}};

endmodule
