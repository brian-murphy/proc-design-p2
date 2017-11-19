`include "IoController.vh"
`include "UiController.vh"

module IoController_tb();

    parameter DBITS = 32;
    parameter DMEM_ADDR_BITS = 13;
    parameter DMEMWORDBITS = 2;
    parameter ADDR_KEY = 32'hf0000010;
    parameter ADDR_SW = 32'hf0000014;
    parameter ADDR_HEX = 32'hf0000000;
    parameter ADDR_LEDR = 32'hf0000004;

    reg [DBITS - 1 : 0] addr;
    reg [DBITS - 1 : 0] dataIn;
    reg load_store;
    reg [DBITS - 1 : 0] uiIn;
    reg [DBITS - 1 : 0] dMemIn;

    wire [DBITS - 1 : 0] uiOut;
    wire uiWrtEn;
    wire [1 : 0] uiDevice;
    wire [DBITS - 1 : 0] dMemOut;
    wire [DMEM_ADDR_BITS - DMEMWORDBITS - 1 : 0] dMemAddr;
    wire dMemWrtEn;
    wire [DBITS - 1 : 0] dataOut;

    IoController ioController(
        addr,
        dataIn,
        load_store,
        uiIn,
        dMemIn,

        uiOut,
        uiWrtEn,
        uiDevice,
        dMemOut,
        dMemAddr,
        dMemWrtEn,
        dataOut
    );

    initial begin

        addr = 0;
        dataIn = 0;
        load_store = `IO_LOAD;
        uiIn = 0;
        dMemIn = 0;
        #2;

        addr = 16;
        dataIn = 2;
        load_store = `IO_STORE;
        #2;

        dMemIn = 2;
        load_store = `IO_LOAD;
        dataIn = 0;
        #2;

        addr = ADDR_HEX;
        dMemIn = 0;
        load_store = `IO_STORE;
        dataIn = 15;
        #2;

        addr = ADDR_LEDR;
        #2;

        addr = ADDR_KEY;
        dataIn = 0;
        load_store = `IO_LOAD;
        uiIn = 10;
        dMemIn = 2;
        #2;

        addr = ADDR_SW;
        uiIn = 1;
        dMemIn = 0;
        #2;

    end

endmodule
