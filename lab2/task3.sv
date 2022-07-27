// Cynthia Li
// EE 371 LAB2 TASK3

// This is the top module that uses a FIFO that uses a 16x8 2 port ram to store data, 
// and operates like Queue. It displays the “queue’s” full/empty status on LEDR9/8, 
// and when read(KEY[1]) is enabled, it reads the oldest data we input and displays
// it on HEX1 and HEX0, when write(KEY[0]) is enabled, it writes the specified data
// (SW[7:0]) to the newest address, and display this value on HEX5 and HEX4.
module task3(CLOCK_50, SW, KEY, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input logic CLOCK_50;
	input logic [9:0] SW;
	input logic [3:0] KEY;
	output logic [9:0] LEDR;
	output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	logic empty, full;
	logic [7:0] outputBus;
	
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
	
	logic r, w, read, write;
	meta READ (.clk(CLOCK_50), .in(SW[9]), .out(r));
	meta WRITE (.clk(CLOCK_50), .in(SW[8]), .out(w));
	userInput R (.clk(CLOCK_50), .press(SW[9]), .out(read));
	userInput W (.clk(CLOCK_50), .press(SW[8]), .out(write));

	//FIFO #(4, 8) fifo (.clk(CLOCK_50), .reset(SW[9]), .read(read), .write(write),
				//  .inputBus(SW[7:0]), .empty, .full, .outputBus);
				
	FIFO #(4, 8) fifo (.clk(CLOCK_50), .reset(SW[9]), .read(read), .write(write),
				  .inputBus(SW[7:0]), .empty, .full, .outputBus);
				  
	// the following displays the full and empty status of FIFO on LEDR[9] and LEDR[8]
	assign LEDR[9] = full;
	assign LEDR[8] = empty;
	
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
	// the following displays hexadecimal value of current input value on HEX5-4
	hexadecimal writeData1 (.binary(SW[7:4]), .hex(HEX5));
	hexadecimal writeData2 (.binary(SW[3:0]), .hex(HEX4));
	
	// the following displays current value of the oldest data on HEX1-0
	hexadecimal readData1 (.binary(outputBus[7:4]), .hex(HEX1));
	hexadecimal readData2 (.binary(outputBus[3:0]), .hex(HEX0));
endmodule

module task3_testbench();
	logic CLOCK_50;
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [9:0] LEDR;
	logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	task3 dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		CLOCK_50 <= 1'b0;
		forever #(CLK_Period/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	logic clk;
	assign clk = CLOCK_50;
	
	integer i;
	
	initial begin
																	@(posedge clk);
		SW[9] <= 1;												@(posedge clk);
		SW[9] <= 0;												@(posedge clk);
		KEY[1] <= 1; KEY[0] <= 0; 							@(posedge clk);
																	@(posedge clk);
																	@(posedge clk);
		for (i = 0; i < 18; i++) begin
			
			SW[7:0] <= i;										@(posedge clk); // test normal w/full/upper boundary
		end

		KEY[1] <= 0; KEY[0] <= 1;
		SW[7:0] <= 8'b00000000;			repeat(16)	@(posedge clk); // test normal r
		KEY[1] <= 1; KEY[0] <= 1; 								@(posedge clk); // test disenabling
		SW[9] <= 1;												@(posedge clk);
		SW[9] <= 0;	KEY[1] <= 1;				repeat(2)	@(posedge clk);
		
		$stop;
	end
endmodule