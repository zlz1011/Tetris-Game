module block(clock,ps2_key_pressed,ps2_out,x,y,sel);

	input [7:0] ps2_out;
	input clock, ps2_key_pressed;
	output [9:0]x,y;
	//reg [9:0] x,y;
	output [2:0] sel;
	reg [2:0] sel;
	reg [7:0]x=8'd15, y=8'd0; 
	reg [31:0] count1;
	reg [31:0] count2;
	
	
initial begin
	integer row;
	integer col;
	for (row=0;row<=23;row=row+1) begin
		for (col=0;col<=16;col=col+1) begin
			if (matrix[row][col] ==10'd1)
			begin
				save_y = row*20;
				save_x = 150 + col * 20;
			end
			if (ADDR_x >= save_x && ADDR_x <= save_x+20 && ADDR_y>=save_y && ADDR_y<=save_y+20)
				bgr_data <= 24'hAB0000;
		end
	end

always@(posedge clock) 
begin
	count1 = count1 + 1;		
	count2 = count2 + 1;
	// block drop down
	if (count1==25000000 && (y+1) <= 23 && (sel==0 || sel==2 || sel==3))
	begin
		y = y+1;
		count1 = 0;
	end
	else if (count1==25000000 && (y+2) <= 23 && (sel==1 || sel ==4))
	begin
		y = y+1;
		count1 = 0;
	end
	
	
	if (count2==1175000000)
	begin		
		count1 = 0;
		if (sel == 4)
		begin
			sel = 0;
			count2 = 0;
			x=10'b0101000000;
			y=10'b0; 
		end
		else 	
		begin
			sel = sel + 1;
			count2 = 0;
			x=8'd15;
			y=8'd0; 
		end
	end
	
	if (ps2_key_pressed)
	begin	
		case (ps2_out)
			8'h23 : 
				if(sel ==0 && (x+3) <= 25)
					x = x+1;
				else if(sel ==1 && (x+1) <= 25 )
					x = x+1;
				else if(sel ==2 && (x+2) <= 25 )
					x = x+1;
				else if(sel ==3 && (x+2) <= 25 )
					x = x+1;
				else if(sel ==4 && (x+2) <= 25 )
					x = x+1;	
			8'h1c : 
				if(x >= 9)
					x = x-1;
			/*8'h1d : 
				if(y >= 10)
				y = y-10;
			8'h1b : 
				if((y+110) <= 480)
				y = y+10;*/
		endcase
	end
	
end

endmodule
	
	