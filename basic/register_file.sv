/*
	register file
	module name:
	1) register_file_32
*/

/*
	register_file_32
	The 15-element × 32-bit register file holds registers R0–R14 and has
	an additional input to receive R15 from the PC. The register file has
	two read ports and one write port. The read ports take 4-bit address
	inputs, A1 and A2, each specifying one of 2^4=16 registers as source
	operands. They read the 32-bit register values onto read data outputs
	RD1 and RD2, respectively. The write port takes a 4-bit address input,
	A3; a 32-bit write data input, WD3; a write enable input, WE3; and a
	clock. If the write enable is asserted, then the register file writes the data
	into the specified register on the rising edge of the clock. A read of R15
	returns the value from the PC plus 8, and writes to R15 must be specially
	handled to update the PC because it is separate from the register file.
*/
module register_file_32
(
	input logic clk,
	input logic reset,
	// write enable input
	input logic we3,
	// two read ports ra1, ra2, one write enable input wa3
	input logic [4-1:0] ra1, ra2, wa3,
	// write data input wd3, additional input r15
	input logic [32-1:0] wd3, r15,
	// read data outputs rd1, rd2
	output logic [32-1:0] rd1, rd2,
	// used for testbench
	output logic [32-1:0] registers[15-1:0]
	// end of used for testbench
);
	// internal registers
	logic [32-1:0] rf[15-1:0];
	logic [32-1:0] rf_next[15-1:0];
	logic [15-1:0] s;
	
	// three ported register file
	// read two ports combinationally
	// write third port on rising edge of clock
	// register 15 reads PC+8 instead
	
	always_comb
		case(wa3)
			4'd0: 	s = 15'b000_0000_0000_0001;
			4'd1: 	s = 15'b000_0000_0000_0010;
			4'd2: 	s = 15'b000_0000_0000_0100;
			4'd3: 	s = 15'b000_0000_0000_1000;
			4'd4: 	s = 15'b000_0000_0001_0000;
			4'd5: 	s = 15'b000_0000_0010_0000;
			4'd6: 	s = 15'b000_0000_0100_0000;
			4'd7: 	s = 15'b000_0000_1000_0000;
			4'd8: 	s = 15'b000_0001_0000_0000;
			4'd9: 	s = 15'b000_0010_0000_0000;
			4'd10: s = 15'b000_0100_0000_0000;
			4'd11: s = 15'b000_1000_0000_0000;
			4'd12: s = 15'b001_0000_0000_0000;
			4'd13: s = 15'b010_0000_0000_0000;
			4'd14: s = 15'b100_0000_0000_0000;
			default: s = 15'd0;
		endcase
	
	genvar i;
	generate
	
	for(i=0; i<15; i=i+1) 
			begin: forloop_1
				mux_2_input_parameter #(32) mux_internal(rf[i], wd3, s[i], rf_next[i]);
				flip_flop_asyn_reset_parameter #(32) register_internal(clk, reset, rf_next[i], rf[i]);
			end
			
	endgenerate
	
	
	/*
	always_ff @(posedge clk, posedge reset)
		if (reset)
			begin
			rf[0] 	<= 32'd0;
			rf[1] 	<= 32'd0;
			rf[2] 	<= 32'd0;
			rf[3] 	<= 32'd0;
			rf[4] 	<= 32'd0;
			rf[5] 	<= 32'd0;
			rf[6] 	<= 32'd0;
			rf[7] 	<= 32'd0;
			rf[8] 	<= 32'd0;
			rf[9] 	<= 32'd0;
			rf[10] <= 32'd0;
			rf[11] <= 32'd0;
			rf[12] <= 32'd0;
			rf[13] <= 32'd0;
			rf[14] <= 32'd0;
			end
		else if (we3) rf[wa3] <= wd3;
		*/
	
	assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
	assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
	
	// used for testbench
	assign registers = rf;
	// end of used for testbench
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
	