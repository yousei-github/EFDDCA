module flip_flop_asyn_reset_en_4(input logic clk,
																														input logic reset,
																														input logic en,
																														input logic [3:0] d,
																														output logic [3:0] q);
	// asynchronous reset
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 4'b0;
		else if (en) q <= d;
endmodule

/*
an asynchronously resettable enabled register
that retains its old value if both [reset] and [en] 
are FALSE.
*/