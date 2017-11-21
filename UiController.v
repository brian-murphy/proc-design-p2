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
    SevenSeg ss1(hexValue[3:0], I_HEX0);
    SevenSeg ss2(hexValue[7:4], I_HEX1);
    SevenSeg ss3(hexValue[11:8], I_HEX2);
    SevenSeg ss4(hexValue[15:12], I_HEX3);

    wire [9 : 0] switchValue;
    Debouncer #(8) switchDebouncers[9 : 0] (clk, reset, SWITCHES[9:0], switchValue);

    wire [3 : 0] keyValue;
    Debouncer #(8) keyDebouncers[3 : 0] (clk, reset, KEYS[3:0], keyValue);

    assign out = (uiDevice == `UI_KEY) ? {{DBITS-4{1'b0}}, keyValue} :
                 (uiDevice == `UI_SW) ? {{DBITS-10{1'b0}}, switchValue} :
                 (uiDevice == `UI_LEDR) ? {{DBITS-10{1'b0}}, ledValue} :
                 (uiDevice == `UI_HEX) ? {{DBITS-16{1'b0}}, hexValue} :
                 {DBITS{1'bz}};


    always @(negedge clk) begin
        if (reset == 1'b1) begin
            ledValue <= 0;
            hexValue <= 0;
        end else if (wrtEn == 1'b1) begin
            if (uiDevice == `UI_LEDR) begin
                ledValue <= in[9 : 0];
            end else if (uiDevice == `UI_HEX) begin
                hexValue <= in[15 : 0];
            end
        end
    end

endmodule