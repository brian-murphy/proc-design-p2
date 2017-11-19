module Debouncer_tb();

reg clk, in, reset;
wire out;

Debouncer #(2) debouncer(clk, reset, in, out);

initial begin

    reset = 1'b1;
    
    clk = 1'b0;
    in = 1'b1;
    @(posedge clk);

    reset = 1'b0;
    in = 1'b0;
    @(posedge clk);
    in = 1'b1;   
    @(posedge clk);
    in = 1'b0;
    @(posedge clk);
    in = 1'b1;   
    @(posedge clk);
    in = 1'b0;
    @(posedge clk);
    in = 1'b1;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
end

always #1 clk = ~clk;

endmodule
