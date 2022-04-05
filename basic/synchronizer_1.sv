module synchronizer_1(input logic clk,
																					input logic d,
																					output logic q);
	logic n1;
	always_ff @(posedge clk)
		begin
		n1 <= d; // nonblocking
		q <= n1; // nonblocking
		end
endmodule

/*
Notice that the [begin/end] construct is necessary 
because multiple statements appear in the [always] 
statement. This is analogous to { } in C or Java.
*/