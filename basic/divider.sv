/*
	divider
	module name:
	1) divider_4_unsign
	2) divider_4_unsign_2
	3) divider_32_unsign
*/

module cell_for_divider
(
	input logic r, b, cin,
	input logic n,
	output logic d, r_, cout
);

	fulladder fa(r, b, cin, d, cout);
	
	mux_2_input_parameter #(1) mux_2(d, r, n, r_);

endmodule

// Binary division can be performed using the following algorithm for N-bit
// unsigned numbers in the range [0, 2^(N-1)]
module divider_4_unsign
(
	input logic [4-1:0] a, b,
	output logic [4-1:0] q, r
);

	logic [4-1:0] inverted_b;
	logic [4-1:0] r_l1, n_l1, d_l1;
	logic [4:0] cin_l1;
	logic [4-1:0] r_l2, n_l2, d_l2;
	logic [4:0] cin_l2;
	logic [4-1:0] r_l3, n_l3, d_l3;
	logic [4:0] cin_l3;
	logic [4-1:0] r_l4, n_l4, d_l4;
	logic [4:0] cin_l4;
	
	assign inverted_b = ~b;
	
	// for level 1
	assign cin_l1[0] = 1'b1;
	cell_for_divider c_l1_1(a[4-1], inverted_b[0], cin_l1[0], n_l1[0], d_l1[0], r_l1[0], cin_l1[0+1]);
	
	genvar i;
	
	generate
		for(i=1; i<4; i=i+1) 
			begin: forloop_1
				cell_for_divider c_l1(1'b0, inverted_b[i], cin_l1[i], n_l1[i], d_l1[i], r_l1[i], cin_l1[i+1]);
			end
		assign q[4-1] = ~d_l1[4-1];
		// select result for level 1
		for(i=0; i<4; i=i+1) 
				begin: forloop_2
					assign n_l1[i] = d_l1[4-1];
				end
	
		// for level 2
		assign cin_l2[0] = 1'b1;
		cell_for_divider c_l2_1(a[4-2], inverted_b[0], cin_l2[0], n_l2[0], d_l2[0], r_l2[0], cin_l2[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_3
				cell_for_divider c_l2(r_l1[i-1], inverted_b[i], cin_l2[i], n_l2[i], d_l2[i], r_l2[i], cin_l2[i+1]);
			end
		assign q[4-2] = ~d_l2[4-1];
		// select result for level 2
		for(i=0; i<4; i=i+1) 
				begin: forloop_4
					assign n_l2[i] = d_l2[4-1];
				end
		
		// for level 3
		assign cin_l3[0] = 1'b1;
		cell_for_divider c_l3_1(a[4-3], inverted_b[0], cin_l3[0], n_l3[0], d_l3[0], r_l3[0], cin_l3[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_5
				cell_for_divider c_l3(r_l2[i-1], inverted_b[i], cin_l3[i], n_l3[i], d_l3[i], r_l3[i], cin_l3[i+1]);
			end
		assign q[4-3] = ~d_l3[4-1];
		// select result for level 3
		for(i=0; i<4; i=i+1) 
				begin: forloop_6
					assign n_l3[i] = d_l3[4-1];
				end
		
		// for level 4
		assign cin_l4[0] = 1'b1;
		cell_for_divider c_l4_1(a[4-4], inverted_b[0], cin_l4[0], n_l4[0], d_l4[0], r_l4[0], cin_l4[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_7
				cell_for_divider c_l4(r_l3[i-1], inverted_b[i], cin_l4[i], n_l4[i], d_l4[i], r_l4[i], cin_l4[i+1]);
			end
		assign q[4-4] = ~d_l4[4-1];
		// select result for level 4
		for(i=0; i<4; i=i+1) 
				begin: forloop_8
					assign n_l4[i] = d_l4[4-1];
				end
		
		// get remainder
		for(i=0; i<4; i=i+1) 
			begin: forloop_9
				assign r[i] = r_l4[i];
			end
		
	endgenerate
endmodule

// Binary division can be performed using the following algorithm for N-bit
// unsigned numbers in the range [0, 2^(N)-1]
module divider_4_unsign_2
(
	input logic [4-1:0] a, b,
	output logic [4-1:0] q, r
);

	logic [4-1:0] inverted_b;
	logic [4-1:0] r_l1, n_l1, d_l1;
	logic [4:0] cin_l1;
	logic [4-1:0] r_l2, n_l2, d_l2;
	logic [4:0] cin_l2;
	logic [4-1:0] r_l3, n_l3, d_l3;
	logic [4:0] cin_l3;
	logic [4-1:0] r_l4, n_l4, d_l4;
	logic [4:0] cin_l4;
	
	assign inverted_b = ~b;
	
	// for level 1
	assign cin_l1[0] = 1'b1;
	cell_for_divider c_l1_1(a[4-1], inverted_b[0], cin_l1[0], n_l1[0], d_l1[0], r_l1[0], cin_l1[0+1]);
	
	genvar i;
	
	generate
		for(i=1; i<4; i=i+1) 
			begin: forloop_1
				cell_for_divider c_l1(1'b0, inverted_b[i], cin_l1[i], n_l1[i], d_l1[i], r_l1[i], cin_l1[i+1]);
			end
		// here is how I improve (assume expand the number with signed bit, 
		// a and b are always positive, so the circuit for sign can be simplified like below)
		//assign q[4-1] = ~d_l1[4-1];
		assign q[4-1] = cin_l1[4];
		// select result for level 1
		for(i=0; i<4; i=i+1) 
				begin: forloop_2
					assign n_l1[i] = ~cin_l1[4];
				end
	
		// for level 2
		assign cin_l2[0] = 1'b1;
		cell_for_divider c_l2_1(a[4-2], inverted_b[0], cin_l2[0], n_l2[0], d_l2[0], r_l2[0], cin_l2[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_3
				cell_for_divider c_l2(r_l1[i-1], inverted_b[i], cin_l2[i], n_l2[i], d_l2[i], r_l2[i], cin_l2[i+1]);
			end
		//assign q[4-2] = ~d_l2[4-1];
		assign q[4-2] = cin_l2[4];
		// select result for level 2
		for(i=0; i<4; i=i+1) 
				begin: forloop_4
					assign n_l2[i] = ~cin_l2[4];
				end
		
		// for level 3
		assign cin_l3[0] = 1'b1;
		cell_for_divider c_l3_1(a[4-3], inverted_b[0], cin_l3[0], n_l3[0], d_l3[0], r_l3[0], cin_l3[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_5
				cell_for_divider c_l3(r_l2[i-1], inverted_b[i], cin_l3[i], n_l3[i], d_l3[i], r_l3[i], cin_l3[i+1]);
			end
		//assign q[4-3] = ~d_l3[4-1];
		assign q[4-3] = cin_l3[4];
		// select result for level 3
		for(i=0; i<4; i=i+1) 
				begin: forloop_6
					assign n_l3[i] = ~cin_l3[4];
				end
		
		// for level 4
		assign cin_l4[0] = 1'b1;
		cell_for_divider c_l4_1(a[4-4], inverted_b[0], cin_l4[0], n_l4[0], d_l4[0], r_l4[0], cin_l4[0+1]);
		
		for(i=1; i<4; i=i+1) 
			begin: forloop_7
				cell_for_divider c_l4(r_l3[i-1], inverted_b[i], cin_l4[i], n_l4[i], d_l4[i], r_l4[i], cin_l4[i+1]);
			end
		//assign q[4-4] = ~d_l4[4-1];
		assign q[4-4] = cin_l4[4];
		// select result for level 4
		for(i=0; i<4; i=i+1) 
				begin: forloop_8
					assign n_l4[i] = ~cin_l4[4];
				end
		
		// get remainder
		for(i=0; i<4; i=i+1) 
			begin: forloop_9
				assign r[i] = r_l4[i];
			end
		
	endgenerate
endmodule

module divider_32_unsign
(
	input logic [32-1:0] a, b,
	output logic [32-1:0] q, r
);
	
	logic [32-1:0] a_l1, b_l1, s_l1;
	logic cout_l1;
	logic [31-1:0][32-1:0] a_l, s_l;
	logic [31-1:0] cout_l;
	
	assign b_l1 = ~b;
	assign a_l1= {31'b00, a[32-1]};
	
	prefix_adder_32 cpa_l1(a_l1, b_l1, 1'b1, s_l1, cout_l1);
	assign q[32-1] = cout_l1;
	
	mux_2_input_parameter #(32) mux_l1({s_l1[32-2:0], a[32-2]}, {a_l1[32-2:0], a[32-2]}, ~cout_l1, a_l[31-1]);
	
	genvar i;
	
	generate
		for(i=0; i<31-1; i=i+1) 
			begin: forloop_1
				prefix_adder_32 cpa_l(a_l[31-1-i], b_l1, 1'b1, s_l[31-1-i], cout_l[31-1-i]);
				assign q[31-1-i] = cout_l[31-1-i];
				mux_2_input_parameter #(32) mux_l({s_l[31-1-i][32-2:0], a[32-3-i]}, {a_l[31-1-i][32-2:0], a[32-3-i]}, ~cout_l[31-1-i], a_l[31-2-i]);
			end
	
	// for last level
	prefix_adder_32 cpa_ll(a_l[0], b_l1, 1'b1, s_l[0], cout_l[0]);
	assign q[0] = cout_l[0];
	mux_2_input_parameter #(32) mux_ll(s_l[0], a_l[0], ~cout_l[0], r);
	
	endgenerate
	
endmodule












