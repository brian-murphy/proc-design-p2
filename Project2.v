`include "Alu.vh"
`include "Decoder.vh"
`include "PcApparatus.vh"

module Project2(
  input  [9:0] SW,
  input  [3:0] KEY,
  input  CLOCK_50,
  input  FPGA_RESET_N,
  output [9:0] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5,
  input [31:0] pcOut,
  output [31:0] instWord
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
  
  parameter IMEM_INIT_FILE				 = "countTo7.mif";
  parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
  parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
  parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
  parameter IMEM_PC_BITS_LO     		 = 2;
  
  parameter DMEMADDRBITS 				 = 13;
  parameter DMEMWORDBITS				 = 2;
  parameter DMEMWORDS					 = 2048;
  
  
  // Add parameters for various secondary opcode values
  
  //PLL, clock generation, and reset generation
  wire clk, reset;
  //Pll pll(.inclk0(CLOCK_50), .c0(clk), .locked(lock));
  // PLL	PLL_inst (.refclk (CLOCK_50), .rst(!FPGA_RESET_N), .outclk_0 (clk),.locked (lock));
  // wire reset = ~lock;

  assign reset = FPGA_RESET_N;


  // Debouncer #(18) (debugClk, reset, SW[9], clk);

  // assign LEDR[0] = clk;

  assign clk = CLOCK_50;


  wire [DBITS - 1 : 0] imm;
  wire [DBITS - 1 : 0] regfileOut1, regfileOut2;

  wire [DBITS - 1 : 0] aluOut;
  wire [DBITS - 1 : 0] ioOut;


  // Create PC and its logic
  // wire[DBITS - 1 : 0] pcOut;
  wire[1 : 0] pcSel;
  wire cmp;

  assign cmp = aluOut[0];

  PcApparatus #(DBITS, START_PC) pcApparatus(clk, reset, cmp, imm, pcSel, regfileOut1, pcOut);

  SevenSeg ss1(pcOut[3:0], HEX0);
  SevenSeg ss2(pcOut[7:4], HEX1);
  SevenSeg ss3(pcOut[11:8], HEX2);
  SevenSeg ss4(pcOut[15:12], HEX3);
  SevenSeg ss5(pcOut[19:16], HEX4);
  SevenSeg ss6(pcOut[23:20], HEX5);

  // Creat instruction memeory
  // wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWord;
  // InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWord);
  
  // Put the code for getting opcode1, rd, rs, rt, imm, etc. here 
  wire [`FUNC_BITS - 1 : 0] alu_func;
  wire alu_in1_sel;
  wire alu_in2_sel;
  wire [REG_INDEX_BIT_WIDTH - 1 : 0] regno1, regno2, regfile_wrtRegno;
  wire regfile_wrtEn;
  wire [DBITS - 1 : 0] regfile_dataIn;
  wire [1 : 0] regfileIn_sel;
  wire isStore;

  Decoder decoder(
    instWord, 
    alu_func,
    pcSel,
    alu_in1_sel,
    alu_in2_sel, 
    regfileIn_sel, 
    regno1, 
    regno2, 
    imm, 
    regfile_wrtEn, 
    regfile_wrtRegno,
    isStore
  );

  assign regfile_dataIn = regfileIn_sel == `REGFILEINSEL_ALUOUT ? aluOut :
                          regfileIn_sel == `REGFILEINSEL_PCPLUS4 ? pcOut + 4 :
                          regfileIn_sel == `REGFILEINSEL_IO ? ioOut : 
                          {DBITS{1'bz}};

  Regfile #(
    .WORD_SIZE(DBITS),
    .INDEX_WIDTH(REG_INDEX_BIT_WIDTH)
  ) regfile (
    clk,
    reset,
    regfile_wrtEn,
    regfile_wrtRegno,
    regfile_dataIn,
    regno1,
    regno2,
    regfileOut1,
    regfileOut2
  );
  
  // mux alu second input
  wire [DBITS - 1 : 0] aluIn2 = alu_in2_sel == `ALUIN2SEL_REG ? regfileOut2 :
                                alu_in2_sel == `ALUIN2SEL_IMM ? imm :
                                {DBITS{1'bz}};
  wire [DBITS - 1 : 0] aluIn1 = alu_in1_sel == `ALUIN1SEL_REG ? regfileOut1 :
                                alu_in2_sel == `ALUIN1SEL_ZERO ? {DBITS{1'b0}} :
                                {DBITS{1'bz}};

  // Create ALU unit
  Alu alu(aluIn1, aluIn2, alu_func, aluOut);

  // Put the code for data memory and I/O here
  
  // KEYS, SWITCHES, HEXS, and LEDS are memory mapped IO


  wire [DBITS - 1 : 0] ioAddr = imm + regfileOut1;
  wire [DBITS - 1 : 0] uiOut;
  wire [DBITS - 1 : 0] dMemOut;
  wire [DBITS - 1 : 0] uiIn;
  wire uiWrtEn;
  wire [1 : 0] uiDevice;
  wire [DBITS - 1 : 0] dMemIn;
  wire [10 : 0] dMemIndex;
  wire dMemWrtEn;

  IoController #(
    .DBITS(DBITS),
    .DMEMADDRBITS(DMEMADDRBITS),
    .DMEMWORDBITS(DMEMWORDBITS),
    .ADDR_KEY(ADDR_KEY),
    .ADDR_SW(ADDR_SW),
    .ADDR_HEX(ADDR_HEX),
    .ADDR_LEDR(ADDR_LEDR)
  ) ioController(
    ioAddr,
    regfileOut2,
    isStore,
    uiOut,
    dMemOut,

    uiIn,
    uiWrtEn,
    uiDevice,
    dMemIn,
    dMemIndex,
    dMemWrtEn,
    ioOut
  );

  wire [9:0]NOT_SW;
  wire [9:0]NOT_LEDR;
  wire [6:0]NOT_HEX0;
  wire [6:0]NOT_HEX1;
  wire [6:0]NOT_HEX2;
  wire [6:0]NOT_HEX3;
  wire [3:0]NOT_KEY;
  
  UiController #(DBITS) uiController(
    clk,
    reset,
    uiWrtEn,
    uiIn,
    uiDevice,
    NOT_KEY, /////////////////////// TODO Fix!
    NOT_SW,

    uiOut,
    NOT_LEDR,
    NOT_HEX0,
    NOT_HEX1,
    NOT_HEX2,
    NOT_HEX3
  );

  DMemController #(
    .DMEMADDRBITS(DMEMADDRBITS),
    .DMEMWORDBITS(DMEMWORDBITS),
    .DMEMWORDS(DMEMWORDS),
    .DBITS(DBITS)
  ) dMemController (
    clk,
    reset,
    dMemWrtEn,
    dMemIn,
    dMemIndex,
    dMemOut
  );

endmodule
