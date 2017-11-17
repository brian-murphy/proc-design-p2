`timescale 1ns/1ps
module counter_tb();

    localparam COUNTER_SIZE = 4;

    reg clk;
    reg reset;
    reg enable;

    wire[COUNTER_SIZE - 1 : 0] counter_output;

    counter #(
        .SIZE(COUNTER_SIZE),
        .MAX_VALUE(10)) test_counter(clk, reset, enable, counter_output);

    integer i;

    initial begin

        clk = 0;
        enable = 1'b0;
        reset = 1'b1;
        @ (negedge clk);
        enable = 1'b1;
        reset = 1'b0;


        $display("**test counting to 3**");
        for (i=0; i<3; i=i+1) begin
            @ (negedge clk);
        end
        $display("expected: 3, actual: %d", counter_output);


        $display("**test reset**");
        reset = 1'b1;
        for (i=0; i<3; i=i+1) begin
            @ (negedge clk);
            $display("expected: 0, actual: %d", counter_output);
        end


        $display("**test disable**");
        enable = 1'b0;
        reset = 1'b0;
        for (i=0; i<3; i=i+1) begin
            @ (negedge clk);
            $display("expected: 0, actual: %d", counter_output);
        end


        $display("**test wraparound**");
        enable = 1'b1;
        for (i=0; i<11; i=i+1) begin
            @ (negedge clk);
        end
        $display("expected: 0, actual: %d", counter_output);
    end

    always #2 clk = ~clk;
endmodule