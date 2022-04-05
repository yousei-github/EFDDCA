module testbench_11
();
	logic signed [32-1:0] a; 
	logic signed [32-1:0] y;
	logic [5-1:0] shamt;
	logic [3-1:0] control;
	int i;
	// instantiate device under test (dut)
	//arithmetic_shifter_right_32 dut(a, shamt, y);
	
	funnel_shifter_32 dut(a, shamt, control, y);
	// apply inputs one at a time
	initial 
		begin
			
			a = 32'hFE000021; 
			// test >>
			control = 3'b000;
			for(i=0;i<=32;i++)
				begin: testloop_1
					shamt = i; #10;
					assert (y === a >>shamt) else $error("%d failed.", i);
				end
			// test <<
			control = 3'b100;
			for(i=0;i<=32;i++)
				begin: testloop_2
					shamt = i; #10;
					assert (y === a <<shamt) else $error("%d failed.", i);
				end
			// test >>>
			control = 3'b001;
			for(i=0;i<=32;i++)
				begin: testloop_3
					shamt = i; #10;
					assert (y === a >>>shamt) else $error("%d failed.", i);
				end
			// test <<<
			control = 3'b101;
			for(i=0;i<=32;i++)
				begin: testloop_4
					shamt = i; #10;
					assert (y === a <<<shamt) else $error("%d failed.", i);
				end
			
			// test ROR
			control = 3'b010;
			for(i=0;i<=32;i++)
				begin: testloop_5
					shamt = i; #10;
					//assert (y === a >>>shamt) else $error("%d failed.", i);
				end
			
			// test ROL
			control = 3'b011;
			for(i=0;i<=32;i++)
				begin: testloop_6
					shamt = i; #10;
					//assert (y === a >>>shamt) else $error("%d failed.", i);
				end
			
			// test <<
			control = 3'b110;
			for(i=0;i<=32;i++)
				begin: testloop_7
					shamt = i; #10;
					assert (y === a <<shamt) else $error("%d failed.", i);
				end
			// test <<<
			control = 3'b111;
			for(i=0;i<=32;i++)
				begin: testloop_8
					shamt = i; #10;
					assert (y === a <<shamt) else $error("%d failed.", i);
				end
				
		end
endmodule