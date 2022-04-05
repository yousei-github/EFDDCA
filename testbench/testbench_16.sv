module testbench_16
#(parameter width = 32)
();
	logic clk, reset;
	logic download_data_we;
	logic [width-1:0] download_data_addr, download_data;
	logic [32-1:0] registers[16-1:0];

	// instantiate device under test (dut)

	arm_example #(width) dut(clk, reset, download_data_we, download_data_addr, download_data, registers);
	// generate clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// apply inputs one at a time
	initial 
		begin
			reset = 1; download_data_we = 1;
			// for address 0
			download_data_addr = 32'd0;
			download_data = 32'd1;
			#5
			// for address 1
			download_data_addr = 32'd1;
			download_data = 32'd2;
			#10
			// for address 2
			download_data_addr = 32'd2;
			download_data = 32'd3;
			#10
			// for address 3
			download_data_addr = 32'd3;
			download_data = 32'd4;
			#10	// 35
			reset = 0; download_data_we = 0;
			
			
			// initialize the data memory
			
			
			
//			
//			sin = 1'b1; #80;
//			
//			d = 8'b1001_0110;
//			load = 1'b1; #10; load = 0; 
//			#80;
			
			#200;
			$stop;
		end
		
endmodule

