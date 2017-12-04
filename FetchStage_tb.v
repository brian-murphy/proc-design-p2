`include "Decoder.vh"

`define BEQ_f_R0_R0 32'hC0000f00
`define JAL_0_R0_R1 32'h01000001
`define SUB_R0_R0_R0 32'h2f000000

module FetchStage_tb();

    parameter DBITS = 32;
    parameter START_PC = 64;

    reg clk;
    reg reset;
    reg [DBITS - 1 : 0] execStageImm;
    reg [DBITS - 1 : 0] execStageRs1;
    reg execStageCmp;
    
    wire [DBITS - 1 : 0] pc;
    wire [DBITS - 1 : 0] instruction;

    reg [DBITS - 1 : 0] iMem [0 : 71];
    wire [DBITS - 1 : 0] iMemIn = iMem[pc];


    FetchStage #(DBITS, START_PC) fetchStage(
        clk,
        reset,
        iMemIn,
        execStageImm,
        execStageRs1,
        execStageCmp,
        pc,
        instruction
    );



    integer i;
    initial begin
        // Initialize instruction mem
        iMem[0] = `BEQ_f_R0_R0;
        for (i=4; i<START_PC; i=i+4) begin
            iMem[i] = `NOOP;
        end
        iMem[START_PC] = `SUB_R0_R0_R0;
        iMem[START_PC + 4] = `JAL_0_R0_R1;


        reset = 1'b1;
        execStageImm = 0;
        execStageCmp = 0;
        execStageRs1 = 0;
        clk = 0;
        @(posedge clk);

        reset = 1'b0;
        

        /* this should produce a waveform that loops: 0x40, 0x44, 0x0 forever
         * 0x0: Beq 0xf,R0,R0
         * ...
         * 0x40: SUB R0,R0,R0
         * 0x44: JAL 0(R0),R1
         */
        while (1'b1) begin
            execStageCmp = 1'b0;
            //sub in f
            @(posedge clk);
            //jal in f, sub in d
            @(posedge clk);
            //noop in f, jal in d, sub in e
            @(posedge clk);
            //noop in f and d, jal in e, sub in m
            execStageImm = 0;
            execStageRs1 = 0;
            @(posedge clk);
            //beq in f, noop in d and e, jal in m, sub in wb
            @(posedge clk);
            //noop in f, beq in d, noop in e and m, jal in wb
            @(posedge clk);
            //noop in f and d, beq in e, noop in m and wb
            execStageCmp = 1'b1;
            execStageImm = 15;
            @(posedge clk);
        end


    end

    always #10 clk = ~clk;

endmodule
