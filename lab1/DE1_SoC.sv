// Cynthia Li
// 4/12/2021
// EE 371
// Lab1 Task #4

// DE1_SoC is the top entity module that specifies the I/Os of DE-1 SoC board and simulates
// a single entry parking lot with a default 5 maximum capacity. It has a 50mHz CLOCK_50 as
// input, and six 7-bit ouput HEX5 to HEX0 and 34-bit ouput GPIO_0. It takes three inputs
// from GPIO_0,outpus to 2 LED light on the breadboard by GPIO_0. HEX1 and HEX0 will display
// the decimal count of cars in the parking lot, HEX5 to HEX2(HEX1) will display whether the
// parking lot is full or clear as "FULL" and "CLEAr"
module DE1_SoC #(MAX = 5'b00101) (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	inout logic [33:0] GPIO_0;
	
	// assign GPIO_0[26] (left LED) to GPIO_0[14] (left switch (a))
	assign GPIO_0[26] = GPIO_0[14];
	// assign GPIO_0[27] (right LED) to GPIO_0[18] (right switch (b))
	assign GPIO_0[27] = GPIO_0[18];
	
	logic exit, enter;
	logic full, clear;
	logic [4:0] count;
	
	// gate takes input a, b, reset from left, right and middle switch on the breadboard. It outputs
	// the car's enter/exit status to enter and exit.
	gate parking (.reset(GPIO_0[10]), .clk(CLOCK_50), .a(GPIO_0[14]), .b(GPIO_0[18]), .enter, .exit);
	
	// counter count_cars takes input reset from middle switch the breadboard and input enter and exit
	// from the output of gate; it outputs 5-bit value to count, and update parking lot's full and
	// clear status to full and clear.
	counter #(MAX) count_cars (.reset(GPIO_0[10]), .clk(CLOCK_50), .inc(enter), .dec(exit), 
										.count, .full, .clear);
	
	// display occupancy_display takes input reset from the middle switch on the breadboard, 5-bit input
	// count from counter count_cars, input full and clear from count_cars; it outputs the decimal
	// occupancy to HEX1 and HEX0, and outputs full and clear status to HEX5 to HEX2(HEX1)
	display occupancy_display (.reset(GPIO_0[10]), .count, .full, .clear,
										.HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);
endmodule


module DE1_SoC_testbench();
	
	logic 	   CLOCK_50; // 50MHz clock.
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [33:0] GPIO_0;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .GPIO_0);
	
	// Set up the clock. 
	parameter CLOCK_PERIOD=100; 
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	logic [2:0] SW;
	logic [1:0] LEDR;
	
	assign GPIO_0[10] = SW[2];
	assign GPIO_0[14] = SW[1];
	assign GPIO_0[18] = SW[0];
	
	assign LEDR[1] = GPIO_0[26];
	assign LEDR[0] = GPIO_0[27];
	
	initial begin
		SW[2] <= 1;						@(posedge CLOCK_50);
		SW[2] <= 0;						@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); 
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "CLEAr0"
		
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////01"
		
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "/////02"
		
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////03"
		
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////04"
		
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "FULL05" (reach max)
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "FULL05" (stay max)
		
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50); 
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////04"
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////03"
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////02"
			
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "////01"
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "CLEAr0" (reach 0)
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50); // "CLEAr0" (stay 0)
		
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 1; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 1;		@(posedge CLOCK_50);
		SW[1] <= 0; SW[0] <= 0;		@(posedge CLOCK_50);
      $stop; // End the simulation.
   end
endmodule