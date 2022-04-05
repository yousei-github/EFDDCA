`timescale 1ns/1ps
module example_delays(input logic a, b, c,
																					 output logic y);
	logic ab, bb, cb, n1, n2, n3;
	assign #1 {ab, bb, cb} = ~{a, b, c};
	assign #2 n1 = ab & bb & cb;
	assign #2 n2 =a & bb & cb;
	assign #2 n3 =a & bb & c;
	assign #4 y = n1 | n2 | n3;
endmodule

/*
SystemVerilog files can include a timescale directive that indicates
the value of each time unit. The statement is of the form
[`timescale unit/precision]. In this file, each unit is 1 ns, and
the simulation has 1 ps precision. If no timescale directive is
given in the file, a default unit and precision (usually 1 ns
for both) are used. 
In SystemVerilog, a # symbol is used to indicate the number 
of units of delay. It can be placed in [assign] statements, as well 
as non-blocking (<=) and blocking (=) assignments.
*/