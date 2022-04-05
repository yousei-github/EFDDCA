module testbench_3();
	logic clk, reset;
	logic a, b, c, y, y_expected;
	logic [31:0] vectornum, errors;
	logic [3:0] testvectors[10000:0];
	// instantiate device under test
	sillyfunction dut(a, b, c, y);
	// generate clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	// at start of test, load vectors
	// and pulse reset
	initial
		begin
			$readmemb("example.tv", testvectors);
			vectornum = 0; errors = 0;
			reset = 1; #27; reset = 0;
		end
	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1; {a, b, c, y_expected} = testvectors[vectornum];
		end
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) 
			begin // skip during reset
				if (y !== y_expected) 
					begin // check result
						$display("Error: inputs = %b", {a, b, c});
						$display(" outputs = %b (%b expected)", y, y_expected);
						errors = errors + 1;
					end
				vectornum = vectornum + 1;
				if (testvectors[vectornum] === 4'bx) 
					begin
						$display("%d tests completed with %d errors",
						vectornum, errors);
						$finish;
					end
			end
endmodule

/*
[$readmemb] reads a file of binary numbers into the testvectors
array. [$readmemh] is similar but reads a file of hexadecimal
numbers.

This process repeats until there are no more valid test
vectors in the [testvectors] array. [$finish] terminates the
simulation.

Note that even though the SystemVerilog module supports
up to 10,001 test vectors, it will terminate the simulation
after executing the eight vectors in the file.
*/