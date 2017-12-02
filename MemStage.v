module MemStage #(
    parameter DBITS = 32,
    parameter DMEMADDRBITS = 13,
    parameter DMEMWORDBITS = 2,
    parameter DMEMWORDS = 2048,
    parameter ADDR_KEY = 32'hF0000010,
    parameter ADDR_SW = 32'hF0000014,
    parameter ADDR_HEX = 32'hF0000000,
    parameter ADDR_LEDR = 32'hF0000004,
    parameter DEBOUNCER_COUNTER_SIZE = 8
) (
    input clk,
    input reset,
    input [DBITS - 1 : 0] addr,
    input [DBITS - 1 : 0] dataIn,
    input loadStore,
    input [DBITS - 1 : 0] pc,
    input [1 : 0] regfileInSel,
    input [9 : 0] SW,
    input [3 : 0] KEY,

    output [DBITS - 1 : 0] ioOut,
    output [DBITS - 1 : 0] memFwdValue,
    output [9 : 0] LEDR,
    output [6 : 0] HEX0,
    output [6 : 0] HEX1,
    output [6 : 0] HEX2,
    output [6 : 0] HEX3
);

    wire [DBITS - 1 : 0] uiIn;
    wire [DBITS - 1 : 0] dMemIn;
    wire [DBITS - 1 : 0] uiOut;
    wire uiWrtEn;
    wire [1 : 0] uiDevice;
    wire [DBITS - 1 : 0] dMemOut;
    wire [DMEMADDRBITS - DMEMWORDBITS - 1 : 0] dMemAddr;
    wire dMemWrtEn;



    RegfileInMux #(DBITS) fwdValueMux(
        .alu(addr),
        .pc(pc),
        .mem(ioOut),
        .regfileInSel(regfileInSel),
        .out(memFwdValue)
    );

    IoController #(
        DBITS,
        DMEMADDRBITS,
        DMEMWORDBITS,
        ADDR_KEY,
        ADDR_SW,
        ADDR_HEX,
        ADDR_LEDR
    ) ioController(
        addr,
        dataIn,
        loadStore,
        uiOut,
        dMemOut,
        uiIn,
        uiWrtEn,
        uiDevice,
        dMemIn,
        dMemAddr,
        dMemWrtEn,
        ioOut
    );

    DMemController #(DMEMADDRBITS, DMEMWORDBITS, DMEMWORDS, DBITS) dMemController (
        clk,
        reset,
        dMemWrtEn,
        dMemIn,
        dMemAddr,
        dMemOut
    );

    UiController #(DBITS, DEBOUNCER_COUNTER_SIZE) uiController(
        clk,
        reset,
        uiWrtEn,
        uiIn,
        uiDevice,
        KEY,
        SW,
        uiOut,
        LEDR,
        HEX0,
        HEX1,
        HEX2,
        HEX3
    );

endmodule
