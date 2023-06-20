`timescale 1 ns/ 1 ns
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

logic[MEMORY_SIZE-1:0][31:0] memory = {
    'h04002083,    // lw   x1, 64(x0)
    'h07b08113,    // addi x2, x1, 123
    'h03310193,    // addi x3, x2, 51
    'h03f1f193,    // andi x3, x3, 63
    'h04302023,    // sw   x3, 64(x0)
    'h00000013,    // addi x0, x0, 0
    'h00000000,    // <<execution will end here, PC=25 (hex 18)>>
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000003,    // <<address 64 (hex 40) for data>>
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000,
    'h00000000
};

//device under test
RV32 entity(
.clk_i(clk), 
.rst_i(rst), 
.instr_data_i(instr_data), 
.mem_data_i(mem_data_in),
.instr_addr_o(instr_addr), 
.mem_we_o(mem_we),
.mem_addr_o(mem_addr), 
.mem_data_o(mem_data_out)
);

initial forever #(CLK_PERIOD/2) clk = ~clk;

initial begin
#(RST_PERIOD) rst = ~rst;
#10 rst = ~rst;
#10000 $stop;
end

initial begin
forever 
@(clk) begin
instruction_transaction(rst,instr_addr);
data_transaction(rst, mem_we, mem_addr, mem_data_out);
end
end

//Read and write data from memory bus
task data_transaction(
input rst,
input mem_we,
input [31:0] mem_addr,
input [31:0] mem_data_out
);
if (rst) begin
	if (mem_addr > MEMORY_SIZE*4) $strobe("Data address is to large or undefined!");
	else begin
		mem_data_in <= memory[mem_addr/4];
		if (mem_we) 
			memory[mem_addr/4] <= mem_data_out;
	end
end 
endtask

// Read instructions
task instruction_transaction(
input rst,
input [31:0] instr_addr
);
begin
	instr_data = memory[instr_addr];
	if (rst) begin
		if (instr_addr > MEMORY_SIZE*4) $strobe("Data address is to large or undefined!");
		else begin
			if (instr_addr == SIM_STOP_PC) begin 
				if (memory[MEM_CHECK_ADDR/4] == EXPECTED_RESULT)
					$strobe("Stopping simulation: correct result found!");
				else 
					$strobe("Stopping simulation: incorrect result, please fix your code and try again!");
				#(CLK_PERIOD*2) $stop;
			end
		end
	end
end
endtask

endmodule
