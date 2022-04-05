module ripple_carry_adder_parameter 
#(parameter width = 32)
(
	input logic [width-1:0] a, b,
	input logic cin,
	output logic [width-1:0] s,
	output logic cout
);
	logic [width:0] temp;

	assign temp[0] = cin;
	
	genvar i;
	generate
		for(i=0; i<width; i=i+1) 
			begin: forloop
				fulladder_2 cpa(a[i], b[i], temp[i], s[i], temp[i+1]);
			end
	endgenerate
	
	assign cout = temp[width];
	
endmodule