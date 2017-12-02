`include "Decoder.vh"
`include "Alu.vh"

// `define DEBUG

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

    parameter IMEM_INIT_FILE				= "integratedUi.mif",
    parameter IMEM_ADDR_BIT_WIDTH 		    = 11,
    parameter IMEM_DATA_BIT_WIDTH 		    = INST_BIT_WIDTH,
    parameter IMEM_PC_BITS_HI     		    = IMEM_ADDR_BIT_WIDTH + 2,
    parameter IMEM_PC_BITS_LO     		    = 2,

    parameter DMEMADDRBITS 				    = 13,
    parameter DMEMWORDBITS				    = 2,
    parameter DMEMWORDS					    = 2048,
    parameter DEBOUNCER_COUNTER_SIZE = 8
) (
    input [9:0] SW,
    input [3:0] KEY,
    input CLOCK_50,
    input FPGA_RESET_N,
`ifdef DEBUG
    input [DBITS - 1: 0] debugInstWord,
`endif

    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [DBITS - 1 : 0] pcOut
 );

    wire[IMEM_DATA_BIT_WIDTH - 1: 0] iMemOut;
    wire clk, lock, reset;

    wire [DBITS - 1 : 0] instWord;

    wire [DBITS - 1 : 0] dStageInstr;
    wire [DBITS - 1 : 0] dStagePc;

    wire [`FUNC_BITS - 1 : 0] dStageAluFunc;
    wire [1 : 0] dStageAluIn2Sel;
    wire [1 : 0] dStageRegfileInSel;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] dStageRegno1;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] dStageRegno2;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] dStageRd;
    wire [DBITS - 1 : 0] dStageImmOut;
    wire dStageRegfileWrtEn;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] dStageRefileWrtRegno;
    wire dStageIsStore;


    wire [DBITS - 1 : 0] eStageImm;
    wire [DBITS - 1 : 0] eStageResolvedRs1;
    wire [DBITS - 1 : 0] eStageResolvedRs2;
    wire [DBITS - 1 : 0] eStageAluResult;
    wire eStageCmp = eStageAluResult[0];
    wire [DBITS - 1 : 0] eStageRegfileOut1;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] eStageRegno1;
    wire [DBITS - 1 : 0] eStageRegfileOut2;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] eStageRegno2;
    wire [1 : 0] eStageAluIn2Sel;
    wire [`FUNC_BITS - 1 : 0] eStageAluFunc;
    wire eStageIsStore;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] eStageRd;
    wire [DBITS - 1 : 0] eStagePc;
    wire eStageRegfileWrtEn;
    wire [1 : 0] eStageRegfileInSel;


    wire [DBITS - 1 : 0] mStageFwdValue;
    wire [REG_INDEX_BIT_WIDTH - 1 : 0] mStageRd;
    wire mStageRegfileWrtEn;
    wire [DBITS - 1 : 0] mStageAddr;
    wire [DBITS - 1 : 0] mStageIoIn;
    wire mStageIsStore;
    wire [DBITS - 1 : 0] mStagePc;
    wire [1 : 0] mStageRegfileInSel;
    wire [DBITS - 1 : 0] mStageIoOut;


    wire [REG_INDEX_BIT_WIDTH - 1 : 0] wbStageRegfileWrtRegno;
    wire [DBITS - 1 : 0] wbStageRegfileIn;
    wire wbStageRegfileWrtEn;
    wire [DBITS - 1 : 0] wbStageAluOut;
    wire [DBITS - 1 : 0] wbStageIoOut;
    wire [DBITS - 1 : 0] wbStagePc;
    wire [1 : 0] wbStageRegfileInSel;

    wire [DBITS - 1 : 0] regfileOut1;
    wire [DBITS - 1 : 0] regfileOut2;


 




 
    // Fetch stage
    /**
     *   Set up debug or FPGA synthesizing configuration
     */
    `ifndef DEBUG
        InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (
            pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO],
            iMemOut
        );

        PLL	PLL_inst (.refclk (CLOCK_50), .rst(!FPGA_RESET_N), .outclk_0 (clk),.locked (lock));
        assign reset = ~lock;
    `endif

    `ifdef DEBUG
        assign clk = CLOCK_50;
        assign reset = FPGA_RESET_N;
        assign iMemOut = debugInstWord;
    `endif

    FetchStage #(DBITS, START_PC) fetchStage (
        clk,
        reset,
        iMemOut,
        eStageImm,
        eStageResolvedRs1,
        eStageCmp,
        pcOut,
        instWord
    );

    // Decode stage
    Register #(DBITS, `NOOP) dStageInstrReg (
        clk,
        reset,
        1'b1,
        instWord,
        dStageInstr
    );

    Register #(DBITS, {DBITS{1'b0}}) dStagePcReg (
        clk,
        reset,
        1'b1,
        pcOut,
        dStagePc
    );

    DecodeStage #(DBITS) decodeStage (
        dStageInstr,
        dStageAluFunc,
        dStageAluIn2Sel,
        dStageRegfileInSel,
        dStageRegno1,
        dStageRegno2,
        dStageRd,
        dStageImmOut,
        dStageRegfileWrtEn,
        dStageRefileWrtRegno,
        dStageIsStore
    );

    Regfile #(DBITS, REG_INDEX_BIT_WIDTH) regfile (
        clk,
        reset,
        wbStageRegfileWrtEn,
        wbStageRegfileWrtRegno,
        wbStageRegfileIn,
        dStageRegno1,
        dStageRegno2,
        regfileOut1,
        regfileOut2
    );


    // Exec stage
    Register #(DBITS, {DBITS{1'b0}}) eStageRegfileOut1Reg(
        clk, reset, 1'b1,
        regfileOut1,
        eStageRegfileOut1
    );

    Register #(REG_INDEX_BIT_WIDTH, {REG_INDEX_BIT_WIDTH{1'b0}}) eStageRegno1Reg(
        clk, reset, 1'b1,
        dStageRegno1,
        eStageRegno1
    );

    Register #(DBITS, {DBITS{1'b0}}) eStageRegfileOut2Reg(
        clk, reset, 1'b1,
        regfileOut2,
        eStageRegfileOut2
    );

    Register #(REG_INDEX_BIT_WIDTH, {REG_INDEX_BIT_WIDTH{1'b0}}) eStageRegno2Reg(
        clk, reset, 1'b1,
        dStageRegno2,
        eStageRegno2
    );

    Register #(DBITS, {DBITS{1'b0}}) eStageImmReg(
        clk, reset, 1'b1,
        dStageImmOut,
        eStageImm
    );

    Register #(2, 2'b0) eStageAluIn2SelReg(
        clk, reset, 1'b1,
        dStageAluIn2Sel,
        eStageAluIn2Sel
    );

    Register #(`FUNC_BITS, {`FUNC_BITS{1'b0}}) eStageAluFuncReg(
        clk, reset, 1'b1,
        dStageAluFunc,
        eStageAluFunc
    );

    Register #(1, 1'b0) eStageLoadStoreReg(
        clk, reset, 1'b1,
        dStageIsStore,
        eStageIsStore
    );

    Register #(REG_INDEX_BIT_WIDTH, {REG_INDEX_BIT_WIDTH{1'b0}}) eStageRdReg(
        clk, reset, 1'b1,
        dStageRd,
        eStageRd
    );

    Register #(DBITS, {DBITS{1'b0}}) eStagePcReg(
        clk, reset, 1'b1,
        dStagePc,
        eStagePc
    );

    Register #(1, 1'b0) eStageRegfileWrtEnReg(
        clk, reset, 1'b1,
        dStageRegfileWrtEn,
        eStageRegfileWrtEn
    );

    Register #(2, 2'b0) regfileInSel(
        clk, reset, 1'b1,
        dStageRegfileInSel,
        eStageRegfileInSel
    );

    ExecStage #(DBITS, REG_INDEX_BIT_WIDTH) execStage(
        eStageRegfileOut1,
        eStageRegno1,
        eStageRegfileOut2,
        eStageRegno2,
        eStageImm,
        eStageAluIn2Sel,
        eStageAluFunc,
        mStageFwdValue,
        mStageRd,
        mStageRegfileWrtEn,
        wbStageRegfileIn,
        wbStageRegfileWrtRegno,
        wbStageRegfileWrtEn,

        eStageAluResult,
        eStageResolvedRs1,
        eStageResolvedRs2
    );


    // mem stage

    Register #(DBITS, {DBITS{1'b0}}) mStageAddrReg(
        clk, reset, 1'b1,
        eStageAluResult,
        mStageAddr
    );

    Register #(DBITS, {DBITS{1'b0}}) mStageIoInReg(
        clk, reset, 1'b1,
        eStageResolvedRs2,
        mStageIoIn
    );

    Register #(1, 1'b0) mStageIsStoreReg(
        clk, reset, 1'b1,
        eStageIsStore,
        mStageIsStore
    );

    Register #(REG_INDEX_BIT_WIDTH, {REG_INDEX_BIT_WIDTH{1'b0}}) mStageRdReg(
        clk, reset, 1'b1,
        eStageRd,
        mStageRd
    );

    Register #(DBITS, {DBITS{1'b0}}) mStagePcReg(
        clk, reset, 1'b1,
        eStagePc,
        mStagePc
    );

    Register #(1, 1'b0) mStageRegfileWrtEnReg(
        clk, reset, 1'b1,
        eStageRegfileWrtEn,
        mStageRegfileWrtEn
    );

    Register #(2, 2'b0) mStageRegfileInSelReg(
        clk, reset, 1'b1,
        eStageRegfileInSel,
        mStageRegfileInSel
    );

    MemStage #(
        DBITS,
        DMEMADDRBITS,
        DMEMWORDBITS,
        DMEMWORDS,
        ADDR_KEY,
        ADDR_SW,
        ADDR_HEX,
        ADDR_LEDR,
        DEBOUNCER_COUNTER_SIZE
    ) memStage(
        clk,
        reset,
        mStageAddr,
        mStageIoIn,
        mStageIsStore,
        mStagePc,
        mStageRegfileInSel,
        SW,
        KEY,

        mStageIoOut,
        mStageFwdValue,
        LEDR,
        HEX0,
        HEX1,
        HEX2,
        HEX3
    );

    
    // wb stage

    Register #(DBITS, {DBITS{1'b0}}) wbStageAluOutReg(
        clk, reset, 1'b1,
        mStageAddr,
        wbStageAluOut
    );

    Register #(DBITS, {DBITS{1'b0}}) wbStageIoOutReg(
        clk, reset, 1'b1,
        mStageIoOut,
        wbStageIoOut
    );

    Register #(DBITS, {DBITS{1'b0}}) wbStagePcReg(
        clk, reset, 1'b1,
        mStagePc,
        wbStagePc
    );

    Register #(2, 2'b0) wbStageRegfileInSelReg(
        clk, reset, 1'b1,
        mStageRegfileInSel,
        wbStageRegfileInSel
    );

    Register #(REG_INDEX_BIT_WIDTH, {REG_INDEX_BIT_WIDTH{1'b0}}) wbStageWrtRegnoReg(
        clk, reset, 1'b1,
        mStageRd,
        wbStageRegfileWrtRegno
    );

    Register #(1, 1'b0) wbStageRegfileWrtEnReg(
        clk, reset, 1'b1,
        mStageRegfileWrtEn,
        wbStageRegfileWrtEn
    );

    RegfileInMux #(DBITS) regfileInMux(
        wbStageAluOut,
        wbStagePc + 4,
        wbStageIoOut,
        wbStageRegfileInSel,
        wbStageRegfileIn
    );
    

 endmodule
