/*
	mux_2
	module name:
	1) mux_2_input
	2) mux_2_input_2
*/
module mux_2_input
(
	input logic [3:0] d0, d1,
	input logic s,
	output logic [3:0] y
);
	assign y =s ? d1 : d0;
endmodule

/*
?: is especially useful for describing a multiplexer
because, based on the first input, it selects between 
two others.

?: is also called a ternary operator, because it takes three
inputs. It is used for the same purpose in the C and Java 
programming languages.

*/

module mux_2_input_2
(
	input logic [3:0] d0, d1,
	input logic s,
	output tri [3:0] y
);
	tristate t0(d0, ~s, y);
	tristate t1(d1, s, y);
endmodule

/*
In SystemVerilog, expressions such as ~s are permitted in the
port list for an instance. Arbitrarily complicated expressions
are legal but discouraged because they make the code difficult
to read.

*/