module Debouncer #(
    parameter COUNTER_BITS = 22
) (
    input clk,
    input reset,
    input in,
    output debounced
);

    reg stableState = 0;

    wire resetCounter = reset == 1'b1 || in == stableState ? 1'b1 : 1'b0;
    wire [COUNTER_BITS - 1 : 0] counterOut;

    assign debounced = stableState;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            stableState <= 1'b0;
        end else if (counterOut == (1 << COUNTER_BITS) - 1) begin
            stableState <= in;
        end
    end


    counter #(COUNTER_BITS) count(clk, resetCounter, 1'b1, counterOut);
endmodule
