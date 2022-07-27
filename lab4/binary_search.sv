// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 2

// This module implements the binary search that can be used for a sorted ram. 
// It takes in a clock, 1-bit start and reset signal, and a 8-bit A as inputs.
// It outputs 1-bit f and nf signal, and a 5-bit addr. 

`timescale 1 ps / 1 ps
module binary_search (
	input logic start, 
	input logic clk, 
	input logic reset,
	input logic [7:0] A,
	output logic f,
	output logic nf,
	output logic [4:0] addr,
	output logic [2:0] ps1
	);

	// the following are pointers we use to track the addresses
	logic [5:0] mid, low, up;
	// the following are holders for the data to compare
	logic [7:0] data, A_reg;
	
	// Instantiation of module ram32x8. Input: address, clock, data, wren. Output: q.
	ram32x8 ram (.address(mid), .clock(clk), .data(), .wren(1'b0), .q(data)); 
		
	// Controller logic
	enum {s_idle, s_wait1, s_wait2, s_compare, s_down, s_up, s_find, s_done} ps, ns;
	
	always_comb begin
		case (ps) 
			s_idle: ns = start ? s_wait1 : s_idle;
			
			s_wait1: ns = s_wait2; 
			
			s_wait2: ns = s_compare; 
			
			s_compare: 
					if (A_reg == data) begin
						ns = s_done; 
				   end else if (A_reg > data) begin // if A is bigger, search up
					   ns = s_up;
				   end else begin // if A is smaller, we search down
						ns = s_down;
				   end
			
			s_up: ns = s_find; 
			
			s_down: ns = s_find; 
				
			s_find: ns = (low > up) ? s_done : s_wait1; 

			s_done: ns = start ? s_done : s_idle;
		endcase 
	end 
	
	// control output logic
	always_ff @(posedge clk) begin
		if (reset) begin 
			mid <= 5'b01111;
			low <= 5'b00000;
			up <= 5'b11111;
			A_reg <= A;
		end else if (ps == s_idle) begin
			mid <= 5'b01111;
			low <= 5'b00000;
		   up <= 5'b11111;
			A_reg <= A;	
		end else if (ps == s_wait1) begin
			mid <= (low + up) / 2; 
		end else if (ps == s_up) begin
			low <= mid + 1;
		end else if (ps == s_down) begin
			up <= mid - 1;
		end
	end
	
	// DFF
	always_ff @(posedge clk) begin
		if (reset)
			ps <= s_idle;
		else
			ps <= ns;
	end
	
	// datapath logic 
	always_comb begin
		if(f) begin
			addr = mid;
		end else begin
			addr = 5'bx;
		end
	end
	
	// the following outputs whether the given data A can be found in the ram
	assign f= (data == A_reg);
	assign nf = (data != A_reg) && (ps == s_done);
	assign ps1 = ps;
	
endmodule

`timescale 1 ps / 1 ps

module binary_search_testbench();
 logic clk, reset, start, f, nf;
 logic [4:0] addr;
 logic [7:0] A;
 logic [2:0] ps1;

 binary_search dut (.*);
 
 // Setting up a simulated clock.
 parameter CLOCK_PERIOD = 100;
 initial begin
  clk <= 0;
  forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
 end
 
 initial begin	
															@(posedge clk);
  reset <= 1;       							   		@(posedge clk);
  reset <= 0; 									
  start <= 0; A <= 19;   					repeat(2) @(posedge clk); // location 19
  start <= 1;             					repeat(8) @(posedge clk);
  start <= 0; A <= 2;   					repeat(2) @(posedge clk); // location 02
  start <= 1;             					repeat(8) @(posedge clk);
  start <= 0; A <= 45;   					repeat(2) @(posedge clk); // not found
  start <= 1;             					repeat(8) @(posedge clk);
  
  $stop;
 end
endmodule 