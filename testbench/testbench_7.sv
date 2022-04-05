module testbench_7
#(parameter width = 16)
();
	logic [width-1:0] a, b, s;

	// instantiate device under test (dut)
	//subtractor_ripple_carry_parameter #(width) dut(a, b, s);
	//subtractor_carry_lookahead_parameter #(width) dut(a, b, s);
	subtractor_prefix_adder_16 dut(a, b, s);
	// apply inputs one at a time
	initial 
		begin
			a = 980; b = 722; #10;
			assert (s === a-b) else $error("1 failed.");
			a = 0; b = 1; #10;
			assert (s === a-b) else $error("2 failed.");
			a = 100; b = 50; #10;
			assert (s === a-b) else $error("3 failed.");
			a = 10001; b = 2; #10;
			assert (s === a-b) else $error("4 failed.");
			a = 65535; b = 5; #10;
			assert (s === a-b) else $error("5 failed.");
			
		end
endmodule
