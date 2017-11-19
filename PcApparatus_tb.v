`include "PcApparatus.vh"

module PcApparatus_tb();

    parameter DBITS = 32;
    parameter START_PC = 64;

    reg clk, reset, cmp;
    reg [DBITS - 1 : 0] imm;
    reg [1 : 0] pcSel;
    reg [DBITS - 1 : 0] reg1;
    wire [DBITS - 1 : 0] pcOut;

    PcApparatus #(DBITS, START_PC) pcApparatus(clk, reset, imm, pcSel, cmp, reg1, pcOut);

    initial begin

        // test regular incrementing
        reset = 1'b1;
        clk = 1'b0;
        cmp = 1'b0;
        pcSel = `PCSEL_PCPLUSFOUR;
        @(posedge clk);

        reset = 1'b0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        @(negedge clk);
        $display("expected pc: 0x4C, actual: %h", pcOut);

        
        // test branching
        pcSel = `PCSEL_PCOFFSET;
        cmp = 1'b0;
        @(posedge clk);

        @(negedge clk);
        $display("expected pc: 0x50, actual: %h", pcOut);

        cmp = 1'b1;
        imm = 32'h4;
        @(posedge clk);
        @(negedge clk);
        $display("expected pc: 0x64, actual: %h", pcOut);


        // test JAL
        pcSel = `PCSEL_REGOFFSET;
        reg1 = 32'h50;
        @(posedge clk);
        @(negedge clk);
        $display("expected pc: 0x60, actual: %h", pcOut);
    end

    always #2 clk = ~clk;

endmodule
