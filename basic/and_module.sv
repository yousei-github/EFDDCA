/*
	and
	module name:
	1) and_8_input
	2) and_n_parameter
*/
module and_8_input
(
	input logic [7:0] a,
	output logic y
);
	assign y = &a;
	// &a is much easier to write than
	// assign y = a[7] & a[6] & a[5] & a[4] &
	//                 a[3] & a[2] & a[1] & a[0];
endmodule

/*
Analogous [reduction operators] exist for OR, XOR, NAND,
NOR, and XNOR gates. Recall that a multiple-input XOR 
performs parity, returning TRUE if an odd number of inputs are TRUE.

NAND:
	assign y = ~(& a);
NOR:
	assign y = ~(| a);
*/

module and_n_parameter
#(parameter width = 8)
(
	input logic [width-1:0] a,
	output logic y
);
	genvar i;
	logic [width-1:0] x;

	generate
		assign x[0] = a[0];
		for(i=1; i<width; i=i+1) 
			begin: forloop
				assign x[i] = a[i] & x[i-1];
			end
	endgenerate

	assign y = x[width-1];
endmodule: and_n_parameter

/*
The [for] statement loops thrugh i = 1, 2, … , width-1 to produce
many consecutive AND gates. The [begin ]in a [generate
for] loop must be followed by a : and an arbitrary label
(forloop, in this case).

HDLs also provide [generate] statements to produce a variable
amount of hardware depending on the value of a parameter. [generate]
supports [for] loops and [if] statements to determine how many of what
types of hardware to produce.
*/