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
logic[31:0] x0; //instruction counter
logic[31:0] x1;
logic[31:0] x2;
logic[31:0] x3;
always_ff@(posedge clk_i or negedge rst_i)
begin
	if (!rst_i) begin
		x0 <= 1;
		instr_addr_o <= MEMORY_SIZE-1;
		mem_we_o <= 0;
		mem_addr_o <= MEMORY_SIZE/4;
	end
	else begin
		case (instr_data_i[6:0])
		OP_IMM:
			begin
				$strobe("OP_IMM");
				x0 <= x0+1;
				instr_addr_o <= MEMORY_SIZE-x0-1;	
			end
		LOAD: 
			begin
				$strobe("LOAD");	//ANDI
				x0 <= x0+1;
				x1 <= mem_data_i;
				instr_addr_o <= MEMORY_SIZE-x0-1;	
			end
		STORE: 
			begin
				$strobe("STORE");	//STORE
				x0 <= x0+1;
				instr_addr_o <= MEMORY_SIZE-x0-1;	
			end
		endcase;	
	end
end
endmodule