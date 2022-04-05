module testbench_2();
	logic a, b, c, y;
	// instantiate device under test
	sillyfunction dut(a, b, c, y);
	// apply inputs one at a time
	// checking results
	initial 
		begin
			a = 0; b = 0; c = 0; #10;
			assert (y === 1) else $error("000 failed.");
			c = 1; #10;
			assert (y === 0) else $error("001 failed.");
			b = 1; c = 0; #10;
			assert (y === 0) else $error("010 failed.");
			c = 1; #10;
			assert (y === 0) else $error("011 failed.");
			a = 1; b = 0; c = 0; #10;
			assert (y === 1) else $error("100 failed.");
			c = 1; #10;
			assert (y === 1) else $error("101 failed.");
			b = 1; c = 0; #10;
			assert (y === 0) else $error("110 failed.");
			c = 1; #10;
			assert (y === 0) else $error("111 failed.");
		end
endmodule

/*
The SystemVerilog [assert] statement checks if a specified condition
is true. If not, it executes the [else] statement. The
[$error] system task in the [else] statement prints an error message
describing the assertion failure. [assert] is ignored during
synthesis.
In SystemVerilog, comparison using == or != is effective
between signals that do not take on the values of x and z.
Testbenches use the === and !== operators for comparisons of
equality and inequality, respectively, because these operators
work correctly with operands that could be x or z.
*/