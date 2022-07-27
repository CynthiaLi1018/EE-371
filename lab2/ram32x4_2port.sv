// Cynthia Li
// EE 371 LAB2 TASK2

// Module ram32x4_2port defines a two port 32x4 ram that uses two input 
// 5-bit one for write operation, to update the value in the address with
// input 4-bit data_w, when input wr_en is true; the other for read 
// operation,it outputs the 4-bit value stored in this address to data_r.

`timescale 1 ps / 1 ps
module ram32x4_2port(clk, wr_en, addr_w, addr_r, data_w, data_r);
	input logic clk, wr_en;
	input logic [4:0] addr_w, addr_r;
	input logic [3:0] data_w;
	output logic [3:0] data_r;
	
	// the following defines the size of the memory block
	logic [3:0] RAM [31:0];
	
	// the following is the write operation
	always_ff @(posedge clk) begin
		if (wr_en) begin
			RAM[addr_w] <= data_w;
		end
	end
	
	// the following is the read operation
	assign data_r = RAM[addr_r];
endmodule

`timescale 1 ps / 1 ps
module ram32x4_2port_testbench();
	logic clk, wr_en;
	logic [4:0] addr_w, addr_r;
	logic [3:0] data_w;
	logic [3:0] data_r;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	ram32x4_2port ram32x4_2port_test(clk, wr_en, addr_w, addr_r, data_w, data_r);
	
	integer i;
	
	initial begin
		wr_en <= 1'b1;								@(posedge clk);
		for (i = 0; i < 32; i++)  begin
			addr_w <= i + 1;
			data_w <= 31 - i;
			addr_r <= i;							@(posedge clk); // test enabled write + no input
		end
		wr_en <= 1'b0;
		for (i = 0; i < 4; i++)  begin
			addr_w <= i;
			data_w <= i + 1;
			addr_r <= i;							@(posedge clk); // test enabled write + no input
		end
		$stop;
	end
endmodule
