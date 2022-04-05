module testbench_12
#(parameter width = 16)
();
	logic [width-1:0] a, b; 
	logic [2*width-1:0] y;
	int i, j;
	// instantiate device under test (dut)
	//multiplier_4x4_unsign dut(a, b, y);
	
	multiplier_16x16_unsign dut(a, b, y);
	// apply inputs one at a time
	initial 
		begin
			// 4 bit unsigned: 0~15
			//a = 4'd0; b = 4'd0; 
			a = 16'd0; b = 16'd0;
			// test
			for(i=0; i<2**5; i++)
				begin: testloop_1
					for(j=0; j<2**5; j++)
						begin: testloop_2
							a = i; b = j; #10;
							assert (y === a * b) else $error("%d-%d failed.", i, j);
						end
				end
				
				
		end
endmodule
