`include "Alu.vh"
`include "Decoder.vh"

module Project2(
  input  [9:0] SW,
  input  [3:0] KEY,
  input  CLOCK_50,
  input  FPGA_RESET_N,
  output [9:0] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
 );
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
  
  parameter IMEM_INIT_FILE				 = "fib.mif";
  parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
  parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
  parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
  parameter IMEM_PC_BITS_LO     		 = 2;
  
  parameter DMEMADDRBITS 				 = 13;
  parameter DMEMWORDBITS				 = 2;
  parameter DMEMWORDS					 = 2048;
  
  parameter OP1_ALUR 					 = 4'b0000;
  parameter OP1_ALUI 					 = 4'b1000;
  parameter OP1_CMPR 					 = 4'b0010;
  parameter OP1_CMPI 					 = 4'b1010;
  parameter OP1_BCOND					 = 4'b0110;
  parameter OP1_SW   					 = 4'b0101;
  parameter OP1_LW   					 = 4'b1001;
  parameter OP1_JAL  					 = 4'b1011;
  
  // Add parameters for various secondary opcode values
  
  //PLL, clock generation, and reset generation
  wire clk, lock;
  //Pll pll(.inclk0(CLOCK_50), .c0(clk), .locked(lock));
  PLL	PLL_inst (.refclk (CLOCK_50), .rst(!FPGA_RESET_N), .outclk_0 (clk),.locked (lock));
  wire reset = ~lock;
  
  // Create PC and its logic
  wire pcWrtEn = 1'b1;
  wire[DBITS - 1: 0] pcOut;
  wire[DBITS - 1: 0] pcIn; // Implement the logic that generates pcIn; you may change pcIn to reg if necessary
  assign pcIn = pcOut + 4;
  // This PC instantiation is your starting point
  Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);

  // Creat instruction memeory
  wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWord;
  InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWord);
  
  // Put the code for getting opcode1, rd, rs, rt, imm, etc. here 
  wire [`FUNC_BITS - 1 : 0] alu_func;
  wire alu_in2_sel;
  wire [REG_INDEX_BIT_WIDTH - 1 : 0] regno1, regno2, regfile_wrtRegno;
  wire regfile_wrtEn;
  wire [DBITS - 1 : 0] imm;

  Decoder decoder(instWord, alu_func, alu_in2_sel, regno1, regno2, imm, regfile_wrtEn, regfile_wrtRegno);

  wire [DBITS - 1 : 0] aluOut;
  wire [DBITS - 1 : 0] regfileOut1, regfileOut2;

  Regfile #(
    .WORD_SIZE(DBITS),
    .INDEX_WIDTH(REG_INDEX_BIT_WIDTH)
  ) regfile (
    clk,
    reset,
    regfile_wrtRegno,
    aluOut,
    regno1,
    regno2,
    regfileOut1,
    regfileOut2
  );

  wire [DBITS - 1 : 0] aluIn2 = alu_in2_sel == `ALUIN2_REG ? regfileOut2 :
                                alu_in2_sel == `ALUIN2_IMM ? imm :
                                {DBITS{1'bz}};

  // Create ALU unit
  Alu alu(regfileOut1, aluIn2, alu_func, aluOut);
  // Put the code for data memory and I/O here
  
  // KEYS, SWITCHES, HEXS, and LEDS are memory mapped IO
    
endmodule

