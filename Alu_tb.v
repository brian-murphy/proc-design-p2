`include "Alu.vh"

module Alu_tb();

    parameter WORD_SIZE = 32;

    reg [WORD_SIZE - 1 : 0] in1;
    reg [WORD_SIZE - 1 : 0] in2;
    reg [4 : 0] func;
    wire [WORD_SIZE - 1 : 0] out;

    Alu #(.WORD_SIZE(WORD_SIZE)) alu(in1, in2, func, out);


    initial begin

        in1 = 3;
        in2 = 5;
        func = `ADD;
        #2
        $display("3 + 5 = %d", out);

        func = `SUB;
        #2
        $display("3 - 5 = %d", out);

        func = `AND;
        #2
        $display("b11 & b101 = %b", out);

        func = `XOR;
        #2
        $display("b11 ^ b101 = %b", out);

        func = `NAND;
        #2
        $display("b11 NAND b101 = %b", out);

        func = `NOR;
        #2
        $display("b11 NOR b101 = %b", out);

        func = `XNOR;
        #2
        $display("b11 XNOR b101 = %b", out);

        func = `MVHI;
        #2
        $display("MVHI b11 = %b", out);

        func = `F;
        #2
        $display("F = %d", out);

        func = `EQ;
        #2
        $display("3 == 5 = %d", out);

        in2 = 3;
        #2
        $display("3 == 3 = %d", out);
    end

endmodule