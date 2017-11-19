module DMemController_tb ();


    parameter DMEMADDRBITS = 13;
    parameter DMEMWORDBITS = 2;
    parameter DMEMWORDS = 2048;
    parameter DBITS = 8 << DMEMWORDBITS;

    reg clk;
    reg reset;
    reg wrtEn;
    reg [DBITS - 1 : 0] in;
    reg [DMEMADDRBITS - DMEMWORDS - 1 : 0] addr;

    wire [DBITS - 1 : 0] out;

    DMemController #(
        DMEMADDRBITS,
        DMEMWORDBITS,
        DMEMWORDS
    ) dmem (
        clk,
        reset,
        wrtEn,
        in,
        addr,
        out
    );

    initial begin

        clk = 1'b1;
        reset = 1'b1;
        wrtEn = 1'b1;
        in = 32'hF;
        addr = 11'h0;
        @(posedge clk);
        @(negedge clk);
        #1;
        $display("should be random. actual: %h", out);
        reset = 1'b0;
        
        @(posedge clk);
        @(negedge clk);
        wrtEn = 1'b0;
        in = 32'h0;
        @(posedge clk);
        @(negedge clk);
        #1;
        $display("expected: 0xf, actual %h", out);
        @(negedge clk);
        #1;
        $display("expected: 0xf, actual %h", out);
    end

    always #3 clk = ~clk;
    
endmodule
