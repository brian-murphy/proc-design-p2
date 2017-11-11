module Regfile_tb ();

parameter WORD_SIZE = 32;
parameter INDEX_WIDTH = 4;
parameter NUM_REGS = (1 << INDEX_WIDTH) - 1;


reg clk, reset, wrtEn;
reg [INDEX_WIDTH - 1 : 0] wrtRegno;
reg [WORD_SIZE - 1 : 0] dataIn;
reg [INDEX_WIDTH - 1 : 0] regno1;
reg [INDEX_WIDTH - 1 : 0] regno2;

wire [WORD_SIZE - 1 : 0] dataOut1;
wire [WORD_SIZE - 1 : 0] dataOut2;


Regfile #(
    .WORD_SIZE(WORD_SIZE),
    .INDEX_WIDTH(INDEX_WIDTH)
) regfile(clk, reset, wrtEn, wrtRegno, dataIn, regno1, regno2, dataOut1, dataOut2);


integer i;
initial begin

    clk = 0;
    reset = 1; 
    wrtEn = 0;
    regno1 = 0;
    regno2 = 0;
    @(posedge clk);
    reset = 0;

    for (i=0; i<NUM_REGS; i=i+1) begin
        regno1 = i;
        @(posedge clk);
        if (dataOut1 != 0)
            $display("regs should reset to zero");
    end


    wrtRegno = 1;
    wrtEn = 1'b1;
    dataIn = 8675309;
    regno1 = wrtRegno;
    @(posedge clk);
    #1
    if (dataOut1 != dataIn)
        $display("regfile should store results");
    else
        $display("successfully stored and retrieved data");


end

always #2 clk <= ~clk;

endmodule
