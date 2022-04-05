module flip_flop_4_input(input logic clk,
																						input logic [3:0] d,
																						output logic [3:0] q);
	always_ff @(posedge clk)
		q <= d;
endmodule

/*
In general, a SystemVerilog [always] statement is written in the
form:

always @(sensitivity list)
	statement;

The [statement] is executed only when the event specified in the
[sensitivity list] occurs. In this example, the statement is
q <= d (pronounced “q gets d”). Hence, the flip-flop copies d
to q on the positive edge of the clock and otherwise remembers
the old state of q. Note that sensitivity lists are also referred to
as stimulus lists.

<= is called a nonblocking assignment.

As will be seen in subsequent sections, [always] statements
can be used to imply flip-flops, latches, or combinational logic,
depending on the sensitivity list and statement. Because of this
flexibility, it is easy to produce the wrong hardware inadvertently.

SystemVerilog introduces [always_ff], [always_latch], and [always_comb] 
to reduce the risk of common errors. [always_ff] behaves like [always] 
but is used exclusively to imply flip-flops and allows tools to produce 
a warning if anything else is implied.
*/