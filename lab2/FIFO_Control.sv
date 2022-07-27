// This module defines when the FIFO is empty and full
// it input the read/ write enable, and output wr_en, 
// emty, full, status, and read, write address
module FIFO_Control #(parameter depth = 4)
							(input logic clk, reset,
							 input logic read, write,
							 output logic wr_en,
							 output logic empty, full,
							 output logic [depth-1:0] readAddr, writeAddr);
	
	/* 	Define_Variables_Here		*/
	
	/*		Combinational_Logic_Here	*/
	assign wr_en = write & ~full;
	
	/*		Sequential_Logic_Here		*/	
	// the following is the logic that defines when the FIFO is full and empty
	// and when the 
	always_ff @(posedge clk) begin
		if(reset) begin	// defin initialization
			readAddr <= '0;
			writeAddr <= '0;
			full <= 1'b0;
			empty <= 1'b1;
        end else if (((writeAddr + 1) == readAddr) & write & ~ read) begin
																// define reaching "full"
			readAddr <= readAddr;
			writeAddr <= writeAddr + 1;
			full <= 1'b1;
			empty <= 1'b0;
		end else if (((readAddr + 1) == writeAddr) & read & ~write) begin
																// define reaching empty
			readAddr <= readAddr + 1;
			writeAddr <= writeAddr;
			full <= 1'b0;
			empty <= 1'b1;
		end else if (full & write & ~read) begin // define upper boundary
			readAddr <= readAddr;
			writeAddr <= writeAddr;
		   full <= 1'b1;
		   empty <= 1'b0;
		end else if (empty & read & ~write) begin // define lower boundary
			readAddr <= readAddr;
			writeAddr <= writeAddr;
			full <= 1'b0;
			empty <= 1'b1;
		end else if (read & ~write) begin
			readAddr <= readAddr + 1;
			writeAddr <= writeAddr;
			full <= 1'b0;
			empty <= 1'b0;
		end else if (~read & write) begin
			readAddr <= readAddr;
			writeAddr <= writeAddr + 1;
			full <= 1'b0;
			empty <= 1'b0;
		end else if (read & write) begin  
			readAddr <= readAddr + 1;
			writeAddr <= writeAddr + 1;
			empty <= empty;
			full <= full;
		end else begin  
			readAddr <= readAddr;
			writeAddr <= writeAddr;
			empty <= empty;
			full <= full;
		end
	end
endmodule 

module FIFO_Control1_testbench();
	logic clk, reset;
	logic read, write;
	logic wr_en;
	logic empty, full;
	logic [3:0] readAddr, writeAddr;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	FIFO_Control control (.*);
	
	integer i;
	
	initial begin
																	@(posedge clk);
		reset <= 1;												@(posedge clk);
		reset <= 0;												@(posedge clk);
		read <= 1; write <= 0;								@(posedge clk); // test lower boundary
		read <= 0; write <= 1;				repeat(18)	@(posedge clk); // test normal w/full/upper boundary
		read <= 1; write <= 1;				repeat(2)	@(posedge clk); // test w&r
		read <= 1; write <= 0;				repeat(15)	@(posedge clk); // test normal r
		read <= 0; write <= 0; 								@(posedge clk); // test disenabling
		reset <= 1;												@(posedge clk);
		reset <= 0;												@(posedge clk);
		$stop;
	end
endmodule
