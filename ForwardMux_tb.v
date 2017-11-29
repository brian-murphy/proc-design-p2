`timescale 1ns/1ps
module ForwardMux_tb();
    parameter DBITS = 32;
    parameter REG_INDEX_BIT_WIDTH = 4;

    reg [DBITS - 1 : 0] regData;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] regno;
    reg [DBITS - 1 : 0] memData;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] memRd;
    reg memWrtEn;
    reg [DBITS - 1 : 0] wbData;
    reg [REG_INDEX_BIT_WIDTH - 1 : 0] wbRd;
    reg wbWrtEn;

    wire [DBITS - 1 : 0] out;


    ForwardMux #(DBITS, REG_INDEX_BIT_WIDTH) forwardMux(
        regData,
        regno,
        memData,
        memRd,
        memWrtEn,
        wbData,
        wbRd,
        wbWrtEn,
        out
    );


    initial begin

        regData = 32'ha;
        memData = 32'hb;
        wbData = 32'hc;

        regno = 0;
        memRd = 0;
        wbRd = 0;

        memWrtEn = 1'b0;
        wbWrtEn = 1'b0;

        #1;
        $display("testing no wrtEn: expected: a, actual: %h", out);


        wbWrtEn = 1'b1;
        #1;
        $display("testing only wb wrtEn: expected: c, actual: %h", out);


        memWrtEn = 1'b1;
        #1;
        $display("testing mem precidence: expected b, actual: %h", out);


        memRd = 1;
        #1;
        $display("testing only wb match: expected: c, actual: %h", out);

        
        wbRd = 1;
        #1;
        $display("testing no regno matches: expected: a, actual: %h", out);
    end

endmodule