// this is a 2 port ram that works as a queue
// when it reads, it outputs the oldest data
// stored in r_addr to r_data, when it writes,
// it update the value stored in w_addr with
// w_data
module ram_2port #(parameter depth = 16,
						 parameter width = 8)
						(clk, wr_en, rd_en, w_addr, r_addr, w_data, r_data);
	
	input logic clk, wr_en, rd_en;
	input logic [3:0] w_addr, r_addr;
	input logic [7:0] w_data;
	
	output logic [width-1:0] r_data;

	logic [width-1:0] RAM [depth-1:0];
	
	// the following defines the read and write operations
	always_ff @(posedge clk) begin
		if (wr_en & rd_en) begin
			RAM[w_addr] <= w_data;
			r_data <= RAM[r_addr];
		end else if (wr_en & ~rd_en)begin
			RAM[w_addr] <= w_data;
			r_data <= r_data;
		end else if (~wr_en & rd_en) begin
			r_data <= RAM[r_addr];
		end else if (~wr_en & ~rd_en) begin
			r_data <= r_data;
		end
	end
endmodule

module ram_2port_testbench();
	logic clk, wr_en, rd_en;
	logic [3:0] w_addr, r_addr;
	logic [7:0] w_data;
	
	logic [7:0] r_data;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	ram_2port ram (.*);
	
	integer i;
	
	initial begin
														@(posedge clk);
		wr_en <= 1'b1; rd_en <= 1'b1;		// test if enable updates stored data and ouput
		for (i = 0; i < 15; i++) begin	// expect to see r_data decrement 2 cycles
			w_addr <= i + 1; 					// after w_data
			r_addr <= i;
			w_data <= 255-i;						@(posedge clk); 
		end
		wr_en <= 1'b0; rd_en <= 1'b0;		// test if disenable stops updates
		for (i = 0; i < 4; i++) begin		// expect to see r_data shows previous value
			w_addr <= i;
			r_addr <= i;
			w_data <= i;							@(posedge clk); 
		end
		wr_en <= 1'b0; rd_en <= 1'b1;		// test if disenable wr_en stops updating write
		for (i = 0; i < 4; i++) begin		// and rd_en updates output
			w_addr <= i;						// expect to see r_data with value in part1
			r_addr <= i;
			w_data <= i;							@(posedge clk); 
		end
		wr_en <= 1'b1; rd_en <= 1'b0;		// knowning wr_en can update stored data
		for (i = 0; i < 4; i++) begin		// test if disenable rd_en stops updating output
			w_addr <= i + 1;					// expect to see r_data shows previous value
			r_addr <= i;
			w_data <= i + 1;						@(posedge clk); 
		end
		$stop;
	end
endmodule