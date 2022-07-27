// Cynthia Li
// EE 371 TASK2

// This is the top module that uses KEY[3] as the user input to clear the VGA display
// It displays lines with different slope on VGA that look like a loading clock (so in
// closewise direction). It is a extension of Task1 as it futher implemented a clear
// function that clears a line after finish drawing.
module task2 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	// the following turns off the HEX display
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic draw, finish;
	
	logic pixel_color, frame_start;
	initial pixel_color <= 1'b1;
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	// the following instantiates the VGA frame buffer
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(clear), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
				
	logic	reset, clear;
	
	// initialize the local parameters
	initial begin
		clear <= 1'b0;
		reset <= 1'b0;
	end
	
	// the following set a fixed end point
	assign x0 = 320;
	assign y0 = 240;
	
	// the following uses two arrays to store the x/y coordinate of the second endpoint used for animation
	int x_vals [15:0];
	int y_vals [15:0];
	// the following will form lines with (x0,y0) in closewise sequence.
	assign x_vals = '{300, 260, 220, 180, 220, 260, 300, 320, 340, 380, 420, 460, 420, 380, 340, 320};
	assign y_vals = '{125, 180, 220, 240, 260, 300, 355, 380, 355, 300, 260, 240, 220, 180, 125, 100};
	
	// i keeps track of the second endpoint currently using
	logic [3:0] i;
	
	// the following determines the drawing and clearing action
	always_ff @(posedge clk[whichClock]) begin
		if (~KEY[3]) begin // use KEY[3] as user control of clearing action
			clear <= ~clear;
			i <= 0;
		end

		if (finish) begin
			// each time finish drawing a line, switch pixel_color
			pixel_color <= ~pixel_color;
			// after clearing, move to next endpoint
			if (~pixel_color) begin
				i <= i + 1;
			end
			// trigger next drawing action
			reset <= 1'b1;
		end else begin
			// wait for drawing action to finish
			reset <= 1'b0;
		end
	end
	
	// As i gets incremented in the main program logic, the end point of the line changes accordingly
	assign x1 = x_vals[i];
	assign y1 = y_vals[i];
		
	// the following instantiates the line drawer module				
	line_drawer lines (.clk(CLOCK_50), .reset, .x0, .x1, .y0, .y1, .x, .y, .finish);
	
	// the following generates a slower clock
	logic [31:0] clk;
	parameter whichClock = 22; // 6 Hz clock
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));
	
endmodule

module task2_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
    task2 dut(.*);
	 
	 // Simulate clock
    parameter CLOCK_PERIOD = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
    end
	 
	 // there is no real useful information in the tb
	 // simply to see that input works
    initial begin
        KEY[3] <= 1'b0; @(posedge CLOCK_50);
        KEY[3] <= 1'b1; @(posedge CLOCK_50);
        for (int i = 0; i < 20; i++) begin
								@(posedge CLOCK_50);
        end 
        $stop;
    end 
endmodule