/*
	shift registers and scan chains
	module name:
	1) shift_register_parameter
	2) scannable_flip_flop_asyn_reset_parameter
*/

// The shift register can perform both serial-to-parallel
//  and parallel-to-serial operations
module shift_register_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset, load, //parallel load
	input logic sin,
	// parallel load data
	input logic [width-1:0] d,
	output logic [width-1:0] q,
	output logic sout
);
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if (load) q <= d;
		else q <= {q[width-2:0], sin};
	
	assign sout = q[width-1];
endmodule

module scannable_flip_flop_asyn_reset_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset, test,
	input logic sin,
	input logic [width-1:0] d,
	output logic [width-1:0] q,
	output logic sout
);
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if (test) q <= {q[width-2:0], sin};
		else q <= d;
	
	assign sout = q[width-1];
	
endmodule