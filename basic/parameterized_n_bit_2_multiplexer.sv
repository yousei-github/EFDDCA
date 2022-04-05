module mux_2_input_parameter
#(parameter width = 8)
(
	input logic [width-1:0] d0, d1,
	input logic s,
	output logic [width-1:0] y
);

	assign y = s ? d1 : d0;
endmodule : mux_2_input_parameter

/*
SystemVerilog allows a [#(parameter . . . )] statement before
the inputs and outputs to define parameters. The [parameter]
statement includes a default value (8) of the parameter, in this
case called [width]. The number of bits in the inputs and outputs
can depend on this parameter.
*/

module mux_4_input_8(input logic [7:0] d0, d1, d2, d3,
																					input logic [1:0] s,
																					output logic [7:0] y);
	logic [7:0] low, hi;
	mux_2_input_parameter lowmux(d0, d1, s[0], low);
	mux_2_input_parameter himux(d2, d3, s[0], hi);
	mux_2_input_parameter outmux(low, hi, s[1], y);
endmodule

/*
The 8-bit 4:1 multiplexer instantiates three 2:1 multiplexers
using their default widths.
*/

/*
In contrast, a 12-bit 4:1 multiplexer, mux_4_input_12, would
need to override the default width using [#( )] before the
instance name, as shown below.
*/

module mux_4_input_12(input logic [11:0] d0, d1, d2, d3,
																						input logic [1:0] s,
																						output logic [11:0] y);
	logic [11:0] low, hi;
	mux_2_input_parameter #(12) lowmux(d0, d1, s[0], low);
	mux_2_input_parameter #(12) himux(d2, d3, s[0], hi);
	mux_2_input_parameter #(12) outmux(low, hi, s[1], y);
endmodule

/*
Do not confuse the use of the [#] sign indicating delays with
the use of [#(. . .)] in defining and overriding parameters.
*/


module mux_4_input_parameter
#(parameter width = 32)
(
	input logic [width-1:0] d0, d1, d2, d3,
	input logic [1:0] s,
	output logic [width-1:0] y
);
	assign y = s[1] ? (s[0] ? d3 : d2)
												 : (s[0] ? d1 : d0);
endmodule
