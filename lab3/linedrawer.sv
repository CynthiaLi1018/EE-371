// Cynthia Li
// EE 371 Lab3
//
// The line_drawer module takes in four 10 or 9 bit value that represent the x/y coordinates 
// of two points to draw a line between the two point. It will output a 9-bit and a 10-bit
// value representing the current coordinate it's examing on the line, and output the status
// of whether the line has been finished drawing.
module line_drawer(
	input logic clk, reset,
	// x and y coordinates for the start and end points of the line
	input logic [9:0]	x0, x1,
	input logic [8:0] y0, y1,
	//output x, y coordinate that represent the current point examined
	output logic [9:0] x, 
	output logic [8:0] y, 
	output logic finish
	);
	
	// the following are registers used to keep track of things
	// dx, dy keep track of the |difference in x| and -|difference in y|
	// error and temp_error keep track of the diference between x change and y change
	// to determine whether to increment x or y
	logic signed [10:0] dx, dy, error, temp_error;
	logic x_dir, y_dir;
	
	enum {start, draw, done} ps, ns;
	
	// the following specifies the next state logic
	always_comb begin
		case (ps)
			start: 	ns = draw;
			draw: if ((x == x1) && (y == y1))
						ns = done;
					else
						ns = draw;
			done: ns = start;
			default: ns = start;
		endcase
	end
	
	// the following specifies the FSM behavior
	always_ff @(posedge clk) begin
		case (ps)
			start:	begin
						// determines y change and y direction
						dy = y1 - y0; 
						// y_dir positive for down, negative for up
						y_dir = dy >= 0;
						if (y_dir) 
							dy = -dy;
						
						// determines x change and x direction
						dx = x1 - x0;
						// x_dir positive for right, negative for left
						x_dir = dx >= 0; 
						if (~x_dir) 
							dx = -dx;
						
						error = dx + dy;
						
						x <= x0;
						y <= y0;
						finish <= 0;
					end
			draw:	begin
						temp_error = error << 1;

						// check if x need update
						if ((temp_error > dy)) begin
							error += dy;
							if (x_dir)
								x <= x + 1;
							else
								x <= x - 1;
						end
						
						// check if y need update
						if ((temp_error < dx)) begin
							error += dx;
							if (y_dir)
								y <= y + 1;
							else
								y <= y - 1;
						end
					end
			done: begin
						finish <= 1;
						x <= x1;
						y <= y1;
					end
			default: begin			
						x <= x0;
						y <= y0;
						finish <= 0;
					end
		endcase
	end
	
	// the following is a DFF used to update present state
	always_ff @(posedge clk) begin
		if (reset)
			ps <= start;
		else
			ps <= ns;
	end
endmodule

module line_drawer_testbench();
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic clk, reset, finish;
	
	line_drawer dut(.*);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// test whether a line can be drawn between two given points and whether
	// 'finish' will be updated.
	initial begin
		x0 <= 65; y0 <= 300; x1 <= 98; y1 <= 279; @(posedge clk);
												repeat(40) @(posedge clk);
		$stop;
	end
endmodule
