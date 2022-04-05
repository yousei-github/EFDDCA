/*
	Shifters and Rotators
	Shifters and rotators move bits and multiply or divide by powers of 2.
	module name:
	1) logical_shifter_left_32
	2) logical_shifter_right_32
	3) arithmetic_shifter_left_32
	4) arithmetic_shifter_right_32
	5) logical_shifter_right_64
	6) funnel_shifter_32
*/

module logical_shifter_left_32
(
	input logic [32-1:0] a,
	input logic [5-1:0] shamt, // shift amount
	output logic [32-1:0] y
);

	assign y = a << shamt;
	
endmodule

module logical_shifter_right_32
(
	input logic [32-1:0] a,
	input logic [5-1:0] shamt, // shift amount
	output logic [32-1:0] y
);

	assign y = a >> shamt;
	
endmodule

module arithmetic_shifter_left_32
(
	input logic signed [32-1:0] a,
	input logic [5-1:0] shamt, // shift amount
	output logic [32-1:0] y
);

	assign y = a <<< shamt;
	
endmodule

module arithmetic_shifter_right_32
(
// Note: here signed indicator is important
	input logic signed [32-1:0] a,
	input logic [5-1:0] shamt, // shift amount
	output logic [32-1:0] y
);

	assign y = a >>> shamt;
	
endmodule


module logical_shifter_right_64
(
	input logic [64-1:0] a,
	input logic [6-1:0] shamt, // shift amount
	output logic [64-1:0] y
);

	assign y = a >> shamt;
	
endmodule


module funnel_shifter_32
(
	input logic [32-1:0] a,
	input logic [5-1:0] shamt, // shift amount
	// function control (encoding): LSR(000), LSL(100), 
	// ASR(001), ASL(101), ROR(010), ROL(011)
	// for the encoding 110, 111, they may be explained as LSL(ASL)
	input logic [3-1:0] control,
	output logic [32-1:0] y
);
	
	logic s_c;
	logic [2-1:0] s_b;
	logic [32-1:0] c_input;
	logic [32-1:0] a_sign_extend;
	logic [32-1:0] b_input;
	logic [6-1:0] k;
	logic s_k;
	logic [6-1:0] n_shamt;
	logic [64-1:0] b_c;
	
	// for the unknown control (110, 111)
	/*
	logic [3-1:0] control_safe;
	logic s_safe;
	assign s_safe = control[2] & control[1];
	mux_2_input_parameter #(3) mux_safe(control, 3'b000, s_safe, control_safe);
	assign s_c = ~control_safe[2];
	assign s_b[1] = control_safe[2] | control_safe[1];
	assign s_b[0] = control_safe[0];
	assign s_k = control_safe[1] & control_safe[0] | control_safe[2];
	*/
	
	assign s_c = ~control[2];
	assign s_b[1] = control[2] | control[1];
	assign s_b[0] = control[0];
	assign s_k = control[1] & control[0] | control[2];
	
	genvar i;
	// for arithmetic shift right
	generate
		for(i=0; i<32; i=i+1) 
			begin: forloop_1
				assign	a_sign_extend[i] = a[32-1];
			end
	endgenerate
	
	// for the least significant 32 bits (C)
	mux_2_input_parameter #(32) mux_c(32'b0, a, s_c, c_input);
	// for the most significant 32 bits (B)
	mux_4_input_parameter #(32) mux_b(32'b0, a_sign_extend, a, a, s_b, b_input);
	// get (N - shamt)
	subtractor_parameter #(6) sub_shamt(6'd32, {1'b0, shamt}, n_shamt);
	// decide k to shift the funnel shifter right
	mux_2_input_parameter #(6) mux_k({1'b0, shamt}, n_shamt, s_k, k);
	
	logical_shifter_right_64 lsr_64({b_input, c_input}, k, b_c);
	
	assign y = b_c[32-1:0];
	
endmodule











