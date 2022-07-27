// This module uses a 2port ram as FIFO ("Queue")
// it takes input reset, read, and write, if it reads
// it's outputing a 8bit data to outputBus, if it write
// it update the most recent address to the value equal
// to inputBus.
module FIFO  #(parameter depth = 4,
					parameter width = 8)
				  (input logic clk, reset,
					input logic read, write,
					input logic [width-1:0] inputBus,
					output logic empty, full,
					output logic [width-1:0] outputBus);
					
	/* 	Define_Variables_Here		*/
	logic [depth-1:0] w_addr, r_addr;
	logic wr_en;
	
	/*			Instantiate_Your_Dual-Port_RAM_Here			*/
	
	ram_2port RAM (.clk, .wr_en(wr_en), .rd_en(read), .w_addr(w_addr), 
						.r_addr(r_addr), .w_data(inputBus), .r_data(outputBus));
	
	/*			FIFO-Control_Module	*/					
	FIFO_Control #(depth) FC (.clk, .reset, .read(read), .write(write), .wr_en, .empty, 
								  .full, .readAddr(r_addr), .writeAddr(w_addr));
	
endmodule 

module FIFO_testbench();
	
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	
	integer i;
	
	initial begin
																	@(posedge clk);
		reset <= 1;												@(posedge clk);
		reset <= 0;												@(posedge clk);
		for (i = 0; i < 18; i++) begin
			read <= 0; write <= 1;
			inputBus <= i;										@(posedge clk); // test normal w/full/upper boundary
		end
		read <= 1; write <= 1; 
		inputBus <= 8'b11111111;							@(posedge clk); // test w&r
		read <= 1; write <= 0;
		inputBus <= 8'b00000000;			repeat(16)	@(posedge clk); // test normal r
		read <= 0; write <= 0; 								@(posedge clk); // test disenabling
		reset <= 1;												@(posedge clk);
		reset <= 0;	read <= 1;				repeat(2)	@(posedge clk);
		$stop;
	end
endmodule 