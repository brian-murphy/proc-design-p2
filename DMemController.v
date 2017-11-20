module DMemController #(
    parameter DMEMADDRBITS = 13,
    parameter DMEMWORDBITS = 2,
    parameter DMEMWORDS = 2048,
    parameter DBITS = 8 << DMEMWORDBITS
) (
    input clk,
    input reset,
    input wrtEn,
    input [DBITS - 1 : 0] in,
    input [DMEMADDRBITS - DMEMWORDBITS - 1 : 0] addr,
    output reg [DBITS - 1 : 0] out
);

    reg [DBITS - 1 : 0] data [0 : DMEMWORDS - 1];

    always @ (negedge clk) begin

        if (reset == 1'b1) begin
        end else if (wrtEn == 1'b1) begin
            data[addr] <= in;
        end

        out <= data[addr];
    end
endmodule
