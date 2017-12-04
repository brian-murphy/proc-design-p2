`include "Decoder.vh"

module MemStage_tb ();
    parameter DBITS = 32;
    parameter DMEMADDRBITS = 13;
    parameter DMEMWORDBITS = 2;
    parameter DMEMWORDS = 2048;
    parameter ADDR_KEY = 32'hF0000010;
    parameter ADDR_SW = 32'hF0000014;
    parameter ADDR_HEX = 32'hF0000000;
    parameter ADDR_LEDR = 32'hF0000004;
    parameter DEBOUNCER_COUNTER_SIZE = 1;

    reg clk;
    reg reset;
    reg [DBITS - 1 : 0] addr;
    reg [DBITS - 1 : 0] dataIn;
    reg loadStore;
    reg [DBITS - 1 : 0] pc;
    reg [1 : 0] regfileInSel;
    reg [9 : 0] SW;
    reg [3 : 0] KEY;

    wire [DBITS - 1 : 0] ioOut;
    wire [DBITS - 1 : 0] memFwdValue;
    wire [9 : 0] LEDR;
    wire [6 : 0] HEX0;
    wire [6 : 0] HEX1;
    wire [6 : 0] HEX2;
    wire [6 : 0] HEX3;


    MemStage #(
        DBITS,
        DMEMADDRBITS,
        DMEMWORDBITS,
        DMEMWORDS,
        ADDR_KEY,
        ADDR_SW,
        ADDR_HEX,
        ADDR_LEDR,
        DEBOUNCER_COUNTER_SIZE
    ) memStage (
        clk,
        reset,
        addr,
        dataIn,
        loadStore,
        pc,
        regfileInSel,
        SW,
        KEY,

        ioOut,
        memFwdValue,
        LEDR,
        HEX0,
        HEX1,
        HEX2,
        HEX3
    );

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        addr = 0;
        dataIn = 0;
        loadStore = 0;
        pc = 32'h40;
        regfileInSel = `REGFILEINSEL_ALUOUT;
        SW = 0;
        KEY = 0;
        
        @(posedge clk);
        reset = 1'b0;

        // test reading switches
        addr = ADDR_SW;
        regfileInSel = `REGFILEINSEL_IO;
        SW = {DBITS{1'b1}};
        @(posedge clk);
        @(posedge clk);
        #10;
        $display("Read switches: expected: 3ff, actual: %h", ioOut);
        $display("fwd value: expected: 3ff, actual: %h", memFwdValue);


        // test reading keys
        addr = ADDR_KEY;
        SW = 0;
        KEY = 4'b1010;
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("Read keys: expected: 1010, actual: %b", ioOut);

        
        // test writing LEDs
        addr = ADDR_LEDR;
        dataIn = 7;
        KEY = 0;
        loadStore = 1'b1;
        @(posedge clk);
        #1;
        $display("Write LEDs: expected: 111, actual: %b", LEDR);


        // test writing display
        addr = ADDR_HEX;
        dataIn = 32'h0000abcd;
        @(posedge clk);
        #1;
        $display("Write display: expected: irregular, actual: %h%h%h%h", HEX3, HEX2, HEX1, HEX0);


        // test writing mem and reading
        addr = 0;
        dataIn = 32'h1234abcd;
        @(posedge clk);

        dataIn = 0;
        loadStore = 0;
        @(posedge clk);
        #1;
        $display("read and write mem: expected: 1234abcd, actual: %h", ioOut);


        // test forwarding
        addr = 5;
        regfileInSel = `REGFILEINSEL_ALUOUT;
        #1;
        $display("forwarding alu value: expected: 5, actual: %d", memFwdValue);


        pc = 10;
        regfileInSel = `REGFILEINSEL_PCPLUS4;
        #1;
        $display("forwarding pc value: expected: 10, actual: %d", memFwdValue);
    end

    always #10 clk = ~clk;
endmodule
