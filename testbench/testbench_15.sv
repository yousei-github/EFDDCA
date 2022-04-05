module testbench_15
#(parameter width = 4)
();
	logic clk, reset, load, sin, sout;
	logic [width-1:0] d, q;
	int i, j;
	// instantiate device under test (dut)

	//shift_register_parameter #(width) dut(clk, reset, load, sin, d, q, sout);
	Johnson_counter_parameter #(width) dut(clk, reset, q, sout);
	// generate clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// apply inputs one at a time
	initial 
		begin
			load = 0; d = 0;
			reset = 1; #15; reset = 0;
//			
//			sin = 1'b1; #80;
//			
//			d = 8'b1001_0110;
//			load = 1'b1; #10; load = 0; 
//			#80;
			
			#90;
			$stop;
		end
endmodule

