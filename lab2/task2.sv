// Cynthia Li
// EE 371 LAB2 TASK2

// Module task2 is the top module for task1 project
// it uses a 32x4 single port ram that can takes inputs of a 5-bit address (SW[8:4]),
// a 4-bit data to write (SW[3:0]), a write control (SW[9]), and a self-operated
// clock (KEY[0]) and output a 4-bit data stored in the address to read.
// The read/write address is displayed on HEX5 and HEX4, data to write is 
// displayed on HEX2, and data to read is displayed on HEX0. 

`timescale 1 ps / 1 ps
module task2(CLOCK_50, SW, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input logic CLOCK_50;
	input logic [9:0] SW;
	input logic [3:0] KEY;
	output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	// the following produces a slowed clock
	parameter whichClock = 25; // 0.365 Hz clock
	logic [31:0] div_clk;
	clock_divider cdiv (.clock(CLOCK_50),
							  .reset(reset),
							  .divided_clocks(div_clk));
	
	// clk; allows for easy switching between simulation and board clocks
	logic clk;
	// assign clk = CLOCK_50; // for simulation
	assign clk = div_clk[whichClock]; // for board
	
	logic [3:0] data_read, data_w;
	logic [4:0] addr_read;
	
	assign data_w = SW[3:0];
	
	counter count (.clk, .reset(~KEY[0]), .addr_r(addr_read));
	
	ram32x4_2port ram_2port (.clk(CLOCK_50), .wr_en(~KEY[3]), .addr_w(SW[8:4]), 
										.addr_r(addr_read), .data_w, .data_r(data_read));
	
	hexadecimal read (.binary(data_read), .hex(HEX0));
	
	hexadecimal write (.binary(data_w), .hex(HEX1));
	
	hexadecimal r_addr1 (.binary({3'b0, addr_read[4]}), .hex(HEX3));
	hexadecimal r_addr2 (.binary(addr_read[3:0]), .hex(HEX2));
	
	hexadecimal w_addr1 (.binary({3'b0, SW[8]}), .hex(HEX5));
	hexadecimal w_addr2 (.binary(SW[7:4]), .hex(HEX4));
endmodule

`timescale 1 ps / 1 ps
module task2_testbench();	
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	
	logic CLOCK_50, clk;
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	assign clk = CLOCK_50;
	
	task2 dut (.CLOCK_50, .SW, .KEY, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);
	
	integer i;
	
	initial begin
										@(posedge clk);
	KEY[0] <= 0;  					@(posedge clk);
	KEY[3] <= 0; 					@(posedge clk); // reset counter, enable wr_en

	for (i = 0; i < 32; i++)  begin
		KEY[0] <= 1;
		SW[8:4] <= i + 1;
		SW[3:0] <= 31 - i;		@(posedge clk); // test enabled write + no input
	end
	KEY[3] <= 1;
	for (i = 0; i < 4; i++)  begin
		SW[8:4] <= i;
		SW[3:0] <= i + 1;			@(posedge clk); // test enabled write + no input
		end
	KEY[0] <= 0;  					@(posedge clk); // see if reset works
	KEY[0] <= 1;	repeat(2)	@(posedge clk);
	$stop;
	end
endmodule
	