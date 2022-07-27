// Cynthia Li
// 4/12/2021
// EE 371
// Lab1 Task#2

// counter is a parameterized module with parameter MAX defaultly set to binary 5, it takes 
// two 1-bit inputs, inc (increment) and dec (decrement) and outputs count (the binary number
// of cars in the simulated parking lot), full (whether current parking lot reaches maximum
// capacity), and clear (whether current parking lot is empty). counter will increment and
// decrement count based on inc and dec, but will never be greater than MAX or lower than 0,
// count will stay the same in that cases, it will update full to true when reaching MAX, and
// update clear to true when reaching 0. 
module counter #(parameter MAX=5'b00101) (reset, clk, inc, dec, count, full, clear);
	
	input logic reset, clk, inc, dec;
	output logic [4:0] count;
	output logic full, clear;
	
	// count, full, and clear is updated by the following DFF
	always_ff @(posedge clk) begin
		if (reset) begin  // initialization: set count to 0, full and clear to false
			count <= 5'b00000;
			full <= 1'b0;
			clear <= 1'b0;
			end
		else if (count == MAX & inc & ~dec) begin  // after reaching MAX, count stays the same
			count <= count;								 // full change to true 
			full <= 1'b1;
			clear <= 1'b0;
			end
		else if (count == 5'b00000 & ~inc & dec) begin  // after reaching 0, count stays the same
			count <= count;										// clear changes to true
			full <= 1'b0;
			clear <= 1'b1;
			end
		else if (inc & ~dec) begin  // normal increment: increment count
			count <= count + 5'b00001;
			full <= 1'b0;
			clear <= 1'b0;
			end
		else if (~inc & dec) begin  // normal decrement: decrement count
			count <= count - 5'b00001;
			full <= 1'b0;
			clear <= 1'b0;
			end
		else begin   // if (inc & dec | ~inc & ~dec), count, full, clear stay the same
			count <= count;
			full <= full;
			clear <= clear;
			end
	end 
endmodule

module counter_testbench();

	logic reset, clk, inc, dec;
	logic [4:0] count;
	logic full, clear;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	counter dut (.reset, .clk, .inc, .dec, .count, .full, .clear);
	
	initial begin
							@(posedge clk);
		reset <= 1;		@(posedge clk);
		reset <= 0;		@(posedge clk);
		inc = 0; dec = 0;	repeat(1)	@(posedge clk); // test case: inc = 0, dec = 0, 
																	 // expect count, full, clear stay the same
		inc = 1; dec = 1;	repeat(1)	@(posedge clk); // test case: inc = 1, dec = 1 (non-existing case)
																	 // expect count, full, clear stay the same
		inc = 1; dec = 0;	repeat(7)	@(posedge clk); // test case: continuous to increment to max
																	 // expect count increment to max, 
																	 // full change from 0 to 1 at the end
																	 // clear stay the same
		inc = 0; dec = 1;	repeat(8)	@(posedge clk); // test case: count decrease to 0
																	 // expect count decrease to 0;
																	 // full change stay 0;
																	 // clear change from 0 to 1 at the end
		$stop;
	end
endmodule
	
	