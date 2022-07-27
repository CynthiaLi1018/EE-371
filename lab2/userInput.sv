// Cynthia Li
// 4/20/21
// EE 371 LAB2 TASK1

// Module userInput takes a input press that indicates the status
// of a KEY, and should process it so that every press is true for
// only one cycle and otherwise stays false. It will output this
// processed KEY status to out.
module userInput (clk, press, out);
	input logic clk, press;
	// press: true when the KEY is pressed
	output logic out;
	
	enum {on, off} ps, ns;	

	// the next state and output logic
	always_comb 
		case(ps)
			on: if (press) begin // key contiuously being pressed 
			         ns = on;		// & out has been true for 1 cycle
						out = 0;
					end
			    else begin    	// key is released
				      ns = off;
						out= 0;
					end
			off: 	if (press) begin 	// key is pressed (the action)
							ns = on;	  	// make out true for one cycle
							out= 1;
						end
					else begin    		// key is not pressed
				         ns = off;
				         out = 0;
						end				 
			default: begin
							ns = off;
							out = 0;
						end
		endcase

	always_ff @(posedge clk)
		ps <= ns;
		
endmodule

module userInput_testbench();
	logic clk, press;
	logic out;
	
	userInput dut (.clk, .press, .out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
	press <= 1;	  repeat(3) @(posedge clk); // off state: key is pressed
	press <= 1;	  repeat(3) @(posedge clk); // on state: key is pressed
	press <= 0;	  repeat(3) @(posedge clk); // on state: key is released
	press <= 0;	  repeat(3) @(posedge clk); // off state: key is unpressed
	press <= 1;	  repeat(3) @(posedge clk); // off state: key is pressed
	press <= 0;	  repeat(3) @(posedge clk); // on state: key is released
	press <= 1;	  repeat(3) @(posedge clk); // off state: key is pressed
	
	$stop; // End the simulation.
	end
endmodule