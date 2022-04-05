/*
	inverter
	module name:
	1) inverter_4
	2) inverter_4_2
*/
module inverter_4
(
	input logic [3:0] a,
	output logic [3:0] y
);
	assign y = ~a;
endmodule

/*
a[3:0] represents a 4-bit bus. The bits, from most significant
to least significant, are a[3], a[2], a[1], and a[0]. This is called 
little-endian order, because the least significant bit has the 
smallest bit number. 
We could have named the bus a[4:1], in which case a[4] would 
have been the most significant. Or we could have used a[0:3], 
in which case the bits, from most significant to least significant, 
would be a[0], a[1], a[2], and a[3]. This is called big-endian order.

Endianness matters only for operators, such as addition, where 
the sum of one column carries over into the next. Either ordering
is acceptable, as long as it is used consistently.
*/

module inverter_4_2
(
	input logic [3:0] a,
	output logic [3:0] y
);
	always_comb
		y = ~a;
endmodule

/*
[always_comb] reevaluates the statements inside the [always]
statement any time any of the signals on the right hand side
of <= or = in the [always] statement change. In this case, it is
equivalent to [always @(a)], but is better because it avoids mistakes
if signals in the [always] statement are renamed or added.
If the code inside the [always] block is not combinational logic,
SystemVerilog will report a warning. 

[always_comb] is equivalent to [always @(*)], but is preferred in 
SystemVerilog.

The = in the [always] statement is called a blocking assignment,
in contrast to the <= nonblocking assignment. In System-
Verilog, it is good practice to use blocking assignments for
combinational logic and nonblocking assignments for sequential
logic.
*/