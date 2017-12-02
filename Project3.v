`define DEBUG

module Project3 #(
    parameter DBITS         				= 32,
    parameter INST_SIZE      			    = 32'd4,
    parameter INST_BIT_WIDTH				= 32,
    parameter START_PC       			    = 32'h40,
    parameter REG_INDEX_BIT_WIDTH 		    = 4,
    parameter ADDR_KEY  					= 32'hF0000010,
    parameter ADDR_SW   					= 32'hF0000014,
    parameter ADDR_HEX  					= 32'hF0000000,
    parameter ADDR_LEDR 					= 32'hF0000004,
    parameter ADDR_LEDG 					= 32'hF0000008,

    parameter IMEM_INIT_FILE				= "io.mif",
    parameter IMEM_ADDR_BIT_WIDTH 		    = 11,
    parameter IMEM_DATA_BIT_WIDTH 		    = INST_BIT_WIDTH,
    parameter IMEM_PC_BITS_HI     		    = IMEM_ADDR_BIT_WIDTH + 2,
    parameter IMEM_PC_BITS_LO     		    = 2,

    parameter DMEMADDRBITS 				    = 13,
    parameter DMEMWORDBITS				    = 2,
    parameter DMEMWORDS					    = 2048
) (
    input [9:0] SW,
    input [3:0] KEY,
    input CLOCK_50,
    input FPGA_RESET_N,
    input [DBITS - 1: 0] debugInstWord,

    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [DBITS - 1 : 0] pcOut
 );

    wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWord;
    wire clk, lock, reset;

    /**
     *   Set up debug or FPGA synthesizing configuration
     */
    `ifndef DEBUG
        InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (
            pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO],
            instWord
        );

        PLL	PLL_inst (.refclk (CLOCK_50), .rst(!FPGA_RESET_N), .outclk_0 (clk),.locked (lock));
        assign reset = ~lock;
    `endif

    `ifdef DEBUG
        assign clk = CLOCK_50;
        assign reset = FPGA_RESET_N;
        assign instWord = debugInstWord;
    `endif


 endmodule
