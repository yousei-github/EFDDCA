/*
	multiplier
	module name:
	1) multiplier_unsign
	2) multiplier_sign
	3) multiplier_4x4_unsign
	4) multiplier_16x16_unsign
*/

// 4.33(a): unsigned multiplier
module multiplier_unsign
(
	input logic [3:0] a, b,
	output logic [7:0] y
);
	assign y =a * b;
endmodule
// 4.33(b): signed multiplier
module multiplier_sign
(
	input logic signed [3:0] a, b,
	output logic signed [7:0] y
);
	assign y =a * b;
endmodule

/*
In SystemVerilog, signals are considered unsigned by default.
Adding the [signed] modifier (e.g., logic signed [3:0] a)
causes the signal a to be treated as signed.
*/

module multiplier_4x4_unsign
(
	input logic [4-1:0] a, b,
	output logic [2*4-1:0] y
);
	
	logic [4-1:0] a_l1, b_l1, s_l1, cout_l1;
	logic [4-1:0] a_l2, b_l2, s_l2, cout_l2;
	logic [4-1:0] a_l3, b_l3, s_l3, cout_l3;
	
	genvar i;
	
	generate
		// for level 1
		assign y[1-1] = a[0] & b[0];
		// get each a_l1
		for(i=0; i<4-1; i=i+1) 
			begin: forloop_1
				assign	a_l1[i] = a[i+1] & b[0];
			end
		assign a_l1[4-1] = 1'b0;
		// get each b_l1
		for(i=0; i<4; i=i+1) 
			begin: forloop_2
				assign	b_l1[i] = a[i] & b[1];
			end
		
		fulladder fa_l1_1(a_l1[0], b_l1[0], 1'b0, s_l1[0], cout_l1[0]);
		for(i=1; i<4; i=i+1) 
			begin: forloop_3
				fulladder fa_l1(a_l1[i], b_l1[i], cout_l1[i-1], s_l1[i], cout_l1[i]);
			end
		
		// for level 2
		assign y[2-1] = s_l1[0];
		// get each a_l2
		for(i=0; i<4-1; i=i+1) 
			begin: forloop_4
				assign	a_l2[i] = s_l1[i+1];
			end
		assign a_l2[4-1] = cout_l1[4-1];
		// get each b_l2
		for(i=0; i<4; i=i+1) 
			begin: forloop_5
				assign	b_l2[i] = a[i] & b[2];
			end
		
		fulladder fa_l1_2(a_l2[0], b_l2[0], 1'b0, s_l2[0], cout_l2[0]);
		for(i=1; i<4; i=i+1) 
			begin: forloop_6
				fulladder fa_l1(a_l2[i], b_l2[i], cout_l2[i-1], s_l2[i], cout_l2[i]);
			end
		
		// for level 3
		assign y[3-1] = s_l2[0];
		// get each a_l3
		for(i=0; i<4-1; i=i+1) 
			begin: forloop_7
				assign	a_l3[i] = s_l2[i+1];
			end
		assign a_l3[4-1] = cout_l2[4-1];
		// get each b_l3
		for(i=0; i<4; i=i+1) 
			begin: forloop_8
				assign	b_l3[i] = a[i] & b[3];
			end
		
		fulladder fa_l1_3(a_l3[0], b_l3[0], 1'b0, s_l3[0], cout_l3[0]);
		for(i=1; i<4; i=i+1) 
			begin: forloop_9
				fulladder fa_l1(a_l3[i], b_l3[i], cout_l3[i-1], s_l3[i], cout_l3[i]);
			end
		
		// get remain result
		for(i=3; i<2*4-1; i=i+1) 
			begin: forloop_10
				assign y[i] = s_l3[i-3];
			end
		assign y[2*4-1] = cout_l3[4-1];
		
	endgenerate
	
endmodule


module multiplier_16x16_unsign
(
	input logic [16-1:0] a, b,
	output logic [2*16-1:0] y
);

	logic [16-1:0] a_l1, b_l1, s_l1;
	logic cout_l1;
	logic [16-2:1][16-1:0] a_l;
	logic [16-2:0][16-1:0] s_l;
	logic [16-2:0] cout_l;
	genvar i, j;
	
	generate
		// for level 1
		assign y[0] = a[0] & b[0];
		// get each b_l1
		for(i=0; i<16-1; i=i+1) 
			begin: forloop_1
				assign	b_l1[i] = a[i+1] & b[0];
			end
		assign b_l1[16-1] = 1'b0;
		// get each a_l1
		for(i=0; i<16; i=i+1) 
			begin: forloop_2
				assign	a_l1[i] = a[i] & b[1];
			end
		
		prefix_adder_16 cpa_l1(a_l1, b_l1, 1'b0, s_l1, cout_l1);
		
		assign y[1] = s_l1[0];
		
		// for level 2~16
		assign cout_l[0] = cout_l1;
		assign s_l[0] = s_l1;
		
		for(i=1; i<16-1; i=i+1)
			begin: forloop_3
				// get each a_l
				for(j=0; j<16; j=j+1)
					begin: forloop_4
						assign	a_l[i][j] = a[j] & b[i+1];
					end
				prefix_adder_16 cpa_l(a_l[i], {cout_l[i-1], s_l[i-1][16-1:1]}, 1'b0, s_l[i], cout_l[i]);
				
				assign y[i+1] = s_l[i][0];
			end
		assign y[2*16-1:16] = {cout_l[16-2], s_l[16-2][16-1:1]};
		
	endgenerate
	
endmodule



