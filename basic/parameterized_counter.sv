/*
	counter
	module name:
	1) counter_parameter
	2) counter_32
	3) up_down_counter_parameter
	4) up_down_counter_32
	5) Johnson_counter_parameter
*/

module counter_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset,
	output logic [width-1:0] q
);
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else q <= q + 1;
endmodule


module counter_32
(
	input logic clk,
	input logic reset,
	output logic [32-1:0] q
);
	logic [32-1:0] a, b;
	logic [32-1:0] s;
	logic cout;
		
	assign b = 32'b01;
	
	prefix_adder_32 adder(a, b, 1'b0, s, cout);
	
	flip_flop_asyn_reset_parameter #(32) ff(clk, reset, s, a);
	
	assign q = a;
		
endmodule


module up_down_counter_parameter
#(parameter width = 8)
(
	input logic clk,
	input logic reset,
	input logic up,
	output logic [width-1:0] q
);
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if(up) q <= q + 1;
		else q <= q - 1;
	
endmodule


module up_down_counter_32
(
	input logic clk,
	input logic reset,
	input logic up,
	output logic [32-1:0] q
);
	
	logic [32-1:0] a, b;
	logic [32-1:0] s;
	logic cout;
	
	mux_2_input_parameter #(32) mux_2(32'hFFFF_FFFE
	,32'b0, up, b);
	
	
	prefix_adder_32 adder(a, b, 1'b1, s, cout);
	
	flip_flop_asyn_reset_parameter #(32) ff(clk, reset, s, a);
	
	assign q = a;
	
endmodule


module Johnson_counter_parameter
#(parameter width = 4)
(
	input logic clk,
	input logic reset,
	output logic [width-1:0] q,
	output logic sout
);
	logic sin;
	
	assign sin = ~sout;
	
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else q <= {q[width-2:0], sin};
	
	assign sout = q[width-1];
	
endmodule


