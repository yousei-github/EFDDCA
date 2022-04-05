module testbench_6
#(parameter width = 32)
();
	logic [width-1:0] a, b, s;
	logic cin, cout;
	// instantiate device under test (dut)
	//carry_lookahead_adder_parameter  #(width) dut(a, b, cin, s, cout);
	prefix_adder_32 dut(a, b, cin, s, cout);
	// apply inputs one at a time
	initial 
		begin
			a = 980; b = 722; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("1 failed.");
			a = 560; b = 0; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("2 failed.");
			a = 677; b = 6542; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("3 failed.");
			a = 444; b = 7; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("4 failed.");
			a = 4_294_967_295; b = 5412; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("5 failed.");
			a = 678; b = 99999; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("6 failed.");
		end
endmodule