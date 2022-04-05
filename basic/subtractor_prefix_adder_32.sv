module subtractor_prefix_adder_32
(
	input logic [32-1:0] a, b,
	output logic [32-1:0] y
);
	logic [32-1:0] inverted_b;
	logic temp;
	
	assign inverted_b = ~ b;
	prefix_adder_32 subtraction(a, inverted_b, 1'b1, y, temp);

endmodule