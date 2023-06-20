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
//x[0] = 0; //first register is interconnected to ground

always_ff@(posedge clk_i or negedge rst_i)
begin
	if (!rst_i) begin
		for (int i=0; i<REGISTERS_COUNT; i=i+1) x[i] <= 0;
		cmd_cnt <= 1;
		instr_addr_o <= MEMORY_SIZE-1;
		mem_we_o <= 0;
		mem_addr_o <= (MEMORY_SIZE-1)/2;
	end
	else if(instr_data_i >= 0)
	begin
		mem_we_o <= 0;
		case (instr_data_i[6:0])
		OP_IMM:
			case (instr_data_i[14:12])
				ADDI:
					begin
						$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
						x[instr_data_i[11:7]] = x[instr_data_i[19:15]]+instr_data_i[31:20];
						$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
					end
				ANDI:
					begin
						$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
						x[instr_data_i[11:7]] = x[instr_data_i[19:15]]&instr_data_i[31:20];
						$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
					end
				default: $strobe("Undefined OP_IMM");
			endcase
		LOAD: 
			begin
				$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
				x[instr_data_i[11:7]] = mem_data_i;
				$strobe("x[%d] = %d",instr_data_i[11:7], x[instr_data_i[11:7]]);
			end
		STORE: 
			begin
				mem_we_o <= 1;
				mem_data_o <= x[instr_data_i[24:20]];
			end
		default: $strobe("Undefined command %b", instr_data_i[6:0]);
		endcase;
		cmd_cnt <= cmd_cnt+1;
		instr_addr_o <= MEMORY_SIZE-cmd_cnt-1;		
	end
end
endmodule