module shape(clock,ps2_key_pressed,ps2_out,
			ADDR,ADDR_x,ADDR_y,color);
	 
	
	input [18:0] ADDR;
	input [9:0] ADDR_x,ADDR_y;
	output color;
	input [7:0] ps2_out;
	input clock, ps2_key_pressed;
	reg [5:0] x1,y1,x2,y2,x3,y3,x4,y4;
	reg [5:0] sx1,sy1,sx2,sy2,sx3,sy3,sx4,sy4;
	reg [5:0] px1,py1,px2,py2,px3,py3,px4,py4;
	reg [2:0] sel;
	
	reg color;
	
	reg [31:0]  matrix_move[23:0];
	reg [31:0]	matrix_save[23:0];
	
	reg [31:0] count1;
	integer clear;
	integer clear_last;
	
	initial
	begin
		integer row;
		for (row=0;row<24;row=row+1) begin
				matrix_move[row] =32'b0;
			
		end
		for (row=0;row<24;row=row+1) begin
				matrix_save[row] =32'b0;
			
		end
		x1	= 14;
		y1 = 0;
		x2 = 15;
		y2 = 0;
		x3 = 16;
		y3 = 0;
		x4 = 17;
		y4 = 0;
		matrix_move[y1][x1] =1;
		matrix_move[y2][x2] =1;
		matrix_move[y3][x3] =1;
		matrix_move[y4][x4] =1;
	end
	
	
always@(posedge clock) 
begin
	sel = (ADDR_x * 8 /3 /3 * 2 -2) % 5;
	count1 = count1 + 1;		
		
	if (count1==25000000)
	begin
		px1 = x1;
		py1 = y1;
		px2 = x2;
		py2 = y2;
		px3 = x3;
		py3 = y3;
		px4 = x4;
		py4 = y4;
		y1 = y1+1;
		y2 = y2+1;
		y3 = y3+1;
		y4 = y4+1;
		count1 = 0;
	end
	
	
	if (ps2_key_pressed)
	begin	
		sx1 = x1;
		sy1 = y1;
		sx2 = x2;
		sy2 = y2;
		sx3 = x3;
		sy3 = y3;
		sx4 = x4;
		sy4 = y4;
		
		case (ps2_out)
			8'h23 : 
				if(x1 <= 22 && x2 <= 22 && x3 <= 22 && x4 <= 22 
				&& !matrix_save[y1][x1+1] && !matrix_save[y2][x2+1] && !matrix_save[y3][x3+1] && !matrix_save[y4][x4+1])
				begin
					x1=  x1 + 1;
					x2 = x2 + 1;
					x3 = x3 + 1;
					x4 = x4 + 1;
				end
			8'h1c : 
				if(x1 >= 9 && x2 >=9 && x3 >= 9 && x4 >= 9
				&& !matrix_save[y1][x1-1] && !matrix_save[y2][x2-1] && !matrix_save[y3][x3-1] && !matrix_save[y4][x4-1])
				begin
					x1=  x1 - 1;
					x2 = x2 - 1;
					x3 = x3 - 1;
					x4 = x4 - 1;
				end
			8'h72 :
				if (y1 <= 20 && y2 <=20 && y3 <=20 && y4 <=20)
			   begin
					y1 = y1+3;
					y2 = y2+3;
					y3 = y3+3;
					y4 = y4+3;
				 end
		endcase	
	end
	else 
	begin	
		sx1 = x1;
		sy1 = y1;
		sx2 = x2;
		sy2 = y2;
		sx3 = x3;
		sy3 = y3;
		sx4 = x4;
		sy4 = y4;
		/*if ((y1==23 || y2 == 23 || y3 ==23 || y4 ==23)
		|| (matrix_save[y1+1][x1] || matrix_save[y2+1][x1] ||
			matrix_save[y3+1][x1] || matrix_save[y4+1][x1]))*/
			
		if (y1 <= 23 && y2 <=23 && y3 <=23 && y4 <=23 && !matrix_save[y1][x1]
		 && !matrix_save[y2][x2] && !matrix_save[y3][x3] && !matrix_save[y4][x4])
		begin
		end
		else
		begin		
			matrix_save[y1-1][x1] = 1;
			matrix_save[y2-1][x2] = 1;
			matrix_save[y3-1][x3] = 1;
			matrix_save[y4-1][x4] = 1;
			/*for(clear = 23; clear > 0; clear = clear - 1)
			begin
				if(matrix_save[clear] == 32'h007FFE00)
				begin
					//score = score + 1;
					for(clear_last = clear; clear_last > 0; clear_last = clear_last- 1)
					begin
						matrix_save[clear_last] = matrix_save[clear_last - 1];
					end
							matrix_save[0] = 32'b0;
							clear_last = clear_last - 1;
					end	
			end*/
			case(sel)
				0:begin
					x1 = 14;y1 = 0;
					x2 = 15;y2 = 0;
					x3 = 14;y3 = 1;
					x4 = 15;y4 = 1;
					sel = 1;
					end
				1:begin
					x1 = 15;y1 = 0;
					x2 = 15;y2 = 1;
					x3 = 14;y3 = 1;
					x4 = 16;y4 = 1;
					sel = 2;
				end
				2:begin
					x1 = 14;y1 = 0;
					x2 = 15;y2 = 1;
					x3 = 14;y3 = 1;
					x4 = 16;y4 = 1;
					sel = 3;
				end
				3:begin
					x1 = 14;y1 = 0;
					x2 = 15;y2 = 0;
					x3 = 15;y3 = 1;
					x4 = 16;y4 = 1;
					sel = 4;
				end
					4:begin
					x1 = 14;y1 = 0;
					x2 = 15;y2 = 0;
					x3 = 16;y3 = 0;
					x4 = 17;y4 = 0;
					sel = 0;
				end
				endcase
		end
	end
	
	matrix_move[py1][px1] = 0;
	matrix_move[py2][px2] = 0;
	matrix_move[py3][px3] = 0;
	matrix_move[py4][px4] = 0;
	matrix_move[sy1][sx1] = 0;
	matrix_move[sy2][sx2] = 0;
	matrix_move[sy3][sx3] = 0;
	matrix_move[sy4][sx4] = 0;
	matrix_move[y1][x1] = 1;
	matrix_move[y2][x2] = 1;
	matrix_move[y3][x3] = 1;
	matrix_move[y4][x4] = 1;
	
	for(clear = 23; clear > 0; clear = clear - 1)
	begin
		if(matrix_save[clear] == 32'h00FFFF00)
		begin
					//score = score + 1;
			for(clear_last = clear; clear_last > 0; clear_last = clear_last- 1)
			begin
				matrix_save[clear_last] = matrix_save[clear_last - 1];
			end
			matrix_save[0] = 32'b0;
			clear_last = clear_last - 1;
		end	
	end
	
end
	


reg [5:0] m,n;
always@(ADDR)
begin
		m = ADDR_y/20;
		n = ADDR_x/20;
		color = matrix_move[m][n] || matrix_save[m][n];

end

endmodule
