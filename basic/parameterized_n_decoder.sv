module decoder_n_input_parameter
#(parameter N = 3)
(
	input logic [N-1:0] a,
	output logic [2**N-1:0] y
);
	always_comb
		begin
			y = 0;
			y[a] = 1;
		end
endmodule

/*
2**N indicates 2^N.
*/