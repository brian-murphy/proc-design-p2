module Project2_tb();


    reg  [9:0] SW;
    reg  [3:0] KEY;
    reg  CLOCK_50;
    reg  FPGA_RESET_N;
    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;

    Project2 p2(SW, KEY, CLOCK_50, FPGA_RESET_N, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

    initial begin

        FPGA_RESET_N = 1'b1;
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        FPGA_RESET_N = 1'b0;

        
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
        @(posedge CLOCK_50);
        $display("%h%h%h%h%h%h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

    end

    always #5 CLOCK_50 = ~CLOCK_50;

endmodule