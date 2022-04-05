module subtractor_prefix_adder_16
(
	input logic [16-1:0] a, b,
	output logic [16-1:0] y
);
	logic [16-1:0] inverted_b;
	logic temp;
	
	assign inverted_b = ~ b;
	prefix_adder_16 subtraction(a, inverted_b, 1'b1, y, temp);

endmodule