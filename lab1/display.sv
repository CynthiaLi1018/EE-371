// Cynthia Li
// 4/12/2021
// EE 371
// Lab1 Task#3

// display is the module that takes 5-bit input count that represents current car 
// number in the parking lot, and outputs six 7-bit value to HEX5 to HEX0. HEX1 and HEX0
// are used as 7 segment display of decimal number of count; HEX5 to HEX2 are usually turned
// off, but will display 7 segment pattern "FULL" when full is true, HEX5 to HEX1 will display
// 7 segment pattern "CLEAr" when empty is true. Note that clear and full will never be both
// both true.
module display(reset, count, full, clear, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	
	input logic reset;
	input logic full, clear;
	input logic [4:0] count;
	output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	logic [6:0] F, U, L, C, E, A, r, one, two, three, four, five, 
					six, seven, eight, nine, zero, n;
	
	// the following assignment specifies each letter or number's 
	// 7-segment expression
	assign F = 7'b0001110;
	assign U = 7'b1000001;
	assign L = 7'b1000111;
	
	assign C = 7'b1000110;
	assign E	= 7'b0000110;
	assign A = 7'b0001000;
	assign r = 7'b0101111;
	
	assign zero	 = 7'b1000000;
	assign one	 = 7'b1111001;
	assign two	 = 7'b0100100;
	assign three = 7'b0110000;
	assign four	 = 7'b0011001;
	assign five	 = 7'b0010010;
	assign six 	 = 7'b0000010;
	assign seven = 7'b1111000;
	assign eight = 7'b0000000;
	assign nine	 = 7'b0010000;
	
	assign n		 = 7'b1111111; // turn off the display

	// the display on HEX5 to HEX0 is updated by the following combinational logic
	always_comb begin
		if (reset) begin 
			HEX5 = C; HEX4 = L; HEX3 = E; HEX2 = A; HEX1 = r; HEX0 = zero;
			end
		else if (full) begin  // display "FULL" on HEX5 to HEX2, decimal count on HEX1 and HEX0
			case (count)
				5'b00101: begin
					HEX5 = F; HEX4 = U; HEX3 = L; HEX2 = L; HEX1 = zero; HEX0 = five;
				end
				5'b11001: begin
					HEX5 = F; HEX4 = U; HEX3 = L; HEX2 = L; HEX1 = two; HEX0 = five;
				end
				default: begin
					HEX5 = F; HEX4 = U; HEX3 = L; HEX2 = L; HEX1 = two; HEX0 = five;
				end
			endcase
			end
		else if (clear) begin // display "CLEAr" on HEX5 to HEX1, "0" on HEX0
				HEX5 = C; HEX4 = L; HEX3 = E; HEX2 = A; HEX1 = r; HEX0 = zero;
			end
		else if (~full & ~clear) begin // turns off HEX5 to HEX2, decimal count on HEX1 and HEX0
			case (count)
				5'b00000: begin
					HEX5 = C; HEX4 = L; HEX3 = E; HEX2 = A; HEX1 = r; HEX0 = zero;
				end
				5'b00001: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = one;
				end
				5'b00010: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = two;
				end
				5'b00011: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = three;
				end
				5'b00100: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = four;
				end
				5'b00101: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = five;
				end
				5'b00110: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = six;
				end
				5'b00111: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = seven;
				end
				5'b01000: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = eight;
				end
				5'b01001: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = zero; HEX0 = nine;
				end
				5'b01010: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = zero;
				end
				5'b01011: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = one;
				end
				5'b01100: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = two;
				end
				5'b01101: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = three;
				end
				5'b01110: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = four;
				end
				5'b01111: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = five;
				end
				5'b10000: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = six;
				end
				5'b10001: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = seven;
				end
				5'b10010: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = eight;
				end
				5'b10011: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = one; HEX0 = nine;
				end
				5'b10100: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = two; HEX0 = zero;
				end
				5'b10101: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = two; HEX0 = one;
				end
				5'b10110: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = two; HEX0 = two;
				end
				5'b10111: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = two; HEX0 = three;
				end
				5'b11000: begin
					HEX5 = n; HEX4 = n; HEX3 = n; HEX2 = n; HEX1 = two; HEX0 = four;
				end
				5'b11001: begin
					HEX5 = F; HEX4 = U; HEX3 = L; HEX2 = L; HEX1 = two; HEX0 = five;
				end
				default: begin
					HEX5 = C; HEX4 = L; HEX3 = E; HEX2 = A; HEX1 = r; HEX0 = zero;
				end
			endcase
			end
		else begin // default setting as "CLEAr0"
			HEX5 = C; HEX4 = L; HEX3 = E; HEX2 = A; HEX1 = r; HEX0 = zero;
			end
	end
endmodule

