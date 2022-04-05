module logic_gates(input logic [3:0] a, b,
										output logic [3:0] y1, y2, y3, y4, y5);
	/* five different two-input logic
	gates acting on 4-bit busses */
	assign y1 = a & b; 		// AND
	assign y2 = a | b; 			// OR
	assign y3 = a ^ b;			// XOR
	assign y4 = ~(a & b); // NAND
	assign y5 = ~(a | b); 	// NOR
endmodule

/*
~, ^, and | are examples of SystemVerilog operators, whereas
a, b, and y1 are operands. A combination of operators and
operands, such as a & b, or ~(a | b), is called an expression.
A complete command such as assign y4 = ~(a & b); is called
a statement.

assign out = in1 op in2; is called a continuous assignment
statement. Continuous assignment statements end with
a semicolon. Anytime the inputs on the right side of the = in
a continuous assignment statement change, the output on the
left side is recomputed. Thus, continuous assignment statements
describe combinational logic.

*/