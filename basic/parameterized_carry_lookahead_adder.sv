module carry_lookahead_adder_parameter 
#(parameter 
	width = 32,
	block_size = 4,
	block_number = width/block_size
	)
(
	input logic [width-1:0] a, b,
	input logic cin,
	output logic [width-1:0] s,
	output logic cout
);

	// temp is used to storage each cout for each block
	logic [block_number:0] temp;
	// temp_2 is used to get rid of the cout given by ripple_carry_adder (block_number-1)
	logic [block_number-1-1:0] temp_2;
	// g: generate, p: propagate signals for (block_number-1) blocks
	logic [width-1-block_size:0] g, p;
	// generate and propagate signals for each block (block_number-1)
	logic [block_number-1-1:0] g_block, p_block;
	logic [width-1-block_size:0] g_temp;
	logic [width-1-block_size:0] p_temp;
	
	assign temp[0] = cin;
	
	genvar i, j;

	generate
		// for the first (block_number-1) blocks
		for(i=0; i<block_number-1; i=i+1) 
			begin: forloop_1
				
				// get each g, p for this block (from 0 to block_size-1-1)
				for(j=0; j<block_size; j=j+1) 
				begin: forloop_2		
					assign	g[block_size*i + j] = a[block_size*i + j] & b[block_size*i + j];
					assign	p[block_size*i + j] = a[block_size*i + j] | b[block_size*i + j];
				end
				
				// get g_block for this block
				assign	g_temp[block_size*i + 0] = g[block_size*i + 0];
				for(j=1; j<block_size; j=j+1) 
				begin: forloop_3
					assign	g_temp[block_size*i + j] = g[block_size*i + j] | p[block_size*i + j] & g_temp[block_size*i + j-1];
				end
				assign g_block[i] = g_temp[block_size*i + block_size-1];
				
				// get p_block for this block
				assign	p_temp[block_size*i + 0] = p[block_size*i + 0];
				for(j=1; j<block_size; j=j+1) 
				begin: forloop_4
					assign	p_temp[block_size*i + j] = p[block_size*i + j] & p_temp[block_size*i + j-1];
				end
				assign p_block[i] = p_temp[block_size*i + block_size-1];
				
				// get cout for this block
				assign temp[i+1] = g_block[i] | (p_block[i] & temp[i]);
				
				// calculate the sum for this block and get rid of the cout given by below
				ripple_carry_adder_parameter #(block_size) cpa(a[block_size*i + block_size-1:block_size*i], 
				b[block_size*i + block_size-1:block_size*i], temp[i], s[block_size*i + block_size-1:block_size*i], temp_2[i]);
			end
		// for the final short ripple-carry adder (use the adventage of forloop_1)
		ripple_carry_adder_parameter #(block_size) cpa(a[block_size*(block_number-1) + block_size-1:block_size*(block_number-1)], 
		b[block_size*(block_number-1) + block_size-1:block_size*(block_number-1)], temp[(block_number-1)], 
		s[block_size*(block_number-1) + block_size-1:block_size*(block_number-1)], temp[block_number]);
	endgenerate
	
	
	assign cout = temp[block_number];


endmodule

/*
Note: the critical path through the last block contains a short ripple-carry adder.
*/