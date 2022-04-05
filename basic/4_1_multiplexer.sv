/*
	mux_4
	module name:
	1) mux_4_input
	2) mux_4_input_2
*/
module mux_4_input
(
	input logic [3:0] d0, d1, d2, d3,
	input logic [1:0] s,
	output logic [3:0] y
);
	assign y = s[1] ? (s[0] ? d3 : d2)
												 : (s[0] ? d1 : d0);
endmodule

/*
A 4:1 multiplexer.
*/

module mux_4_input_2
(
	input logic [3:0] d0, d1, d2, d3,
	input logic [1:0] s,
	output logic [3:0] y
);
	logic [3:0] low, high;
	mux_2_input lowmux(d0, d1, s[0], low);
	mux_2_input highmux(d2, d3, s[0], high);
	mux_2_input finalmux(low, high, s[1], y);
endmodule

/*
The three mux_2_input instances are called lowmux, highmux, and
finalmux. The mux_2_input module must be defined elsewhere in the
SystemVerilog code.

Multiple instances of the same module are distinguished by
distinct names, in this case lowmux, highmux, and finalmux. This is an
example of regularity, in which the 2:1 multiplexer is reused many times.

*/