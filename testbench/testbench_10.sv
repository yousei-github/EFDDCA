module testbench_10
#(parameter width = 32)
();
	logic [width-1:0] a, b, result;
	logic [2-1:0] control;
	logic n, z, c, v;
	// instantiate device under test (dut)
	alu_4f_32 dut(a, b, control, result, n, z, c, v);
	// apply inputs one at a time
	initial 
		begin
			a = 687; b = 458_125; control = 2'b00; #10;
			assert (n === 1'b0) else $error("1 failed.");
			a = 548; b = 548; control = 2'b01; #10;
			assert (z === 1'b1) else $error("2 failed.");
			a = 4_294_967_295; b = 1; control = 2'b00; #10;
			assert (c === 1'b1) else $error("3 failed.");
			a = 2_147_483_647; b = 501; control = 2'b00; #10;
			assert (v === 1'b1) else $error("4 failed.");
			a = 4_294_967_294; b = 2_147_483_647; control = 2'b01; #10;
			assert (v === 1'b1) else $error("5 failed.");
			
		end
endmodule