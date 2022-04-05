module tristate(input logic [3:0] a,
													  input logic en,
													  output tri [3:0] y);
	assign y = en ? a : 4'bz;
endmodule

/*
Notice that y is declared as [tri] rather than [logic]. [logic] signals
can only have a single driver. Tristate busses can have multiple
drivers, so they should be declared as a [net]. Two types of nets
in SystemVerilog are called [tri] and [trireg]. Typically, exactly
one driver on a net is active at a time, and the net takes on that
value. 

If no driver is active, a [tri] floats (z), while a [trireg] retains the 
previous value. If no type is specified for an input or output, [tri] 
is assumed. Also note that a [tri] output from a module can be 
used as a [logic] input to another module.

SystemVerilog signal values are 0, 1, z, and x. SystemVerilog
constants starting with z or x are padded with leading z’s or
x’s (instead of 0’s) to reach their full length when necessary.
*/