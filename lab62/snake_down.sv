module  move_down ( input Reset, frame_clk,
					input [7:0] keycode,
					
               output [9:0]  snake_downX, snake_downY, snake_downS );
					

    logic [9:0] Snake_X_Pos, Snake_X_Motion, Snake_Y_Pos, Snake_Y_Motion, Snake_Size;
	 
    parameter [9:0] Snake_X_Center=320;  // Center position on the X axis
    parameter [9:0] Snake_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Snake_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Snake_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] v_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Snake_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Snake_X_Step=1;      // Step size on the X axis
    parameter [9:0] Snake_Y_Step=1;      // Step size on the Y axis
	 
	 

    assign Snake_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Snake
        if (Reset)  // Asynchronous Reset
		  begin 
            Snake_Y_Motion <= 10'd0; //Snake_Y_Step;
				Snake_X_Motion <= 10'd0; //Snake_X_Step;
				Snake_Y_Pos <= Snake_Y_Center;
				Snake_X_Pos <= Snake_X_Center;
        end
		  
	  
	  else		 
		begin
				  Snake_Y_Pos <= Snake_Y_Pos;  // Snake is somewhere in the middle, don't bounce, just keep moving 
				  Snake_X_Pos <= Snake_X_Pos;  // Snake is somewhere in the middle, don't bounce, just keep moving
					  
					case (keycode)
					
					
					8'h16 : begin			// Down

					       if ( (Snake_Y_Pos + Snake_Size) >= Snake_Y_Max ) 
				 			 begin
//									Snake is at the bottom edge
//									Snake_Y_Motion <= (~ (Snake_Y_Step) + 1'b1);  // 2's complement.
									Snake_Y_Motion<= 1'b0;
									Snake_Y_Pos <= (Snake_Y_Pos + Snake_Y_Motion);
							 end 
							 
							 else
								begin
								Snake_Y_Motion <= 2;//S
								Snake_X_Motion <= 0;
								Snake_Y_Pos <= (Snake_Y_Pos + Snake_Y_Motion);
								Snake_X_Pos <= (Snake_X_Pos + Snake_X_Motion);
					
							 end
							end
							
							
					default: ;
			   endcase
					end 

		end  
//    end
       
    assign snake_downX = Snake_X_Pos;
   
    assign snake_downY = Snake_Y_Pos;
   
    assign snake_downS = Snake_Size;
    					 
endmodule 