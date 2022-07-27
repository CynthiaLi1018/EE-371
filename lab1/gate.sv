// Cynthia Li
// 4/12/2021
// EE 371
// Lab2 Task#1

// gate is the module that simulates the parking lot's single entry gate. It
// takes inputs reset, a, b and clk, and outputs the enter and exit movement
// status of cars to enter and exit.
module gate(reset, clk, a, b, enter, exit);
	input logic reset, clk, a, b;
	output logic enter, exit;

	// the following defines the states in the FSM
	logic [1:0] ps, ns;
	parameter [1:0] unblock = 2'b00, 
						 block_b = 2'b01, 
						 block_a = 2'b10,
						 block   = 2'b11;
						 
	// pa: local logic used to keep track of the sequence previously
	// went
	logic [1:0] pa; 
	
	// the following specifies the value of enter and exit
	// based on the state and current input value
	always_comb
		case(ps)
			unblock: begin
						if ({a, b} == 2'b01) begin
							ns = block_b;
							enter = 1'b0;
							exit = 1'b0;
							end
						else if ({a, b} == 2'b10) begin
							ns = block_a;
							enter = 1'b0;
							exit = 1'b0;
							end
						else begin  // {a, b} == 00 or 11
							ns = unblock;
							enter = 1'b0;
							exit = 1'b0;
						end
					end
			block_b: begin
						if ({a, b} == 2'b00 & pa == 2'b10) begin
							ns = unblock;
							enter = 1'b1;
							exit = 1'b0;
							end
						else if ({a, b} == 2'b00) begin
							ns = unblock;
							enter = 1'b0;
							exit = 1'b0;
							end
						else if ({a, b} == 2'b11) begin
							ns = block;
							enter = 1'b0;
							exit = 1'b0;
							end
						else begin // {a, b} == 01 or 10
							ns = block_b;
							enter = 1'b0;
							exit = 1'b0;
						end
					end
			block_a: begin
						if ({a, b} == 2'b00 & pa == 2'b01) begin
							ns = unblock;
							enter = 1'b0;
							exit = 1'b1;
							end
						else if ({a, b} == 2'b00) begin
							ns = unblock;
							enter = 1'b0;
							exit = 1'b0;
							end
						else if ({a, b} == 2'b11) begin
							ns = block;
							enter = 1'b0;
							exit = 1'b0;
							end
						else begin // {a, b} == 01 or 10
							ns = block_b;
							enter = 1'b0;
							exit = 1'b0;
						end
					end
			block: begin
						if ({a, b} == 2'b01) begin
							ns = block_b;
							enter = 1'b0;
							exit = 1'b0;
							end
						else if ({a, b} == 2'b10) begin
							ns = block_a;
							enter = 1'b0;
							exit = 1'b0;
							end
						else begin  // {a, b} == 01 or 10
							ns = block;
							enter = 1'b0;
							exit = 1'b0;
						end
					end
			default: begin
						ns = unblock;
						enter = 1'b0;
						exit = 1'b0;
						end
		endcase
	
	// the following update the ps (present state) in FSM
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= unblock;
			end
		else begin
			ps <= ns;
			end
	end
	
	// the following updates pa (previous action) based on
	// the previous sequence
	always_ff @(posedge clk) begin
		if (reset) begin
			pa <= 2'b00;
			end
		else if (ps == unblock) begin
			pa <= 2'b00;
			end
		else if (ps == block_b) begin
			pa <= 2'b01;
			end
		else if (ps == block_a) begin
			pa <= 2'b10;
			end
		else begin
			pa <= pa;
			end
   end		
endmodule

module gate_testbench();

	logic reset, clk, a, b, enter, exit;
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	gate dut (.reset, .clk, .a, .b, .enter, .exit);
	
	initial begin
							@(posedge clk);
		reset <= 1;		@(posedge clk);
		reset <= 0;		@(posedge clk);
		a <= 0; b <= 0; 						@(posedge clk);
		a <= 1; b <= 1; 						@(posedge clk); // test non-existing case
		a <= 0; b <= 0; 						@(posedge clk); // test standard entering
		a <= 1; b <= 0; 						@(posedge clk);
		a <= 1; b <= 1; 						@(posedge clk);
		a <= 0; b <= 1; 						@(posedge clk);
		a <= 0; b <= 0; 						@(posedge clk); // enter = 1, exit = 0
		a <= 0; b <= 0; 						@(posedge clk);
		a <= 0; b <= 1; 						@(posedge clk); // test standard exiting
		a <= 1; b <= 1; 						@(posedge clk);
		a <= 1; b <= 0; 						@(posedge clk);
		a <= 0; b <= 0; 						@(posedge clk); // enter = 0, exit = 1
		a <= 1; b <= 0; 						@(posedge clk); // test exist and change direction
		a <= 1; b <= 1; 						@(posedge clk);
		a <= 1; b <= 0; 						@(posedge clk);
		a <= 0; b <= 0; 						@(posedge clk); 
		a <= 0; b <= 1; 						@(posedge clk); // test enter and change direction
		a <= 0; b <= 1; 						@(posedge clk);
		a <= 1; b <= 1; 						@(posedge clk);
		a <= 0; b <= 1; 						@(posedge clk);
		a <= 0; b <= 0; 						@(posedge clk);
		a <= 0; b <= 1; 						@(posedge clk); // test enter and change direction
		a <= 0; b <= 0; 						@(posedge clk); 
		a <= 1; b <= 0; 						@(posedge clk); // test exit and change direction
		a <= 0; b <= 0; 						@(posedge clk);
		a <= 0; b <= 1; 						@(posedge clk); // test non-existing case
		a <= 1; b <= 0; 						@(posedge clk);
		$stop;
	end
endmodule