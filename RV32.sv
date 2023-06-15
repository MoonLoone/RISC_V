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
enum {OP_IMM = 7'b0010011, LOAD = 7'b0000011, STORE = 7'b0100011} opcode;
enum {ADDI = 3'b000, ANDI = 3'b111, LW = 3'b010, SW = 3'b010} funct3;
logic[31:0] x0; //instruction counter
logic[31:0] x1;
logic[31:0] x2;
logic[31:0] x3;
always_ff@(posedge clk_i or negedge rst_i)
begin
	if (!rst_i) begin
		x0 = 0;
	end
	else begin
		case (instr_data_i[6:0])
		0010011: $strobe("ADDI");	//ADDI
		0010011: $strobe("ANDI");	//ANDI
		0000011: $strobe("LW");		//LW
		0100011: $strobe("SW");		//SW
		default: $strobe("Unrecognised function"); 
		endcase;	
	end
end
endmodule