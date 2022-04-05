module alu_4f_32
(
	input logic [32-1:0] a, b,
	// control signal: 2'b00 for addition, 2'b01 for subtraction
	// 2'b10 for and, 2'b11 for or
	input logic [2-1:0] control,
	output logic [32-1:0] result,
	output logic n, // negative flag
	output logic z, // zero flag
	output logic c, // carry flag
	output logic v // overflow flag
);
	logic cout_temp;
	logic [32-1:0] inverted_b, b_temp;
	logic [32-1:0] sum;
	logic [32-1:0] and_result;
	logic [32-1:0] or_result;
	
	// control = 2'b00 for addition, control = 2'b01 for subtraction
	assign inverted_b = ~b;
	mux_2_input_parameter #(32) mux_b(b, inverted_b, control[0], b_temp);
	
	prefix_adder_32 addition(a, b_temp, control[0], sum, cout_temp);
	
	// control = 2'b10
	assign and_result = a & b;
	// control = 2'b11
	assign or_result = a | b;
	
	mux_4_input_parameter #(32) mux_result(sum, sum, and_result, 
	or_result, control, result);
	
	always_comb
		begin
			z = &(~result);
			n = result[32-1];
			c = cout_temp & (~control[1]);
			// the overflow judgement follows the rule of two's complement number
			v = (~control[1]) & (a[32-1] ^ sum[32-1]) & (~(control[0] ^ a[32-1] ^ b[32-1]));
		end
	
	
endmodule
