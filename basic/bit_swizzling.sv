module bitswizzling(input logic [2:0] c, d,
														 output logic [8:0] y);
	assign y = {c[2:1], {3{d[0]}}, c[0], 3'b101};
endmodule

/*
Often it is necessary to operate on a subset of a bus or to concatenate
(join together) signals to form busses. These operations are collectively
known as bit swizzling.

The { } operator is used to concatenate busses. {3{d[0]}}
indicates three copies of d[0].

*/