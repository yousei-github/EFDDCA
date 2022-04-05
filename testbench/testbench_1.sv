module testbench_1
#(parameter width = 8)
();
	//logic a, b, c, y;
	logic [width-1:0] a, b;
	logic c;
	// instantiate device under test (dut)
	//sillyfunction dut(a, b, c, y);
	
	comparator_signed_parameter #(8) cmp(a, b, c);
	// apply inputs one at a time
	initial 
		begin
//			a = 0; b = 0; c = 0; #10;
//			c = 1; #10;
//			b = 1; c = 0; #10;
//			c = 1; #10;
//			a = 1; b = 0; c = 0; #10;
//			c = 1; #10;
//			b = 1; c = 0; #10;
//			c = 1; #10;
			a = -128; b = 127; #10;
			a = 127; b = -128; #10;
			a = 8'b0110_1111; b = 8'b0101_1000; #10;
			a = 8'b1010_1111; b = 8'b1111_1010; #10;
			
			
		end
endmodule

/*
The [initial] statement executes the statements in its body at
the start of simulation. In this case, it first applies the input
pattern 000 and waits for 10 time units. It then applies 001
and waits 10 more units, and so forth until all eight possible
inputs have been applied. initial statements should be used
only in testbenches for simulation, not in modules intended
to be synthesized into actual hardware. Hardware has no
way of magically executing a sequence of special steps when
it is first turned on.
*/