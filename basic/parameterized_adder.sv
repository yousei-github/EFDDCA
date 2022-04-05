module adder_parameter 
#(parameter width = 32)
(
	input logic [width-1:0] a, b,
	input logic cin,
	output logic [width-1:0] s,
	output logic cout
);
	assign {cout, s} = a + b + cin;
endmodule
