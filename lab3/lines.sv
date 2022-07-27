// Cynthia Li
// EE 371 Lab 3
//
// This module takes in a 1-bit value 'draw' and output four 10 or 9 bit value 
// that represent the x/y coordinates of two points of a deliberately selected
// line. It uses a FSM to pass the endpoints for 8 lines: diagonal slope 1, 
// diagonal slope -1, vertical, horizontal, steep diagonal, smooth diagonal.
module lines (
    input logic clk, reset, done, draw,
    output logic [9:0] x0, x1,
    output logic [8:0] y0, y1
);

   logic [9:0] next_x0, next_x1;
   logic [8:0] next_y0, next_y1;

   enum {line_1, line_2, line_3, line_4, line_5,line_6, line_7, line_8} ps, ns;
	
	// the following is the next state and output logic 
	// each case specifies a line with a special slope
   always_comb begin
       case (ps) 
       line_1: begin // diagonal '\' with slope 1
               if (draw) ns = line_2;
               else      ns = ps;
               next_x0 = 0;
               next_y0 = 0;
               next_x1 = 480;
               next_y1 = 480;
                   
       end
       line_2: begin // diagonal '/' with slope -1
               if (draw) ns = line_3;
               else      ns = ps;
               next_x0 = 640;
			      next_y0 = 320;
               next_x1 = 480;
               next_y1 = 480;
       end
       line_3: begin // vertical
               if (draw) ns = line_4;
               else      ns = ps;
               next_x0 = 320;
               next_y0 = 320;
               next_x1 = 320;
               next_y1 = 0; 
       end
       line_4: begin // horiztonal
               if (draw) ns = line_5;
               else      ns = ps;
               next_x0 = 640;
               next_y0 = 320;
               next_x1 = 320;
               next_y1 = 320;
       end
       line_5: begin // steep '/' slope > 1
               if (draw) ns = line_6;
               else      ns = ps;
               next_x0 = 100;
               next_y0 = 400;
               next_x1 = 150;
               next_y1 = 200;
       end
		 line_6: begin // steep'\' slope < -1
              if (draw) ns = line_7;
              else      ns = ps;
              next_x0 = 100;
              next_y0 = 200;
              next_x1 = 150;
              next_y1 = 400;
		 end
		 line_7: begin // smooth '/' slope < 1
               if (draw) ns = line_8;
               else      ns = ps;
               next_x0 = 450;
               next_y0 = 100;
               next_x1 = 600;
               next_y1 = 150;
       end
		 line_8: begin // smooth '/' slope > -1
               if (draw) ns = line_1;
               else      ns = ps;
               next_x0 = 450;
               next_y0 = 150;
               next_x1 = 600;
               next_y1 = 100;
       end
       default: begin
               ns = line_1;
               next_x0 = 0;
               next_y0 = 0;
               next_x1 = 480;
               next_y1 = 480;
       end
       endcase
   end
   
	// the following is the DFF that update present state
	// and the four coordinates
   always_ff @(posedge clk) begin
		if (reset) begin
			ps <= line_1;
         x0 <= 0;
         y0 <= 0;
         x1 <= 480;
         y1 <= 480;
			end
		else begin
			ps <= ns;
         x0 <= next_x0;
         y0 <= next_y0;
         x1 <= next_x1;
         y1 <= next_y1;
			end
   end
endmodule

module lines_testbench();
   logic clk, reset, done, draw;
   logic [9:0] x0, x1;
	logic [8:0] y0, y1;

   lines dut (.*);

	// set up the clock
   parameter CLK_Period = 100;
 	initial begin
 		clk <= 1'b0;
 		forever #(CLK_Period/2) clk <= ~clk;
 	end
	 
 	initial begin 
	draw <= 0; done <= 0;		repeat(2)	@(posedge clk); // test default 
   draw <= 1; done <= 0; 						@(posedge clk); // test draw line 1
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
   draw <= 1; done <= 0; 						@(posedge clk); // test draw line 2
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 3
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 4
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 5
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 6
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 7
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test draw line 8
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 0; 						@(posedge clk); // test go back
   draw <= 0; done <= 0;		repeat(3)	@(posedge clk);
	draw <= 1; done <= 1;						@(posedge clk); // test both
	draw <= 0; done <= 1;		repeat(3)	@(posedge clk); // test done
	$stop;
	end
endmodule