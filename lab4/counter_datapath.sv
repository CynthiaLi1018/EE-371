// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 1

// This module is the datapath of the ASMD. It takes in control signals, 
// reset, load, inc, shift, and a 8 bit value, A, which is the data to load.
// It outputs two status, whether local variable A is 0 and whether the 
// current bit examined is 1, and a 4 bit value 'result' which is the count
// of the number of 1 in A.
module counter_datapath (clk, reset, A, load, inc, shift, Ais0, a0, result);
	input logic clk, reset, load, inc, shift;
	input logic [7:0] A;
	output logic Ais0, a0;
	output logic [3:0] result; // need 4-bit value since we want to display 0-8
	
	// this defines the variable A_reg
	logic [7:0] A_reg;
	
	// the following specifies the datapath behavior
	// it updates the output result and the variable A_reg
	always_ff @(posedge clk) begin
		if (reset) begin
			result <= 4'b0;
			A_reg <= 8'b0;
		end
		if (load) begin
			result <= 4'b0;
			A_reg <= A;
		end
		if (inc) begin
			result <= result + 1;
		end
		if (shift) begin
			A_reg <= A_reg >> 1;
		end
	end
	
	// the following defines the output Ais0 and a0's behavior
	assign Ais0 = (A_reg == 0);
	assign a0 = A_reg[0];
	
endmodule

module counter_datapath_testbench();
	logic clk, reset, load, inc, shift;
	logic [7:0] A;
	logic Ais0, a0;
	logic [3:0] result;
	
	parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end
	
	counter_datapath dut (.*);
	
	initial begin
		A <= 8'b10101010; 
		load <= 0; inc <= 0; shift <= 0;
		reset <= 0;                          @(posedge clk);
		reset <= 1;                          @(posedge clk);
		reset <= 0;                          @(posedge clk);
		load <= 1;                           @(posedge clk);
		load <= 0; inc <= 1;       repeat(3) @(posedge clk);
		inc <= 0; shift <= 1;      repeat(3) @(posedge clk);
		shift <= 0; 		         repeat(3) @(posedge clk);
		A <= 8'b00000011;
		load <= 1;                           @(posedge clk);
		load <= 0; inc <= 1;       repeat(3) @(posedge clk);
		inc <= 0; shift <= 1;      repeat(3) @(posedge clk);
		shift <= 0; 		         repeat(3) @(posedge clk);
		
		$stop;
	end
endmodule