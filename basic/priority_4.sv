/*
	priority
	module name:
	1) priority_4
	2) priority_casez_4
*/
module priority_4
(
	input logic [3:0] a,
	output logic [3:0] y
);
	always_comb
		if (a[3]) 			 y = 4'b1000;
		else if (a[2]) y = 4'b0100;
		else if (a[1]) y = 4'b0010;
		else if (a[0]) y = 4'b0001;
		else 						 y = 4'b0000;
endmodule

/*
In SystemVerilog, [if] statements must appear inside of [always]
statements.
*/

module priority_casez_4
(
	input logic [3:0] a,
	output logic [3:0] y
);
	always_comb
		casez(a)
			4'b1???:   y = 4'b1000;
			4'b01??:  y = 4'b0100;
			4'b001?:  y = 4'b0010;
			4'b0001: y = 4'b0001;
			default: 	y = 4'b0000;
		endcase
endmodule

/*
The [casez] statement acts like a [case] statement except that it
also recognizes ? as don’t care.

*/