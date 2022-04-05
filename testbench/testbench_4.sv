module testbench_4
#(parameter width = 3)
();
	logic [width-1:0] a, b, s;
	logic cin, cout;
	// instantiate device under test (dut)
	ripple_carry_adder_parameter  #(width) dut(a, b, cin, s, cout);
	// apply inputs one at a time
	initial 
		begin
			a = 0; b = 0; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("000 failed.");
			a = 0; b = 0; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("001 failed.");
			a = 1; b = 1; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("110 failed.");
			a = 7; b = 7; cin = 0; #10;
			assert ({cout, s} === a+b+cin) else $error("011 failed.");
			a = 1; b = 7; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("101 failed.");
			a = 1; b = 1; cin = 1; #10;
			assert ({cout, s} === a+b+cin) else $error("111 failed.");
		end
endmodule