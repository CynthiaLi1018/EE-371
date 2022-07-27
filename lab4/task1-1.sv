// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 1

// This module is the top level module that controls the bit counter's behavior on the FPGA
// board. It takes in 8 bit intput value from SW[7:0] that represent data to load, KEY[0] for
// reset, SW[9] for start signal, and CLOCK_50 for the counting operation. It outputs a 7 bit
// value to display the count on HEX0 and turns off the rest of HEX display. It also output 
// the status of the counting operation on LEDR[9].
module task1 (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	// the following defines the variables needed
	logic [7:0] A;
	logic reset, s;
	logic [3:0] result;	
	logic Ais0, a0, load, inc, shift;
	
	// the following specifies the input
	assign A = SW[7:0];
	
	// the following instantiates meta to process input to prevent metastability due to fast clock
	meta m1 (.clk(CLOCK_50), .in(~KEY[0]), .out(reset));
	meta m2 (.clk(CLOCK_50), .in(SW[9]), .out(s));
	
	// the following instantiates the control of bit counter
	counter_control CTRL (.clk(CLOCK_50), .reset, .s, .Ais0, .a0, .load, .inc, .shift, .done(LEDR[9]));
	// the following instantiates the datapath of bit counter
	counter_datapath DATAPATH (.clk(CLOCK_50), .reset, .A, .load, .inc, .shift, .Ais0, .a0, .result);
	// the following instantiates the HEX display for the bit counter
	counter_display hex_display (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .result);
endmodule

module task1_testbench();
	logic CLOCK_50; // 50MHz clock.
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // True when not pressed, False when pressed
	logic [9:0] SW;
	
	parameter CLK_Period = 100;
 	initial begin
 		CLOCK_50 <= 1'b0;
 		forever #(CLK_Period/2) CLOCK_50 <= ~CLOCK_50;
 	end
	
	logic clk;
	assign clk = CLOCK_50;
	
	task1 dut (.*);
	
	initial begin
		SW[7:0] <= 8'b10101010; 
		KEY[0] <= 1;                          @(posedge clk);
		KEY[0] <= 0;                          @(posedge clk);
		KEY[0] <= 1; SW[9] <= 0;              @(posedge clk);
		SW[9] <= 1;                 repeat(1) @(posedge clk);
		SW[9] <= 0; 			       repeat(9) @(posedge clk);
		SW[9] <= 1;                 repeat(1) @(posedge clk);
		SW[9] <= 0; 			       repeat(1) @(posedge clk);
		
		SW[7:0] <= 8'b00000101;
		KEY[0] <= 1;                          @(posedge clk);
		KEY[0] <= 0;                          @(posedge clk);
		KEY[0] <= 1;                          @(posedge clk);
		SW[9] <= 1;                 repeat(1) @(posedge clk);
		SW[9] <= 0; 			       repeat(9) @(posedge clk);
		SW[9] <= 1;                 repeat(1) @(posedge clk);
		SW[9] <= 0; 			       repeat(2) @(posedge clk);
		$stop;
	end
endmodule
