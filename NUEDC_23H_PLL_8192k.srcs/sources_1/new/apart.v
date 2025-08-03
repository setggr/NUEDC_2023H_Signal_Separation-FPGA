`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/04 21:22:43
// Design Name: 
// Module Name: apart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apart(
	input			sys_clk,
	input			sys_rst_n,
	input		[8:0]	freq_out1,
	input		[8:0]	freq_out2,
	input	signed	[9:0]	datasum,
	output		[47:0]	Fre1,
	output		[47:0]	Fre2
    );


reg 		[47:0]	Fre1_reg = 0;
reg 		[47:0]	Fre2_reg = 0;
//频率字设置
always @(posedge sys_clk)begin
	if(	freq_out1 <=15'd45)	 Fre2_reg 	<= 	48'd5368709120;
	else if(freq_out1 <=15'd55)	 Fre2_reg 	<= 	48'd6710886400;
	else if(freq_out1 <=15'd65)	 Fre2_reg 	<= 	48'd8053063680;
	else if(freq_out1 <=15'd75)	 Fre2_reg 	<= 	48'd9395240960;
	else if(freq_out1 <=15'd85)	 Fre2_reg 	<= 	48'd10737418240;
	else if(freq_out1 <=15'd95)	 Fre2_reg 	<= 	48'd12079595520;
	else if(freq_out1 <=15'd105)	 Fre2_reg 	<= 	48'd13421772800;
	else if(freq_out1 <=15'd115)	 Fre2_reg 	<= 	48'd14763950080;
	else if(freq_out1 <=15'd125)	 Fre2_reg 	<= 	48'd16106127360;
	else if(freq_out1 <=15'd135)	 Fre2_reg 	<= 	48'd17448304640;
	else if(freq_out1 <=15'd145)	 Fre2_reg 	<= 	48'd18790481920;
	else if(freq_out1 <=15'd155)	 Fre2_reg 	<= 	48'd20132659200;
	else if(freq_out1 <=15'd165)	 Fre2_reg 	<= 	48'd21474836480;
	else if(freq_out1 <=15'd175)	 Fre2_reg 	<= 	48'd22817013760;
	else if(freq_out1 <=15'd185)	 Fre2_reg 	<= 	48'd24159191040;
	else if(freq_out1 <=15'd195)	 Fre2_reg 	<= 	48'd25501368320;
	else if(freq_out1 <=15'd205)	 Fre2_reg 	<= 	48'd26843545600;
	else				 Fre2_reg 	<= 	48'd1280000000; 

	if(	freq_out2 <=15'd45)	 Fre1_reg	<=	48'd5368709120;
	else if(freq_out2 <=15'd55)	 Fre1_reg	<=	48'd6710886400;
	else if(freq_out2 <=15'd65)	 Fre1_reg	<=	48'd8053063680;
	else if(freq_out2 <=15'd75)	 Fre1_reg	<=	48'd9395240960;
	else if(freq_out2 <=15'd85)	 Fre1_reg	<=	48'd10737418240;
	else if(freq_out2 <=15'd95)	 Fre1_reg	<=	48'd12079595520;
	else if(freq_out2 <=15'd105)	 Fre1_reg	<=	48'd13421772800;
	else if(freq_out2 <=15'd115)	 Fre1_reg	<=	48'd14763950080;
	else if(freq_out2 <=15'd125)	 Fre1_reg	<=	48'd16106127360;
	else if(freq_out2 <=15'd135)	 Fre1_reg	<=	48'd17448304640;
	else if(freq_out2 <=15'd145)	 Fre1_reg	<=	48'd18790481920;
	else if(freq_out2 <=15'd155)	 Fre1_reg	<=	48'd20132659200;
	else if(freq_out2 <=15'd165)	 Fre1_reg	<=	48'd21474836480;
	else if(freq_out2 <=15'd175)	 Fre1_reg	<=	48'd22817013760;
	else if(freq_out2 <=15'd185)	 Fre1_reg	<=	48'd24159191040;
	else if(freq_out2 <=15'd195)	 Fre1_reg	<=	48'd25501368320;
	else if(freq_out2 <=15'd205)	 Fre1_reg	<=	48'd26843545600;
	else				 Fre1_reg	<=	48'd1280000000; 
end

assign Fre1 	= 	Fre1_reg;
assign Fre2 	= 	Fre2_reg;
endmodule







   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   











