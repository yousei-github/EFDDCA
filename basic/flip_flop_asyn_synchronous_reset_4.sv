/*
	flip flop
	module name:
	1) flip_flop_asyn_reset_4_input
	2) flip_flop_syn_reset_4_input
	3) flip_flop_asyn_reset_parameter
	4) flip_flop_syn_reset_parameter
*/

module flip_flop_asyn_reset_4_input
(
	input logic clk,
	input logic reset,
	input logic [3:0] d,
	output logic [3:0] q
);
	// asynchronous reset
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 4'b0;
		else q <= d;
endmodule

module flip_flop_syn_reset_4_input
(
	input logic clk,
	input logic reset,
	input logic [3:0] d,
	output logic [3:0] q
);
	// synchronous reset
	always_ff @(posedge clk)
		if (reset) q <= 4'b0;
		else q <= d;
endmodule

/*
Multiple signals in an [always] statement sensitivity list are
separated with a comma or the word [or]. Notice that [posedge
reset] is in the sensitivity list on the asynchronously resettable
flop, but not on the synchronously resettable flop. Thus, the
asynchronously resettable flop immediately responds to a rising
edge on [reset], but the synchronously resettable flop
responds to [reset] only on the rising edge of the clock.

*/


module flip_flop_asyn_reset_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset,
	input logic [width-1:0] d,
	output logic [width-1:0] q
);
	// asynchronous reset
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else q <= d;
endmodule

module flip_flop_syn_reset_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset,
	input logic [width-1:0] d,
	output logic [width-1:0] q
);
	// synchronous reset
	always_ff @(posedge clk)
		if (reset) q <= 0;
		else q <= d;
endmodule

