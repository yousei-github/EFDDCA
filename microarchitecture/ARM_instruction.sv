/*
	ARM instruction 
	module name:
	1) arm_example
*/

module arm_example
#(parameter width = 32)
(
	input logic clk,
	input logic reset,
	// used for testbench
	input logic download_data_we,
	input logic [width-1:0] download_data_addr, download_data,
	output logic [32-1:0] registers[16-1:0]
	// end of used for testbench
);
	
	logic [width-1:0] pc, pc_next, pc_plus4, pc_plus8;
	logic [width-1:0] instr;
	logic we3;	// register file write enable
	logic [4-1:0] ra1, ra2;
	logic [width-1:0] rd1, rd2;
	logic [width-1:0] extimm;
	logic [2-1:0] alu_control;
	logic [width-1:0] alu_result;
	logic n, z, c, v;
	logic we;	// memory write enable
	logic [width-1:0] read_data;
	logic pc_src;
	logic temp, temp2;
	logic [2-1:0] immsrc;	// 00 for data-processing, 01 for LDR or STR, 10 for branch
	logic [4-1:0] alu_flags;	// n: alu_flags[3], z: alu_flags[2], c: alu_flags[1], v: alu_flags[0]
	logic memtoreg;	// 0 for dataprocessing, 1 for LDR
	logic [width-1:0] result;
	logic [2-1:0] regsrc;	// 00 for data-processing, 01 for STR, 1x for branch
	logic alusrc;	// 0 for register file, 1 for immediates
	logic [width-1:0] srcb;
	// used for testbench
	logic we_temp;
	logic [width-1:0] alu_result_temp;
	logic [width-1:0] writedata;
	// end of used for testbench
	
	flip_flop_asyn_reset_parameter #(width) pc_reg(clk, reset, pc_next, pc);
	
	rom_232x32 instruction_mem(pc, instr);
	
	mux_2_input_parameter #(4) mux_ra1(instr[19:16], 4'd15, regsrc[1], ra1);
	mux_2_input_parameter #(4) mux_ra2(instr[3:0], instr[15:12], regsrc[0], ra2);
	
	// [1] Normal code
	//register_file_32 reg_file(clk, reset, we3, ra1, ra2, instr[15:12], result, pc_plus8, rd1, rd2);
	// [2] used for testbench to watch the register file
	register_file_32 reg_file(clk, reset, we3, ra1, ra2, instr[15:12], result, pc_plus8, rd1, rd2, registers[15-1:0]);
	assign registers[16-1] = pc;  // watch R15(PC)
	// end for [2]
	
	// data-processing instructions use only an 8-bit immediate rather than a 12-bit immediate
	extension_unit extent(instr[23:0], immsrc, extimm);
	
	mux_2_input_parameter #(width) mux_srcb(rd2, extimm, alusrc, srcb);
	
	alu_4f_32 alu(rd1, srcb, alu_control, alu_result, alu_flags[3], alu_flags[2], alu_flags[1], alu_flags[0]);
	
	// [1] Normal code
	//ram_2nxm #(width, width) data_mem(clk, we, alu_result, rd2, read_data);
	// [2] used for testbench to initialize the data memory
	mux_2_input_parameter #(1) mux_da1(we, 1'b1, download_data_we, we_temp);
	mux_2_input_parameter #(width) mux_da2(alu_result, download_data_addr, download_data_we, alu_result_temp);
	mux_2_input_parameter #(width) mux_da3(rd2, download_data, download_data_we, writedata);
	
	ram_2nxm #(width, width) data_mem(clk, we_temp, alu_result_temp, writedata, read_data);
	// end for [2]
	
	
	mux_2_input_parameter #(width) mux_memtoreg(alu_result, read_data, memtoreg, result);
	
	prefix_adder_32 pc_add1(pc, 32'h04, 1'b0, pc_plus4, temp);
	prefix_adder_32 pc_add2(pc_plus4, 32'h04, 1'b0, pc_plus8, temp2);
	
	mux_2_input_parameter #(width) mux_pc(pc_plus4, result, pc_src, pc_next);
	
	// Single-cycle control unit
	control_unit module1(clk, reset, instr[31:28], instr[27:26], instr[25:20], instr[15:12], alu_flags,
																				pc_src, we3, we, memtoreg, alusrc, immsrc, regsrc, alu_control);
	
endmodule



module main_decoder
(
	input logic [2-1:0] op,
	input logic funct_5, funct_0,
	output logic regw, alusrc, memw, memtoreg,
	output logic [2-1:0] regsrc, immsrc,
	output logic aluop, branch
);
	logic [4-1:0] a;
	logic [10-1:0] temp;
	
	assign a = {op, funct_5, funct_0};
	
	always_comb
		casez(a)
			// Data_processing with register offset
			4'b00_0?:	temp = 10'b0_0_0_0_xx_1_00_1; 
			//4'b00_0?:	temp = 10'b0_0_0_0_00_1_00_1; 
			// Data_processing with immediate offset
			4'b00_1?:	temp = 10'b0_0_0_1_00_1_0x_1; 
			//4'b00_1?:	temp = 10'b0_0_0_1_00_1_00_1; 
			// STR
			4'b01_?0:	temp = 10'b0_x_1_1_01_0_01_0; 
			//4'b01_?0:	temp = 10'b0_0_1_1_01_0_01_0; 
			// LDR
			4'b01_?1:	temp = 10'b0_1_0_1_01_1_0x_0; 
			//4'b01_?1:	temp = 10'b0_1_0_1_01_1_00_0; 
			// B
			4'b10_??:	temp = 10'b1_0_0_1_10_0_1x_0; 
			//4'b10_??:	temp = 10'b1_0_0_1_10_0_10_0; 
			default: 		temp = 10'b0_0_0_0_00_0_00_0; 
		endcase
	
	assign branch = temp[9];
	assign memtoreg = temp[8];
	assign memw = temp[7];
	assign alusrc = temp[6];
	assign immsrc = temp[5:4];
	assign regw = temp[3];
	assign regsrc = temp[2:1];
	assign aluop = temp[0];
	
endmodule


module alu_decoder
(
	input logic aluop,	// 0: Not Data_processing; 1: Data_processing
	input logic [4:1] funct_41,	// cmd
	input logic funct_0,	// S
	output logic [2-1:0] alu_control,
	// flagw[1] for updating N and Z (Flags3:2), and flagw[0] for updating C and V
	output logic [2-1:0] flagw
);
	logic [6-1:0] a;
	logic [4-1:0] temp;
	
	assign a = {aluop, funct_41, funct_0};
	
	// Note that ADD and SUB update all flags, whereas AND and ORR only update the N and Z flags
	always_comb
		casez(a)
			// it is not Data_processing
			6'b0_????_?:	temp = 4'b00_00; 
			// ADD Data_processing
			6'b1_0100_0:	temp = 4'b00_00; 
			// ADD Data_processing with set flag
			6'b1_0100_1:	temp = 4'b00_11; 
			// SUB Data_processing
			6'b1_0010_0:	temp = 4'b01_00; 
			// SUB Data_processing with set flag
			6'b1_0010_1:	temp = 4'b01_11; 
			// AND Data_processing
			6'b1_0000_0:	temp = 4'b10_00; 
			// AND Data_processing with set flag
			6'b1_0000_1:	temp = 4'b10_10; 
			// OR Data_processing
			6'b1_1100_0:	temp = 4'b11_00; 
			// OR Data_processing with set flag
			6'b1_1100_1:	temp = 4'b11_10; 
			default: 	temp = 4'b00_00; 
		endcase
	
	assign alu_control = temp[3:2];
	assign flagw = temp[1:0];
	
endmodule

module pc_logic
(
	input logic [4-1:0] rd,
	input logic [2-1:0] op,
	input logic funct_0, branch,
	output logic pcs
);
	// for LDR with writing R15 or Branch
	assign pcs = ((rd==4'd15)&(op==2'b01)&(funct_0==1'b1)) | branch;
	
endmodule


module decoder
(
	input logic [2-1:0] op,
	input logic [6-1:0] funct,
	input logic [4-1:0] rd,
	output logic [2-1:0] flagw,
	output logic pcs, regw, memw,
	output logic memtoreg, alusrc,
	output logic [2-1:0] immsrc, regsrc, alu_control
);
	logic branch, aluop;
	
	pc_logic module1(rd, op, funct[0], branch, pcs);
	
	main_decoder module2(op, funct[5], funct[0], regw, alusrc, memw, memtoreg, regsrc, immsrc, aluop, branch);
	
	alu_decoder module3(aluop, funct[4:1], funct[0], alu_control, flagw);
	
endmodule


module condition_check
(
	input logic [4-1:0] cond,
	input logic n, z, c, v,
	output logic condex
);
	
	always_comb
		case(cond)
			// EQ: Equal (z)
			4'b0000: condex = z;
			// NE: Not equal (~z)
			4'b0001: condex = ~z;
			// CS/HS: Carry set / unsigned higher or same (c)
			4'b0010: condex = c;
			// CC/LO: Carry clear / unsigned lower (~c)
			4'b0011: condex = ~c;
			// MI: Minus / negative (n)
			4'b0100: condex = n;
			// PL: Plus / positive or zero (~n)
			4'b0101: condex = ~n;
			// VS: Overflow / overflow set (v)
			4'b0110: condex = v;
			// VC: No overflow / overflow clear (~v)
			4'b0111: condex = ~v;
			// HI: Unsigned higher (~z&c)
			4'b1000: condex = ((~z)&c);
			// LS: Unsigned lower or same (z|~c)
			4'b1001: condex = (z|(~c));
			// GE: Signed greater than or equal (~(n^v))
			4'b1010: condex = (~(n^v));
			// LT: Signed less than (n^v)
			4'b1011: condex = (n^v);
			// GT: Signed greater than (~z)&(~(n^v))
			4'b1100: condex = ((~z)&(~(n^v)));
			// LE: Signed less than or equal z|(n^v)
			4'b1101: condex = (z|(n^v));
			// AL: Always / unconditional
			4'b1110: condex = 1'b1;
			default: condex = 1'b0;
		endcase
	
endmodule


module condition_logic
(
	input logic clk,
	input logic reset,
	input logic [4-1:0] cond,
	input logic [4-1:0] aluflags,	// n, z, c, v
	input logic pcs, regw, memw,
	// flagw[1] for updating N and Z (Flags3:2), and flagw[0] for updating C and V
	input logic [2-1:0] flagw,
	output logic pcsrc, regwrite, memwrite
);
	logic [2-1:0] flagwrite;
	logic condex;
	logic [4-1:0] flags, flags_next;
	
	assign flagwrite[1] = flagw[1] & condex;
	assign flagwrite[0] = flagw[0] & condex;
	
	// CPSR (Current program status register)
	flip_flop_asyn_reset_parameter #(2) reg_alu1(clk, reset, flags_next[3:2], flags[3:2]);
	flip_flop_asyn_reset_parameter #(2) reg_alu2(clk, reset, flags_next[1:0], flags[1:0]);
	
	mux_2_input_parameter #(2) mux_alu1(flags[3:2], aluflags[3:2], flagwrite[1], flags_next[3:2]);
	mux_2_input_parameter #(2) mux_alu2(flags[1:0], aluflags[1:0], flagwrite[0], flags_next[1:0]);
	
	condition_check cc_module(cond, flags[3], flags[2], flags[1], flags[0], condex);
	
	assign pcsrc = pcs & condex;
	assign regwrite = regw & condex;
	assign memwrite = memw & condex;
	
endmodule



module control_unit
(
	input logic clk,
	input logic reset,
	input logic [4-1:0] cond,
	input logic [2-1:0] op,
	input logic [6-1:0] funct,
	input logic [4-1:0] rd,
	input logic [4-1:0] aluflags,
	output logic pcsrc, regwrite, memwrite,
	output logic memtoreg, alusrc,
	output logic [2-1:0] immsrc, regsrc, alu_control
);
	logic [2-1:0] flagw;
	logic pcs, regw, memw;
	
	decoder module1(op, funct, rd, flagw, pcs, regw, memw, memtoreg, alusrc, immsrc, regsrc, alu_control);
	
	condition_logic module2(clk, reset, cond, aluflags, pcs, regw, memw, flagw, pcsrc, regwrite, memwrite);
	
endmodule
