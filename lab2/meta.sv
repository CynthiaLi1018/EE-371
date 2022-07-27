// Cynthia Li
// 4/20/21
// EE 371 LAB2 TASK1

// Module meta takes an input, pass it through
// two DFF to prevent metastability.
module meta (clk, in, out);
	input logic clk, in;
	output logic out;
	logic temp;
	
	// the following passes in through 2 DFF
	always_ff @(posedge clk)
			temp <= in;
	always_ff @(posedge clk)
			out <= temp;
endmodule

module meta_testbench();
	logic clk, in;
	logic out;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end
	
	meta dut (.*);
	
	initial begin
	in <= 1; @(posedge clk);
	in <= 0; @(posedge clk);
	in <= 1; repeat(3)@(posedge clk);
	in <= 0; repeat(3)@(posedge clk);
	$stop; // End the simulation.
	end
endmodule
	
	