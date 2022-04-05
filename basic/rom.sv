/*
	ROM
	module name:
	1) rom_4x3
	2) rom_4x32
	3) rom_232x32 (232 means 2^32)
*/

module rom_4x3
(
	input logic [1:0] adr,
	output logic [2:0] dout
);
	
	always_comb
		case(adr)
		2'b00: dout = 3'b011;
		2'b01: dout = 3'b110;
		2'b10: dout = 3'b100;
		2'b11: dout = 3'b010;
		endcase

endmodule


module rom_4x32
(
	input logic [1:0] adr,
	output logic [32-1:0] dout
);
	
	always_comb
		case(adr)
		2'b00: dout = 32'b011;
		2'b01: dout = 32'b110;
		2'b10: dout = 32'b100;
		2'b11: dout = 32'b010;
		endcase

endmodule

module rom_232x32
(
	input logic [32-1:0] adr,
	output logic [32-1:0] dout
);
	
	always_comb
		case(adr)
		32'h0000_0000: dout = 32'hE590_1000;
		32'h0000_0004: dout = 32'hE590_2001;
		32'h0000_0008: dout = 32'hE590_3002;
		32'h0000_000C: dout = 32'hE590_4003;
		32'h0000_0010: dout = 32'hE082_5001;
		32'h0000_0014: dout = 32'hE041_6004;
		32'h0000_0018: dout = 32'hE590_7003;
		32'h0000_001C: dout = 32'hE590_7003;
		32'h0000_0020: dout = 32'hEA00_0001;
		32'h0000_0024: dout = 32'hE590_1001;
		32'h0000_0028: dout = 32'hE590_1001;
		32'h0000_002C: dout = 32'hE590_F000;
		32'h0000_0030: dout = 32'hE590_1002;
		32'h0000_0034: dout = 32'hE590_1002;
		default: 							 dout = 32'hffff_ffff;
		endcase

endmodule

/* ARM instruction example
 * LDR R1, [R0, #0] = 0xE5901000
 * LDR R2, [R0, #1] = 0xE5902001
 * LDR R3, [R0, #2] = 0xE5903002
 * LDR R4, [R0, #3] = 0xE5904003
 * ADD R5, R2, R1 = 0xE0825001
 * SUB R6, R1, R4  = 0xE0416004
 * STR R6, [R0, #3] = 0xE5806003
 * LDR R7, [R0, #3] = 0xE5907003
 * B NEXT ()             = 0xEA000001
 
 * LDR R15, [R0, #0] = 0xE590F000
 
 
 
*/
