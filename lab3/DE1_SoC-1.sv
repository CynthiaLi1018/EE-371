// Cynthia Li
// EE 371

// This is the top module that uses KEY[3] as the user input to initizae the action to draw
// the 8 internally choosen lines and output the updated image to VGA. It follows the Bresenham’s
// line drawing algorithm to determine the nearest pixel of the lines.
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
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
	
	logic draw, finish;
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	
	logic pixel_color, frame_start;
	assign pixel_corlor = 1'b1;
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	// the following instantiates the VGA frame buffer
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
		
	// the following process the user input to ensure each press is true for only one cycle
	UserInput process_KEY (.clk(CLOCK_50), .press(~KEY[3]), .out(draw));
	
	// the following instantiates the line drawer
	line_drawer lines (.clk(CLOCK_50), .reset(1'b0), .x0, .x1, .y0, .y1, .x, .y, .finish);
	
	// the following instantiates the FSM that sets the endpoints of lines
	lines drawing (.clk(CLOCK_50), .reset(1'b0), .done(finish), .draw, .x0, .x1, .y0, .y1);
endmodule

module DE1_SoC_testbench();
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
	
    DE1_SoC dut(.*);
	 
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