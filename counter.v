`timescale 1ns/1ps
module counter #(
    parameter SIZE = 4,
    parameter MAX_VALUE = (1 << SIZE) - 1
)(
    input clk,
    input reset,
    input enable,
    output reg [SIZE - 1 : 0] count
);

    always @ (posedge clk) begin
        if (reset == 1'b1)
            count <= 0;
        else if (enable) begin
            if (count == MAX_VALUE)
                count <= 0;
            else
                count <= count + 1'b1;
        end
    end
endmodule
