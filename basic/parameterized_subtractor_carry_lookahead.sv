module subtractor_carry_lookahead_parameter
#(parameter width = 8)
(
	input logic [width-1:0] a, b,
	output logic [width-1:0] y
);
	logic [width-1:0] inverted_b;
	logic temp;
	
	assign inverted_b = ~ b;
	carry_lookahead_adder_parameter #(width) subtraction(a, inverted_b, 1'b1, y, temp);

endmodule