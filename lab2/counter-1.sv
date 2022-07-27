// Cynthia Li
// 4/20/21
// EE 371 LAB2 TASK1

// module counter takes an input 50mHz clock and a reset signal
// and output a 5-bit value to addr_r. The value is updated from
// 0 to 31 as a counter and will start over afterwards. reset will
// let counter start over as wel.
module counter (clk, reset, addr_r);
	input logic clk, reset; // should be a slow clock with a 1s/ period
	output logic [4:0] addr_r;
	
	// the following defines when counter increment 
	// and when to start over
	always_ff @(posedge clk) begin
		if (reset) begin
			addr_r <= 0; // addr_r is initially set to 0
		end
		else begin
			if (addr_r < 31) // when not reaching the end
				addr_r <= addr_r + 1; // addr_r increment
			else 			  // when reaching the end
				addr_r <= 0;			 // addr_r start over
		end
	end
endmodule

module counter_testbench();
	logic CLOCK_50, reset;
	logic [4:0] addr_r;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	counter count (.clk(CLOCK_50), .reset, .addr_r);
	
	integer i;
	initial begin
		reset <= 1; 	@(posedge CLOCK_50);
		reset <= 0;		@(posedge CLOCK_50);
		repeat(34)		@(posedge CLOCK_50);
		$stop;
	end
endmodule
	
	
	