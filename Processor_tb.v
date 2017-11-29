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

    parameter PROGRAM_SIZE = 1000;


    reg [DBITS - 1 : 0] program [0 : PROGRAM_SIZE];

    assign instWord = program[pcOut];

    integer i,j;
    initial begin

        for (i=0; i<START_PC; i=i+1) begin
            program[i] = 0;
        end

        program[START_PC + 0] = 32'h2f000000;
        program[START_PC + 4] = 32'h3b00000f;
        program[START_PC + 8] = 32'h30002100;
        program[START_PC + 12] = 32'h3b00010f;
        program[START_PC + 16] = 32'h3bffff01;
        program[START_PC + 20] = 32'hd0001e00;
        program[START_PC + 24] = 32'hd0000101;
        program[START_PC + 28] = 32'hc0001c66;
        program[START_PC + 32] = 32'h3b00020f;
        program[START_PC + 36] = 32'h3bffff01;
        program[START_PC + 40] = 32'h20001910;
        program[START_PC + 44] = 32'h20000101;
        program[START_PC + 48] = 32'hc0001766;
        program[START_PC + 52] = 32'h20000100;
        program[START_PC + 56] = 32'hc0001566;
        program[START_PC + 60] = 32'h3b00030f;
        program[START_PC + 64] = 32'h3b000101;
        program[START_PC + 68] = 32'h80001201;
        program[START_PC + 72] = 32'h80000100;
        program[START_PC + 76] = 32'hc0001066;
        program[START_PC + 80] = 32'h3b00040f;
        program[START_PC + 84] = 32'h3bffff01;
        program[START_PC + 88] = 32'h90000d00;
        program[START_PC + 92] = 32'h90000101;
        program[START_PC + 96] = 32'hc0000b66;
        program[START_PC + 100] = 32'h3b00050f;
        program[START_PC + 104] = 32'h3b000101;
        program[START_PC + 108] = 32'h60000801;
        program[START_PC + 112] = 32'h60000100;
        program[START_PC + 116] = 32'hc0000666;
        program[START_PC + 120] = 32'h3bffff01;
        program[START_PC + 124] = 32'h60000101;
        program[START_PC + 128] = 32'hc0000366;
        program[START_PC + 132] = 32'h3b00060f;
        program[START_PC + 136] = 32'hf000061f;
        program[START_PC + 140] = 32'hc0000066;
        program[START_PC + 144] = 32'hfbf00001;
        program[START_PC + 148] = 32'h3b00e002;
        program[START_PC + 152] = 32'h6f0002f2;
        program[START_PC + 156] = 32'h8000021;
        program[START_PC + 160] = 32'hc0000466;
        program[START_PC + 164] = 32'hfbf00001;
        program[START_PC + 168] = 32'h3b000502;
        program[START_PC + 172] = 32'h8000021;
        program[START_PC + 176] = 32'hc0000066;
        program[START_PC + 180] = 32'hc0ffff00;

        FPGA_RESET_N = 1'b1;
        CLOCK_50 = 1'b0;

        SW = 10'b1111111111;
        KEY = 4'b1111;

        @(posedge CLOCK_50);
        @(posedge CLOCK_50);

        FPGA_RESET_N = 1'b0;
        while (1'b1 == 1'b1) begin
            for (j=0; j<258; j=j+1) begin
                @(posedge CLOCK_50);
            end
            SW = ~SW;
            KEY = ~KEY;
        end
        
    end

    always #10 CLOCK_50 = ~CLOCK_50;

endmodule
