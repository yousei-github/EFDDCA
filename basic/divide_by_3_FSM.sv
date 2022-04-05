module divide_by_3_FSM(input logic clk,
																							input logic reset,
																							output logic y);
	typedef enum logic [1:0] {S0, S1, S2} state_type;
	state_type state, nextstate;
	// state register
	always_ff @(posedge clk, posedge reset)
		if (reset) state <= S0;
		else state <= nextstate;
	// next state logic
	always_comb
		case (state)
		S0: nextstate = S1;
		S1: nextstate = S2;
		S2: nextstate = S0;
		default: nextstate = S0;
		endcase
	// output logic
	assign y = (state== S0);
endmodule

/*
The [typedef] statement defines [state_type] to be a two-bit
[logic] value with three possibilities: S0, S1, or S2. state and
nextstate are [state_type] signals.

The enumerated encodings default to numerical order:
S0 = 00, S1 = 01, and S2 = 10. The encodings can be explicitly
set by the user; however, the synthesis tool views them as suggestions,
not requirements. For example, the following snippet
encodes the states as 3-bit one-hot values:

typedef enum logic [2:0] {S0 = 3'b001, S1 = 3'b010, S2 = 3'b100}
statetype;

Notice how a [case] statement is used to define the state
transition table. Because the next state logic should be combinational,
a [default] is necessary even though the state 2'b11 should never arise.

The output, y, is 1 when the state is S0. The equality comparison a == b 
evaluates to 1 if a equals b and 0 otherwise. The inequality comparison 
a != b does the inverse, evaluating to 1 if a does not equal b.
*/