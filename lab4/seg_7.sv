// Team: Cynthia Li, Simon Chen
// EE 371 Lab 4 Task 2

// This module controls one HEX display on the FPGA board. It takes in
// a 4 bit input signal and output a 7 bit value that represents its 
// corresponding 7 segment display.
module seg_7 (HEX, count);
	output logic [6:0] HEX;
	input logic [3:0] count;
	
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
			4'b1010: HEX = 7'b0001000; // A
			4'b1011: HEX = 7'b0000011; // b
			4'b1100: HEX = 7'b1000110; // C
			4'b1101: HEX = 7'b0100001; // d
			4'b1110: HEX = 7'b0000110; // E
			4'b1111: HEX = 7'b0001110; // F
			default: HEX = 7'bX;
		endcase
	end
endmodule

module seg_7_testbench();
	logic [6:0] HEX;
	logic [3:0] count;

	seg_7 dut (.HEX, .count);

	// Try all combinations of input result
	integer i;
	initial begin
		for(i = 0; i < 16; i++) begin
			count = i;	#10;
		end
	end
endmodule 