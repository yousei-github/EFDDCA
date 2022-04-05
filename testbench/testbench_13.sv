module testbench_13
#(parameter width = 32)
();
	logic [width-1:0] a, b; 
	logic [width-1:0] q, r;
	int i, j;
	// instantiate device under test (dut)

	//divider_4_unsign dut(a, b, q, r);
	//divider_4_unsign_2 dut(a, b, q, r);
	divider_32_unsign dut(a, b, q, r);
	// apply inputs one at a time
	initial 
		begin
			// 4 bit unsigned: 0~15
			//a = 4'd0; b = 4'd0; 
			a = 32'd0; b = 32'd0; 
			// test
			for(i=0; i<2**(8); i++)
				begin: testloop_1
					for(j=1; j<2**(8); j++)
						begin: testloop_2
							a = i; b = j; #10;
							assert ((q === a / b) && (r === a % b)) else $error("%d-%d failed.", i, j);
						end
				end

		end
endmodule

