module comparator_parameter
#(parameter width = 8)
(
	input logic [width-1:0] a, b,
	output logic equal, unequal, 
	less_then, less_then_equal, 
	greater_then, greater_then_equal
);

	// An equality comparator produces a single output indicating whether A is
	// equal to B
	assign equal = (a == b);
	assign unequal = (a != b);
	
	// Magnitude comparison of signed numbers is usually done by computing
	// A-B and looking at the sign (most significant bit) of the result
	assign less_then = (a < b);
	assign less_then_equal = (a <= b);
	assign greater_then = (a > b);
	assign greater_then_equal = (a >= b);
	//	This comparator, however, functions incorrectly upon overflow
endmodule

/*
Note: this module can only work on unsigned numbers
*/

// N bit signed comparator 
module comparator_signed_parameter
#(parameter width = 8)
(
	input logic [width-1:0] a, b,
	output logic less_then
);
	logic [width-1:0] result;
	logic overflow, inverted_result_h;
	
	// use the subtractor
	assign result = a - b;
	
	assign inverted_result_h = ~result[width-1];
	
	assign overflow = (result[width-1] ^ a[width-1]) & (a[width-1] ^ b[width-1]);
	
	mux_2_input_parameter #(1) mux_2(result[width-1], inverted_result_h, overflow, less_then);
	
endmodule

// this comparator is used with ALU
module comparator_unsigned_alu
(
	// ALU  signals
	input logic n, z, c, v,
	// higher than or the same (hs), lower than or the same (ls), higher (hi), lower (lo)
	output logic hs, ls, hi, lo
);

	always_comb
		begin
			hs = c;
			ls = z | (~hs);
			hi = ~ls;
			lo = ~hs;
		end

endmodule

// his comparator is used with ALU
module comparator_signed_alu
(
	// ALU  signals
	input logic n, z, c, v,
	// greater than or equal (ge), less than or equal (le), greater than (gt), less than (lt)
	output logic ge, le, gt, lt
);

	always_comb
		begin
			ge = ~(n ^ v);
			le = z | (~ge);
			gt = ~le;
			lt = ~ge;
		end

endmodule

