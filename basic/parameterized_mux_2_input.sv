module mux_2_input_parameter
#(parameter width = 32)
(
	input logic [width-1:0] d0, d1,
	input logic s,
	output logic [width-1:0] y
);
	assign y =s ? d1 : d0;
	
endmodule