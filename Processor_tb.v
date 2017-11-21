`timescale 1ns/1ps

module Processor_tb();
  parameter DBITS         				 = 32;
  parameter INST_SIZE      			 = 32'd4;
  parameter INST_BIT_WIDTH				 = 32;
  parameter START_PC       			 = 32'h40;
  parameter REG_INDEX_BIT_WIDTH 		 = 4;
  parameter ADDR_KEY  					 = 32'hF0000010;
  parameter ADDR_SW   					 = 32'hF0000014;
  parameter ADDR_HEX  					 = 32'hF0000000;
  parameter ADDR_LEDR 					 = 32'hF0000004;
  parameter ADDR_LEDG 					 = 32'hF0000008;
  
  parameter IMEM_INIT_FILE				 = "countTo7.mif";
  parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
  parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
  parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
  parameter IMEM_PC_BITS_LO     		 = 2;
  
  parameter DMEMADDRBITS 				 = 13;
  parameter DMEMWORDBITS				 = 2;
  parameter DMEMWORDS					 = 2048;

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

    wire[DBITS-1 : 0] pcOut;
    wire[DBITS -1: 0] instWord;

    Project2 p2(
        SW,
        KEY,
        CLOCK_50,
        FPGA_RESET_N,
        LEDR,
        HEX0,
        HEX1,
        HEX2,
        HEX3,

        pcOut,
        instWord
    );

    parameter PROGRAM_SIZE = 100;


    reg [DBITS - 1 : 0] program [0 : PROGRAM_SIZE];

    assign instWord = program[pcOut];

    integer i;
    initial begin

        for (i=0; i<START_PC; i=i+1) begin
            program[i] = 0;
        end

        program[START_PC] = 32'h2f000000;
        program[START_PC + 4] = 32'hfbf00001;
        program[START_PC + 8] = 32'h9001412;
        program[START_PC + 12] = 32'h8000021;
        program[START_PC + 16] = 32'h9001012;
        program[START_PC + 20] = 32'h8000421;
        program[START_PC + 24] = 32'hc0fffb00;

        FPGA_RESET_N = 1'b1;
        CLOCK_50 = 1'b0;

        SW = 10'b1010101010;
        KEY = 4'b1010;


        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        FPGA_RESET_N = 1'b0;

        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        SW = 10'b1111000001;
        KEY = 4'b1111;
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        
    end

    always #20 CLOCK_50 = ~CLOCK_50;

endmodule
