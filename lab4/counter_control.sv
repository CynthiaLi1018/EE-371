// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 1

// This module is the control of the ASMD. It takes in a start signal
// s, and two conditional variable Ais0 and a0, it outputs control signals,
// load, inc, shift, and done that represents the action needed for 
// counting and the status of the counting action based on the conditions
// of s, Ais0, and a0.
module counter_control (clk, reset, s, Ais0, a0, load, inc, shift, done);
	input logic clk, reset, s, Ais0, a0;
	output logic load, inc, shift, done;

	// the following specifies the states in FSM
	enum {s1, s2, s3} ps, ns;
	
	// the following specifies the next state logic
	always_comb begin
		case (ps)
			s1: if (s)
						ns = s2;
				 else // !s
						ns = s1;
			s2: if (Ais0)
						ns = s3;
				 else // !Ais0
						ns = s2;
			s3: if (s)
						ns = s1;
				 else // !s
						ns = s3;
			default: ns = s1;
		endcase
	end
	
	// the following specifies the output logic
	always_comb begin
		case (ps)
			s1: begin
						inc = 1'b0;
						shift = 1'b0;
						done = 1'b0;
						if (!s) begin
							load = 1'b1;
						end else begin
							load = 1'b0;
						end
				 end
			s2: begin
						load = 1'b0;
						shift = 1'b1;
						done = 1'b0;
						if (!Ais0 & a0) begin
							inc = 1'b1;
						end else begin
							inc = 1'b0;
						end
				 end
			s3: begin
						load = 1'b0;
						inc = 1'b0;
						shift = 1'b0;
						if (s) begin
							done = 1'b1;
						end else begin
							done = 1'b0;
						end
				 end
			default: begin
							load = 1'b0;
							inc = 1'b0;
							shift = 1'b0;
							done = 1'b0;
						end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= s1;
		end else begin
			ps <= ns;
		end
	end
endmodule

module counter_control_testbench();
	logic clk, reset, s, Ais0, a0;
	logic load, inc, shift, done;
	
	parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end
	
	counter_control dut (.*);
	
	initial begin
		reset <= 0;                          @(posedge clk);
		reset <= 1;                          @(posedge clk);
		reset <= 0;			                   @(posedge clk);
		s <= 0;				                   @(posedge clk);
		s <= 1;				                   @(posedge clk);
		Ais0 <= 0; a0 <= 1;			repeat(3) @(posedge clk);
		a0 <= 0;				         repeat(3) @(posedge clk);
		Ais0 <= 1; s <= 0;		             @(posedge clk);
		s <= 0;				         repeat(3) @(posedge clk);
		s <= 1;				         repeat(3) @(posedge clk);
		$stop;
	end
endmodule
