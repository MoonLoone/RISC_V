import tb_constants::*;

module RV32_tb;

logic clk = 0;
logic rst = 1;
logic[31:0] instr_addr;
logic[31:0] instr_data;
logic mem_we;
logic[31:0] mem_addr;
logic[31:0] mem_data_in;
logic[31:0] mem_data_out;
logic[MEMORY_SIZE:0][31:0] memory ;

endmodule
