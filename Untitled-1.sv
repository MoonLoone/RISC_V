package RV_32_consts;
enum {OP_IMM = 7'b0010011, LOAD = 7'b0000011, STORE = 7'b0100011} opcode;
enum {ADDI = 3'b000, ANDI = 3'b111, LW = 3'b010, SW = 3'b010} funct3;
endpackage