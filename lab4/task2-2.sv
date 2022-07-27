// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 2

// Top-level module that defines the I/Os for the DE-1 SoC board. It takes a n input clock
// of 50mhz clock, a 10-bit Sw, and 4-bit KEY as inputs, and output 6 7-bit hex displays.

`timescale 1 ps / 1 ps 
module task2 (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
   input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	// turn of hex 2 to hex 5
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	logic [4:0] addr;
	logic f, nf;
	logic [6:0] HEX0_on, HEX1_on;
	
	assign LEDR[9] = f;
   assign LEDR[8] = nf;
	
	// Instantiation of module meta. Takes in CLOCK_50, ~KEY[0],  
	// as inputs, and outputs key
	meta m1 (.clk(CLOCK_50), .in(~KEY[0]), .out(key));
	
	// Instantiation of module binary_search. Inputs: clk, reset, start, A.
	// Outputs: f, nf, addr
	binary_search b1 (.clk(CLOCK_50), .reset(key), .start(SW[9]), .A(SW[7:0]), 
							 .f, .nf, .addr);
	
	// Instantiation of module seg_7. Takes in addr[3:0] as inputs, and 
	// outputs HEX0_on	
	seg_7 s0 (.count(addr[3:0]), .HEX(HEX0_on));
	
	// Instantiation of module seg_7. Takes in addr[4] as inputs, and 
	// outputs HEX1_on	
	seg_7 s1 (.count(addr[4]), .HEX(HEX1_on));
	
	// turn on hex0 and hex1 only when A is found
	always_comb begin
		if (f) begin
			HEX0 = HEX0_on;
			HEX1 = HEX1_on;
		end else begin
			HEX0 = 7'b1111111;
			HEX1 = 7'b1111111;
		end
	end
endmodule

`timescale 1 ps / 1 ps
module task2_testbench();
	logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
   logic [3:0]  KEY;
   logic [9:0]  SW;
   logic CLOCK_50;
	
	parameter CLK_Period = 100;
 	initial begin
 		CLOCK_50 <= 1'b0;
 		forever #(CLK_Period/2) CLOCK_50 <= ~CLOCK_50;
 	end
	
	logic clk;
	assign clk = CLOCK_50;
	
	task2 dut (.*);
	
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
	