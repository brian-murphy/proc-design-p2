`include "Decoder.vh"
`include "Alu.vh"

module Decoder_tb();

reg [`WORD_SIZE - 1 : 0] instruction;

wire [`FUNC_BITS : 0] alu_func;
wire alu_in2_mux;
wire [3 : 0] regno1;
wire [3 : 0] regno2;
wire regfile_wrtEn;
wire [3 : 0] regfile_wrtRegno;

Decoder decoder(instruction, alu_func, alu_in2_mux, regno1, regno2, regfile_wrtEn, regfile_wrtRegno);

initial begin
    instruction = 32'b00111111000000000000001000011000;
    #2
    $display("ADD R2,R1,R8: alu_func=%d, alu_in2_mux=%d regno1=%d, regno2=%d, regfile_wrtEn=%d, regfile_wrtRegno=%d", alu_func, alu_in2_mux, regno1, regno2, regfile_wrtEn, regfile_wrtRegno);

    instruction = 32'b00111011000000000000000000011000;
    #2
    $display("ADDI R2,R1,R8: alu_func=%d, alu_in2_mux=%d regno1=%d, regno2=%d, regfile_wrtEn=%d, regfile_wrtRegno=%d", alu_func, alu_in2_mux, regno1, regno2, regfile_wrtEn, regfile_wrtRegno);

end

endmodule
