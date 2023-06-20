import RV_32_consts::*;
import tb_constants::MEMORY_SIZE;

module RV32(
input logic clk_i, 
input logic rst_i, //Active-high reset
input logic[31:0] instr_data_i, //instruction address
input logic[31:0] mem_data_i, //read memmory data
output logic[31:0] instr_addr_o, //instruction address
output logic mem_we_o, //Active-high memmory write
output logic[31:0] mem_addr_o, //read memory address
output logic[31:0] mem_data_o //write memory data
);

logic [MEMORY_SIZE/2-1:0] cmd_cnt; //command counter
logic[31:0] x[31:0]; //registers

always_ff@(posedge clk_i or negedge rst_i)
begin
	if (!rst_i) begin
		for (int i=0; i<REGISTERS_COUNT; i=i+1) x[i] <= 0;
		cmd_cnt <= 4;
		instr_addr_o <= MEMORY_SIZE*4-1;
		mem_we_o <= 0;
		mem_addr_o <= (MEMORY_SIZE*4-1)/2;
	end
	else if((instr_data_i >= 0) && (instr_addr_o < MEMORY_SIZE*4))
	begin
		mem_we_o <= 0;
		case (instr_data_i[6:0])
		OP_IMM:
			case (instr_data_i[14:12])
				ADDI: x[instr_data_i[11:7]] = x[instr_data_i[19:15]] + instr_data_i[31:20];
				ANDI: x[instr_data_i[11:7]] = x[instr_data_i[19:15]] & instr_data_i[31:20];
				default: $strobe("Undefined OP_IMM");
			endcase
		LOAD: x[instr_data_i[11:7]] = mem_data_i;
		STORE: 
			begin
				mem_we_o <= 1;
				mem_data_o <= x[instr_data_i[24:20]];
			end
		default: $strobe("Undefined command for code %b", instr_data_i[6:0]);
		endcase;
		cmd_cnt <= cmd_cnt+4;
		instr_addr_o <= MEMORY_SIZE*4-cmd_cnt-1;		
	end
end
endmodule