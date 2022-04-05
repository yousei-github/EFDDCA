/*
	full adder
	module name:
	1) fulladder
	2) fulladder_2
*/
module fulladder
(
	input logic a, b, cin,
	output logic s, cout
);
	logic p, g;
	assign p = a ^ b;
	assign g = a & b;
	assign s = p ^ cin;
	assign cout = g | (p & cin);
endmodule

/*
In SystemVerilog, [internal signals] are usually declared as
logic.

*/

module fulladder_2
(
	input logic a, b, cin,
	output logic s, cout
);
	logic p, g;
	always_comb
		begin
		p = a ^ b; 									// blocking
		g = a & b;									  // blocking
		s = p ^ cin; 								// blocking
		cout = g | (p & cin); 	// blocking
		end
endmodule

/*
In this case, [always @(a, b, cin)] would have been equivalent
to [always_comb]. However, [always_comb] is better because it
avoids common mistakes of missing signals in the sensitivity
list.

it is best to use blocking assignments for combinational logic.
*/