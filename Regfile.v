module Regfile #(
    parameter WORD_SIZE = 32,
    parameter INDEX_WIDTH = 4,
    parameter NUM_REGS = (1 << INDEX_WIDTH) - 1
) (
    input clk,
    input reset,
    input wrtEn,
    input [INDEX_WIDTH - 1 : 0] wrtRegno,
    input [WORD_SIZE - 1 : 0] dataIn,
    input [INDEX_WIDTH - 1 : 0] regno1,
    input [INDEX_WIDTH - 1 : 0] regno2,
    output [WORD_SIZE - 1 : 0] dataOut1,
    output [WORD_SIZE - 1 : 0] dataOut2
);


reg [WORD_SIZE - 1 : 0] data [0 : NUM_REGS];


assign dataOut1 = data[regno1];
assign dataOut2 = data[regno2];

integer i;
always @ (posedge clk) begin
    if (reset == 1'b1) begin
        for (i=0; i<NUM_REGS; i=i+1) begin
            data[i] <= 0;
        end
    end else if (wrtEn == 1'b1) begin
        data[wrtRegno] <= dataIn;
    end
end

endmodule
