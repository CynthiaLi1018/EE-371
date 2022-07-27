// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 1

// This module controls the HEX display of the FPGA board. It takes
// in a 4 bit value representing the result of the counting action,
// and display the value's decimal form on HEX0; it turns off the
// the rest of the displays
module counter_display (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, result);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [3:0] result;
 
	// Default values, turns off the HEX1-HEX5's displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
   assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// Store the 7-bit status of input 4-bit signal
	seg_7 s1(.count(result), .HEX(HEX0));
endmodule

// This module controls one HEX display on the FPGA board. It takes in
// a 4 bit input signal and output a 7 bit value that represents its 
// corresponding 7 segment display.
module seg_7 (count, HEX);
	input logic [3:0] count;
	output logic [6:0] HEX;
	
	// the following specifies each input value's corresponding hex
	// display value
	always_comb begin 
		case (count)
					  // Light: 6543210
			4'b0000: HEX = 7'b1000000; // 0
			4'b0001: HEX = 7'b1111001; // 1
			4'b0010: HEX = 7'b0100100; // 2
			4'b0011: HEX = 7'b0110000; // 3
			4'b0100: HEX = 7'b0011001; // 4
			4'b0101: HEX = 7'b0010010; // 5
			4'b0110: HEX = 7'b0000010; // 6
			4'b0111: HEX = 7'b1111000; // 7
			4'b1000: HEX = 7'b0000000; // 8
			4'b1001: HEX = 7'b0010000; // 9
			default: HEX = 7'bX;
		endcase
	end
endmodule

module seg_7_testbench();
	logic [6:0] HEX;
	logic [3:0] count;
	
	seg_7 dut (.*);
	
	// Try all combinations of input result
	integer i;
	initial begin
		for(i = 0; i < 10; i++) begin
			count = i;	#10;
		end
	end
endmodule

module counter_display_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [3:0] result;

	counter_display dut (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, result);

	// Try all combinations of input result
	integer i;
	initial begin
		for(i = 0; i < 10; i++) begin
			result = i;	#10;
		end
	end
endmodule 

