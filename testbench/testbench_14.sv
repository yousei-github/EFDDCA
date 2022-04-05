module testbench_14
#(parameter width = 32)
();
	logic clk, reset;
	logic [width-1:0] q;
	logic up;
	int i, j;
	// instantiate device under test (dut)

	//counter_parameter #(width) dut(clk, reset, q);
	//counter_32 dut(clk, reset, q);
	up_down_counter_32 dut(clk, reset, up, q);
	// generate clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// apply inputs one at a time
	initial 
		begin
			reset = 1; #15; reset = 0; up = 1;
			
			// test
//			for(i=0; i<2**(width); i++)
//				begin: testloop_1
//					assert (q === i) else $error("%d failed.", i);
//					#10;
//				end
			
			for(i=0; i<2**(4); i++)
				begin: testloop_1
					assert (q === i) else $error("%d failed.", i);
					#10;
				end
			up = 0; #200;
			
			$stop;
		end
endmodule

