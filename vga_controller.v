module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 ps2_key_pressed,
							 ps2_out);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

//New things
input ps2_key_pressed;
input [7:0] ps2_out;
//wire [9:0]x1, y1, x2, y2, x3, y3, x4, y4; 

reg [9:0] ADDR_x, ADDR_y;
//reg [31:0] count;
//input [3:0] motion_in;
//reg [3:0] motion;
/*assign motion_in[0] = motion_in[0];
assign motion_in[1] = motion_in[1];
assign motion_in[2] = motion_in[2];
assign motion_in[3] = motion_in[3];*/
////




assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////  
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
	  ADDR_x = ADDR % 640;
	  ADDR_y = ADDR / 640;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	






wire color;
shape test1shape(VGA_CLK_n,ps2_key_pressed,ps2_out
,ADDR,ADDR_x,ADDR_y,color);




always@(posedge VGA_CLK_n) 
begin	
	if (color==1)
		bgr_data <=24'hAB0000;
	else
		bgr_data <= bgr_data_raw;

		
end

assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////








//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















