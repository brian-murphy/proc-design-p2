`include "UiController.vh"

module UiController #(
    parameter DBITS = 32
) (
    input clk,
    input reset,
    input wrtEn,
    input [DBITS - 1 : 0] in,
    input [1 : 0] uiDevice,
    input [3 : 0] KEYS,
    input [9 : 0] SWITCHES,
    output [DBITS - 1 : 0] out,
    output [9 : 0] LED,
    output [6 : 0] I_HEX0,
    output [6 : 0] I_HEX1,
    output [6 : 0] I_HEX2,
    output [6 : 0] I_HEX3
);

    reg [9 : 0] ledValue;
    assign LED = ledValue;

    reg [15 : 0] hexValue;
    SevenSeg(hexValue[3:0], I_HEX0);
    SevenSeg(hexValue[7:4], I_HEX1);
    SevenSeg(hexValue[11:8], I_HEX2);
    SevenSeg(hexValue[15:12], I_HEX3);

    assign out = (uiDevice == `KEY) ? {{DBITS-4{1'b0}}, KEYS} :
                 (uiDevice == `SW) ? {{DBITS-10{1'b0}}, SWITCHES} :
                 (uiDevice == `LEDR) ? {{DBITS-10{1'b0}}, ledValue} :
                 (uiDevice == `HEX) ? {{DBITS-16{1'b0}}, hexValue} :
                 {DBITS{1'bz}};


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            ledValue <= 0;
            hexValue <= 0;
        end else if (wrtEn == 1'b1) begin
            if (uiDevice == `LEDR) begin
                ledValue <= in[9 : 0];
            end else if (uiDevice == `HEX) begin
                hexValue <= in[15 : 0];
            end
        end
    end

endmodule