/*
	extension unit
	module name:
	1) sign_extension_unit_parameter
	2) zero_extension_unit_parameter
	3) extension_unit
*/

module sign_extension_unit_parameter
#(parameter width = 4, width_2 = 8)
(
	input logic [width-1:0] a,
	output logic [width_2-1:0] y
);
	assign y[width-1:0] = a;
	
	genvar i;
	
	generate
		for(i=width; i<width_2; i=i+1) 
			begin: forloop_1
				assign	y[i] = a[width-1];
			end
	
	endgenerate
	
endmodule


module zero_extension_unit_parameter
#(parameter width = 4, width_2 = 8)
(
	input logic [width-1:0] a,
	output logic [width_2-1:0] y
);
	assign y[width-1:0] = a;
	
	genvar i;
	
	generate
		for(i=width; i<width_2; i=i+1) 
			begin: forloop_1
				assign	y[i] = 1'b0;
			end
	
	endgenerate
	
endmodule

// Note: parameter width should be less than width_2
// Funtion: when s is 00, y is zero-extended from a[8-1:0],
// when s is 01, y is zero-extended from a[12-1:0]
// when s is 10, y is sign-extended from a[24-1:0] and multiplied by 4
module extension_unit
(
	input logic [24-1:0] a,
	input logic [2-1:0] s,
	output logic [32-1:0] y
);
	
	always_comb
		case(s)
			2'b00: y = {24'd0, a[8-1:0]};
			2'b01: y = {20'd0, a[12-1:0]};
			2'b10: y = {{6{a[24-1]}}, a[24-1:0], 2'b00};
			default: y = 32'dx;
		endcase
	
endmodule

