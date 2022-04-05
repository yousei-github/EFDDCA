module prefix_adder_32
(
	input logic [32-1:0] a, b,
	input logic cin,
	output logic [32-1:0] s,
	output logic cout
);

	// g: generate, p: propagate signals
	logic [32-1:0] g, p;
	logic [16-1:0] g_l1, p_l1;
	logic [16-1:0] g_l2, p_l2;
	logic [16-1:0] g_l3, p_l3;
	logic [16-1:0] g_l4, p_l4;
	logic [16-1:0] g_l5, p_l5;
	
	genvar i;
	
	generate
		for(i=0; i<32; i=i+1) 
			begin: forloop_1
				assign	g[i] = a[i] & b[i];
				assign	p[i] = a[i] | b[i];
			end
		
		// for level 1
		assign g_l1[0] = g[0] | (p[0] & cin);
		
		for(i=1; i<16; i=i+1) 
			begin: forloop_2
				assign	g_l1[i] = g[2*i] | (p[2*i] & g[2*i - 1]);
				assign	p_l1[i] = p[2*i] & p[2*i - 1];
			end
		
		// for level 2
		assign g_l2[0] = g[1] | (p[1] & g_l1[0]);
		assign g_l2[1] = g_l1[1] | (p_l1[1] & g_l1[0]);
		
		for(i=2; i<16; i=i+2) 
			begin: forloop_3
				assign	g_l2[i] = g[2*i + 1] | (p[2*i + 1] & g_l1[i]);
				assign	p_l2[i] = p[2*i + 1] & p_l1[i];
			end
		for(i=3; i<16; i=i+2) 
			begin: forloop_4
				assign	g_l2[i] = g_l1[i] | (p_l1[i] & g_l1[i - 1]);
				assign	p_l2[i] = p_l1[i] & p_l1[i - 1];
			end
		
	endgenerate
	
		// for level 3
		assign g_l3[0] = g[3] | (p[3] & g_l2[1]);
		assign g_l3[1] = g_l1[2] | (p_l1[2] & g_l2[1]);
		assign g_l3[2] = g_l2[2] | (p_l2[2] & g_l2[1]);
		assign g_l3[3] = g_l2[3] | (p_l2[3] & g_l2[1]);
		
		generate
			for(i=4; i<16; i=i+4) 
				begin: forloop_5
					assign	g_l3[i] = g[2*i + 3] | (p[2*i + 3] & g_l2[i + 1]);
					assign	p_l3[i] = p[2*i + 3] & p_l2[i + 1];
					
					assign	g_l3[i + 1] = g_l1[i + 2] | (p_l1[i + 2] & g_l2[i + 1]);
					assign	p_l3[i + 1] = p_l1[i + 2] & p_l2[i + 1];
					
					assign	g_l3[i + 2] = g_l2[i + 2] | (p_l2[i + 2] & g_l2[i + 1]);
					assign	p_l3[i + 2] = p_l2[i + 2] & p_l2[i + 1];
					
					assign	g_l3[i + 3] = g_l2[i + 3] | (p_l2[i + 3] & g_l2[i + 1]);
					assign	p_l3[i + 3] = p_l2[i + 3] & p_l2[i + 1];
				end
		endgenerate

		// for level 4
		assign g_l4[0] = g[7] | (p[7] & g_l3[3]);
		assign g_l4[1] = g_l1[4] | (p_l1[4] & g_l3[3]);
		assign g_l4[2] = g_l2[4] | (p_l2[4] & g_l3[3]);
		assign g_l4[3] = g_l2[5] | (p_l2[5] & g_l3[3]);
		
		assign g_l4[4] = g_l3[4] | (p_l3[4] & g_l3[3]);
		assign g_l4[5] = g_l3[5] | (p_l3[5] & g_l3[3]);
		assign g_l4[6] = g_l3[6] | (p_l3[6] & g_l3[3]);
		assign g_l4[7] = g_l3[7] | (p_l3[7] & g_l3[3]);
		
		assign g_l4[8] = g[23] | (p[23] & g_l3[11]);
		assign p_l4[8] = p[23] & p_l3[11];
		assign g_l4[9] = g_l1[12] | (p_l1[12] & g_l3[11]);
		assign p_l4[9] = p_l1[12] & p_l3[11];
		assign g_l4[10] = g_l2[12] | (p_l2[12] & g_l3[11]);
		assign p_l4[10] = p_l2[12] & p_l3[11];
		assign g_l4[11] = g_l2[13] | (p_l2[13] & g_l3[11]);
		assign p_l4[11] = p_l2[13] & p_l3[11];
		
		assign g_l4[12] = g_l3[12] | (p_l3[12] & g_l3[11]);
		assign p_l4[12] = p_l3[12] & p_l3[11];
		assign g_l4[13] = g_l3[13] | (p_l3[13] & g_l3[11]);
		assign p_l4[13] = p_l3[13] & p_l3[11];
		assign g_l4[14] = g_l3[14] | (p_l3[14] & g_l3[11]);
		assign p_l4[14] = p_l3[14] & p_l3[11];
		assign g_l4[15] = g_l3[15] | (p_l3[15] & g_l3[11]);
		assign p_l4[15] = p_l3[15] & p_l3[11];
		
		// for level 5
		assign g_l5[0] = g[15] | (p[15] & g_l4[7]);
		assign g_l5[1] = g_l1[8] | (p_l1[8] & g_l4[7]);
		assign g_l5[2] = g_l2[8] | (p_l2[8] & g_l4[7]);
		assign g_l5[3] = g_l2[9] | (p_l2[9] & g_l4[7]);
		
		assign g_l5[4] = g_l3[8] | (p_l3[8] & g_l4[7]);
		assign g_l5[5] = g_l3[9] | (p_l3[9] & g_l4[7]);
		assign g_l5[6] = g_l3[10] | (p_l3[10] & g_l4[7]);
		assign g_l5[7] = g_l3[11] | (p_l3[11] & g_l4[7]);
		
		assign g_l5[8] = g_l4[8] | (p_l4[8] & g_l4[7]);
		assign g_l5[9] = g_l4[9] | (p_l4[9] & g_l4[7]);
		assign g_l5[10] = g_l4[10] | (p_l4[10] & g_l4[7]);
		assign g_l5[11] = g_l4[11] | (p_l4[11] & g_l4[7]);
		assign g_l5[12] = g_l4[12] | (p_l4[12] & g_l4[7]);
		assign g_l5[13] = g_l4[13] | (p_l4[13] & g_l4[7]);
		assign g_l5[14] = g_l4[14] | (p_l4[14] & g_l4[7]);
		assign g_l5[15] = g_l4[15] | (p_l4[15] & g_l4[7]);
		
		// get sum (3~0)
		assign s[0] = a[0] ^ b[0] ^ cin;
		assign s[1] = a[1] ^ b[1] ^ g_l1[0];
		assign s[2] = a[2] ^ b[2] ^ g_l2[0];
		assign s[3] = a[3] ^ b[3] ^ g_l2[1];
		// get sum (7~4)
		generate
			for(i=0; i<4; i=i+1) 
				begin: forloop_6
					assign	s[i + 4] = a[i + 4] ^ b[i + 4] ^ g_l3[i];
				end
		endgenerate
		
		// get sum (15~8)
		generate
			for(i=0; i<8; i=i+1) 
				begin: forloop_7
					assign	s[i + 8] = a[i + 8] ^ b[i + 8] ^ g_l4[i];
				end
		endgenerate
		
		// get sum (31~16)
		generate
			for(i=0; i<16; i=i+1) 
				begin: forloop_8
					assign	s[i + 16] = a[i + 16] ^ b[i + 16] ^ g_l5[i];
				end
		endgenerate
		
		assign cout = g[31] | (p[31] & g_l5[15]);
		
endmodule
