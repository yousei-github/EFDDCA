module testbench_9
#(parameter width = 3)
();
	/* way 1
	logic [width-1:0] a, b;
	logic equal, unequal, 
	less_then, less_then_equal, 
	greater_then, greater_then_equal;*/
	
	logic [32-1:0] a, b;
	logic n, z, c, v;
	logic hs, ls, hi, lo;
	logic ge, le, gt, lt;
	logic [2-1:0] control;
	logic [32-1:0] result;
	// instantiate device under test (dut)
	/* way 1
	comparator_parameter #(width) dut(a, b, equal, unequal, 
	less_then, less_then_equal, greater_then, greater_then_equal);*/
	
	alu_4f_32 alu(a, b, control, result, n, z, c, v);
	comparator_unsigned_alu cmp_unsign(n, z, c, v, hs, ls, hi, lo);
	comparator_signed_alu cmp_sign(n, z, c, v, ge, le, gt, lt);
	// apply inputs one at a time
	initial 
		begin
			/* way 1
			a = 3'b000; b = 3'b000; #10;
			assert (equal === 1'b1) else $error("1 failed.");
			a = 3'b100; b = 3'b000; #10;
			assert (unequal === 1'b1) else $error("2 failed.");
			a = 3'b010; b = 3'b011; #10;
			assert (less_then === 1'b1) else $error("3 failed.");
			// test for signed number (-4 and 3)
			a = 3'b100; b = 3'b011; #10;
			assert (less_then === 1'b1) else $error("4 failed.");
			
			a = 3'b100; b = 3'b100; #10;
			assert (less_then_equal === 1'b1) else $error("5 failed.");
			a = 3'b100; b = 3'b010; #10;
			assert (greater_then === 1'b1) else $error("6 failed.");
			a = 3'b100; b = 3'b010; #10;
			assert (greater_then_equal === 1'b1) else $error("7 failed.");
			a = 3'b010; b = 3'b010; #10;
			assert (greater_then_equal === 1'b1) else $error("8 failed.");*/
			control = 2'b01; 
			a = 255; b = 25; #10;
			a = 752_456; b = 498; #10;
			a = 457; b = 498; #10;
			a = 0; b = 0; #10;
			
			a = 32'h8000_0000; b = 32'h7fff_ffff; #10;
			
			a = 32'h8000_abcd; b = 32'h8fff_ffff; #10;
			a = 32'h8000_abcd; b = 32'h8000_00ff; #10;
			a = 32'h8000_00cd; b = 32'h80f0_00ff; #10;
			
			
			
			
			
			
			
			
			
		end
endmodule