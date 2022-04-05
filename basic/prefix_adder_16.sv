module prefix_adder_16
(
	input logic [16-1:0] a, b,
	input logic cin,
	output logic [16-1:0] s,
	output logic cout
);

	// g: generate, p: propagate signals
	logic [16-1:0] g, p;
	logic [8-1:0] g_l1, p_l1;
	logic [8-1:0] g_l2, p_l2;
	logic [8-1:0] g_l3, p_l3;
	logic [8-1:0] g_l4, p_l4;
	
	genvar i;
	
	generate
		for(i=0; i<16; i=i+1) 
			begin: forloop_1
				assign	g[i] = a[i] & b[i];
				assign	p[i] = a[i] | b[i];
			end
		
		// for level 1
		assign g_l1[0] = g[0] | (p[0] & cin);
		
		for(i=1; i<8; i=i+1) 
			begin: forloop_2
				assign	g_l1[i] = g[2*i] | (p[2*i] & g[2*i - 1]);
				assign	p_l1[i] = p[2*i] & p[2*i - 1];
			end
		
		// for level 2
		assign g_l2[0] = g[1] | (p[1] & g_l1[0]);
		assign g_l2[1] = g_l1[1] | (p_l1[1] & g_l1[0]);
		
		for(i=2; i<8; i=i+2) 
			begin: forloop_3
				assign	g_l2[i] = g[2*i + 1] | (p[2*i + 1] & g_l1[i]);
				assign	p_l2[i] = p[2*i + 1] & p_l1[i];
			end
		for(i=3; i<8; i=i+2) 
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
		
		assign g_l3[4] = g[11] | (p[11] & g_l2[5]);
		assign p_l3[4] = p[11] & p_l2[5];
		
		assign g_l3[5] = g_l1[6] | (p_l1[6] & g_l2[5]);
		assign p_l3[5] = p_l1[6] & p_l2[5];
		
		assign g_l3[6] = g_l2[6] | (p_l2[6] & g_l2[5]);
		assign p_l3[6] = p_l2[6] & p_l2[5];
		
		assign g_l3[7] = g_l2[7] | (p_l2[7] & g_l2[5]);
		assign p_l3[7] = p_l2[7] & p_l2[5];
		
		// for level 4
		assign g_l4[0] = g[7] | (p[7] & g_l3[3]);
		assign g_l4[1] = g_l1[4] | (p_l1[4] & g_l3[3]);
		assign g_l4[2] = g_l2[4] | (p_l2[4] & g_l3[3]);
		assign g_l4[3] = g_l2[5] | (p_l2[5] & g_l3[3]);
		
		assign g_l4[4] = g_l3[4] | (p_l3[4] & g_l3[3]);
		assign g_l4[5] = g_l3[5] | (p_l3[5] & g_l3[3]);
		assign g_l4[6] = g_l3[6] | (p_l3[6] & g_l3[3]);
		assign g_l4[7] = g_l3[7] | (p_l3[7] & g_l3[3]);
		
		// get sum (3~0)
		assign s[0] = a[0] ^ b[0] ^ cin;
		assign s[1] = a[1] ^ b[1] ^ g_l1[0];
		assign s[2] = a[2] ^ b[2] ^ g_l2[0];
		assign s[3] = a[3] ^ b[3] ^ g_l2[1];
		// get sum (7~4)
		generate
			for(i=0; i<4; i=i+1) 
				begin: forloop_5
					assign	s[i + 4] = a[i + 4] ^ b[i + 4] ^ g_l3[i];
				end
		endgenerate
		
		// get sum (15~8)
		generate
			for(i=0; i<8; i=i+1) 
				begin: forloop_6
					assign	s[i + 8] = a[i + 8] ^ b[i + 8] ^ g_l4[i];
				end
		endgenerate
		
		assign cout = g[15] | (p[15] & g_l4[7]);
endmodule
