module snake_walk ( input logic Reset, vga_clk,
						  input [9:0] DrawX, DrawY, 
						  input [9:0] SnakeX, SnakeY,
						  
						  input [7:0] keycode,
						  
						  // another stage: make another variable
				
						  output logic [3:0] s_redleft, s_redright, s_redup, s_reddown,
													s_greenleft, s_greenright, s_greenup, s_greendown,
													s_blueleft, s_blueright, s_blueup, s_bluedown
);

enum logic [5:0] { not_moving, s_upone, s_uptwo, s_upthree, s_upfour,
						 s_downone, s_downtwo, s_downthree, s_downfour,
						 s_leftone, s_lefttwo, s_leftthree, s_leftfour,
						 s_rightone, s_righttwo, s_rightthree, s_rightfour} cur_state, next_state;
						 
						 
reg [31:0] count;

logic flag;

// declaring variables to be used
//logic [3:0]  s_left_red, 	 s_right_red,   s_up_red,   s_down_red,
//				 s_left_green,  s_right_green, s_up_green, s_down_green,
//				 s_left_blue,   s_right_blue,  s_up_blue,  s_down_blue;
				
				
				
logic [10:0] sdown_rom_address, sup_rom_address, sleft_rom_address, sright_rom_address;

// other sprite motion animation
logic [10:0] sdown2_rom_address, sup2_rom_address, sleft2_rom_address, sright2_rom_address;

// rom address
logic [4:0] sdown_rom_q, sup_rom_q, sleft_rom_q, sright_rom_q;

// rom address for other motion
logic [4:0] sdown2_rom_q, sup2_rom_q, sleft2_rom_q, sright2_rom_q;

// palettes
logic [3:0] sdpalette_red, sdpalette_green, sdpalette_blue,
				supalette_red, supalette_green, supalette_blue,
				srpalette_red, srpalette_green, srpalette_blue,
				slpalette_red, slpalette_green, slpalette_blue; 
				
logic [3:0] sd2palette_red, sd2palette_green, sd2palette_blue,
				su2palette_red, su2palette_green, su2palette_blue,
				sr2palette_red, sr2palette_green, sr2palette_blue,
				sl2palette_red, sl2palette_green, sl2palette_blue; 


// Creates snake sprite
// down - first motion
snake_downred_rom snake_down_rom (
	.clock   (vga_clk),
	.address (sdown_rom_address),
	.q       (sdown_rom_q)
	
);

snake_downred_palette snake_down_palette (
	.index (sdown_rom_q),
	.red   (sdpalette_red),
	.green (sdpalette_green),
	.blue  (sdpalette_blue)
);

// down - second motion
snake_down2_rom s2_down_rom (
	.clock   (vga_clk),
	.address (sdown2_rom_address),
	.q       (sdown2_rom_q)
);

snake_down2_palette s2_down_palette (
	.index (sdown2_rom_q),
	.red   (sd2palette_red),
	.green (sd2palette_green),
	.blue  (sd2palette_blue)
);

// up - first motion
snake_upred_rom snake_up_rom (
	.clock   (vga_clk),
	.address (sup_rom_address),
	.q       (sup_rom_q)
);

snake_upred_palette snake_up_palette (
	.index (sup_rom_q),
	.red   (supalette_red),
	.green (supalette_green),
	.blue  (supalette_blue)
);

// up - second motion
snake_up2_rom s2_up_rom (
	.clock   (vga_clk),
	.address (sup2_rom_address),
	.q       (sup2_rom_q)
);

snake_up2_palette s2_up_palette (
	.index (sup2_rom_q),
	.red   (su2palette_red),
	.green (su2palette_green),
	.blue  (su2palette_blue)
);

// right - first motion
snake_rightred_rom snake_right_rom (
	.clock   (vga_clk),
	.address (sright_rom_address),
	.q       (sright_rom_q)
);

snake_rightred_palette snake_right_palette (
	.index (sright_rom_q),
	.red   (srpalette_red),
	.green (srpalette_green),
	.blue  (srpalette_blue)
);

// right - second motion
snake_rightnew_rom s2_right_rom (
	.clock   (vga_clk),
	.address (sright2_rom_address),
	.q       (sright2_rom_q)
);

snake_rightnew_palette s2_right_palette (
	.index (sright2_rom_q),
	.red   (sr2palette_red),
	.green (sr2palette_green),
	.blue  (sr2palette_blue)
);


// left - first motion
snake_leftred_rom snake_left_rom (
	.clock   (vga_clk),
	.address (sleft_rom_address),
	.q       (sleft_rom_q)
);

snake_leftred_palette snake_left_palette (
	.index (sleft_rom_q),
	.red   (slpalette_red),
	.green (slpalette_green),
	.blue  (slpalette_blue)
);

// left - second motion
snake_leftnew_rom s2_left_rom (
	.clock   (vga_clk),
	.address (sleft2_rom_address),
	.q       (sleft2_rom_q)
);

snake_leftnew_palette s2_left_palette (
	.index (sleft2_rom_q),
	.red   (sl2palette_red),
	.green (sl2palette_green),
	.blue  (sl2palette_blue)
);
				

assign sdown_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sup_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sleft_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sright_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);

assign sdown2_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sup2_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sleft2_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sright2_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);


// similar to guard_control module set up
always@(posedge vga_clk)
begin
	if(flag) 
		count <= 0;
	
	else
		count <= count + 1;
end


always_ff @ (posedge vga_clk or posedge Reset)
begin
	if (Reset)
	begin
		cur_state <= not_moving;
		flag <= 1'b0;
	end
	else if (count > 100000)
	begin
		cur_state <= next_state;
		flag <= 1'b1;
	end
	
	else
		flag <= 1'b0;
end	


always_comb
begin
	// Maintain position at default state
	next_state = cur_state;
	
	// default variable instantiations
	// for left sprite 
	s_redleft 	 = slpalette_red;
	s_greenleft = slpalette_green;
	s_blueleft  = slpalette_blue;
	
	// for right sprite
	s_redright   = srpalette_red;
	s_greenright = srpalette_green; 
	s_blueright  = srpalette_blue;
	
	// for up sprite
	s_redup 	 = supalette_red;
	s_greenup = supalette_green; 
	s_blueup  = supalette_blue;	
	
	// for down sprite
	s_reddown 	= sdpalette_red;
	s_greendown = sdpalette_green; 
	s_bluedown  = sdpalette_blue;	

	


	unique case (cur_state)
	not_moving: 
		case(keycode)
		
		// left
		8'h04 : begin	
			next_state = s_leftone;
		end
		
		// right
		8'h07 : begin
			next_state = s_rightone;
		end
		
		// down	
		8'h16 : begin
			next_state = s_downone;
		end
		
		// up 
		8'h1A : begin
			next_state = s_upone;
		end	
		
		default: begin
			next_state = not_moving;
			
		end
	endcase
	
	// Left movement sprite: one -> two -> three -> four
	s_leftone:
		if (keycode == 8'h04)
			next_state = s_lefttwo;
			
		else
			next_state = not_moving;
			
	s_lefttwo:
		if (keycode == 8'h04)
			next_state = s_leftthree;
			
		else
			next_state = not_moving;
			
	s_leftthree:
		if (keycode == 8'h04)
			next_state = s_leftfour;
			
		else
			next_state = not_moving;
			
	s_leftfour:
		if (keycode == 8'h04)
			next_state = s_leftone;
			
		else
			next_state = not_moving;
	
	// Right movement sprite: one -> two -> three -> four
	s_rightone:
		if (keycode == 8'h07)
			next_state = s_righttwo;
			
		else
			next_state = not_moving;
			
	s_righttwo:
		if (keycode == 8'h07)
			next_state = s_rightthree;
			
		else
			next_state = not_moving;
			
	s_rightthree:
		if (keycode == 8'h07)
			next_state = s_rightfour;
			
		else
			next_state = not_moving;
			
	s_rightfour:
		if (keycode == 8'h07)
			next_state = s_rightone;
			
		else
			next_state = not_moving;
			
	// Up movement sprite: one -> two -> three -> four
	s_upone:
		if (keycode == 8'h1A)
			next_state = s_uptwo;
			
		else
			next_state = not_moving;
			
	s_uptwo:
		if (keycode == 8'h1A)
			next_state = s_upthree;
			
		else
			next_state = not_moving;
			
	s_upthree:
		if (keycode == 8'h1A)
			next_state = s_upfour;
			
		else
			next_state = not_moving;
			
	s_upfour:
		if (keycode == 8'h1A)
			next_state = s_upone;
			
		else
			next_state = not_moving;
			
			
			
	// Down movement sprite: one -> two -> three -> four
	s_downone:
		if (keycode == 8'h16)
			next_state = s_downtwo;
			
		else
			next_state = not_moving;
			
	s_downtwo:
		if (keycode == 8'h16)
			next_state = s_downthree;
			
		else
			next_state = not_moving;
			
	s_downthree:
		if (keycode == 8'h16)
			next_state = s_downfour;
			
		else
			next_state = not_moving;
			
	s_downfour:
		if (keycode == 8'h16)
			next_state = s_downone;
			
		else
			next_state = not_moving;
	endcase
	
	case(cur_state)
	
	// Stationary one
	not_moving:
		begin
			s_reddown = sdpalette_red;
			s_greendown = sdpalette_green;
			s_bluedown = sdpalette_blue;
		end
	
	// add first motion palette RGB
	s_leftone:
		begin
		s_redleft  = slpalette_red;
		s_greenleft = slpalette_green;
		s_blueleft = slpalette_blue;
		end
		
	s_lefttwo:
		begin
		s_redleft  = slpalette_red;
		s_greenleft = slpalette_green;
		s_blueleft = slpalette_blue;
		end
	
   // add second motion palette RGB	
	s_leftthree:
		begin
		s_redleft  = sl2palette_red;
		s_greenleft = sl2palette_green;
		s_blueleft = sl2palette_blue;
		end
		
	s_leftfour:
		begin
		s_redleft  = sl2palette_red;
		s_greenleft = sl2palette_green;
		s_blueleft = sl2palette_blue;
		end
		
	// add first motion palette RGB		
	s_rightone:
		begin
		s_redright = srpalette_red;
		s_greenright = srpalette_green;
		s_blueright = srpalette_blue;
		end
		
	s_righttwo:
		begin
		s_redright = srpalette_red;
		s_greenright = srpalette_green;
		s_blueright = srpalette_blue;
		end
		
   // add second motion palette RGB
	s_rightthree:
		begin
		s_redright = sr2palette_red;
		s_greenright = sr2palette_green;
		s_blueright = sr2palette_blue;
		end
		
	s_rightfour:
		begin
		s_redright = sr2palette_red;
		s_greenright = sr2palette_green;
		s_blueright = sr2palette_blue;
		end
		
	// add first motion palette RGB	
	s_upone:
		begin
		s_redup = supalette_red;
		s_greenup = supalette_green;
		s_blueup = supalette_blue;
		end
		
	s_uptwo:
		begin
		s_redup = supalette_red;
		s_greenup = supalette_green;
		s_blueup = supalette_blue;
		end

   // add second motion palette RGB		
	s_upthree:
		begin
		s_redup = su2palette_red;
		s_greenup = su2palette_green;
		s_blueup = su2palette_blue;
		end
	
	s_upfour:
		begin
		s_redup = su2palette_red;
		s_greenup = su2palette_green;
		s_blueup = su2palette_blue;
		end

	// add first motion palette RGB		
	s_downone:
		begin
		s_reddown = sdpalette_red;
		s_greendown = sdpalette_green;
		s_bluedown = sdpalette_blue;
		end
		
	s_downtwo:
		begin
		s_reddown = sdpalette_red;
		s_greendown = sdpalette_green;
		s_bluedown = sdpalette_blue;
		end
		
   // add second motion palette RGB	
	s_downthree:
		begin
		s_reddown = sd2palette_red;
		s_greendown = sd2palette_green;
		s_bluedown = sd2palette_blue;
		end
		
	s_downfour:
		begin
		s_reddown = sd2palette_red;
		s_greendown = sd2palette_green;
		s_bluedown = sd2palette_blue;
		end
	
	endcase
	

	

	
	
end

endmodule




