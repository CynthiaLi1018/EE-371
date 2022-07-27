// Cynthia Li
// 4/20/21
// EE 371 LAB2 TASK1

// Module hexadecimal takes a 4bit input value, and output its
// corresponding hexadecimal value seven segment display.
module hexadecimal (binary, hex);
	input logic [3:0] binary;
	output logic [6:0] hex;
	
	// the following is the logic that link each 4bit binary value
	// to its hexadecimal seven segment display expression
	always_comb begin
		case(binary)					// display
			4'b0000: hex = 7'b1000000; // 0
			4'b0001: hex =	7'b1111001; // 1
			4'b0010: hex =	7'b0100100; // 2
			4'b0011: hex =	7'b0110000; // 3
			4'b0100: hex =	7'b0011001; // 4
			4'b0101: hex =	7'b0010010; // 5
			4'b0110: hex =	7'b0000010; // 6
			4'b0111: hex =	7'b1111000; // 7
			4'b1000: hex =	7'b0000000; // 8
			4'b1001: hex = 7'b0010000; // 9
			4'b1010: hex = 7'b0001000; // A
			4'b1011: hex = 7'b0000011; // b
			4'b1100: hex = 7'b1000110; // C
			4'b1101: hex = 7'b0100001;	// d
			4'b1110: hex = 7'b0000110; // E
			4'b1111: hex = 7'b0001110; // F
			default: hex = 7'b1111111; // turn off display
		endcase
	end
endmodule

module hexadecimal_testbench();

	logic [3:0] binary;
	logic [6:0] hex;
	
	hexadecimal dut (.binary, .hex);
	
	initial begin
		binary = 4'b0000; #10;
		binary = 4'b0001; #10;
		binary = 4'b0010; #10;
		binary = 4'b0011; #10;
		binary = 4'b0100; #10;
		binary = 4'b0101; #10;
		binary = 4'b0110; #10;
		binary = 4'b0111; #10;
		binary = 4'b1000; #10;
		binary = 4'b1001; #10;
		binary = 4'b1010; #10;
		binary = 4'b1011; #10;
		binary = 4'b1100; #10;
		binary = 4'b1101; #10;
		binary = 4'b1110; #10;
		binary = 4'b1111; #10;
		$stop;
	end
endmodule