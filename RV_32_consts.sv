package RV_32_consts;
localparam int REGISTERS_COUNT = 32;
enum logic[6:0] {OP_IMM = 7'b0010011, LOAD = 7'b0000011, STORE = 7'b0100011} opcode;
enum logic[2:0] {ADDI = 3'b000, ANDI = 3'b111, SLW = 3'b010} funct3;
endpackage