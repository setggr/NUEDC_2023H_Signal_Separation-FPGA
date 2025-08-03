`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 22:12:28
// Design Name: 
// Module Name: P_and_F_out
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


module P_and_F_out(
	input sys_clk,
	input sys_rst_n,
	input m_axis_data_tvalid1,
	input [63:0] power,
	output [8:0]freq_out1,
	output [8:0]freq_out2,
	output [63:0]pow_out1,
	output [63:0]pow_out2,
	output [1:0]tri_judge
    );

//迭代信号和功率信号
reg 		[15:0]	xk_index1,xk_index2,xk_index3;
reg 		[8:0]	freq1,freq2;
reg 		[63:0]	pow1,pow2;
reg 		[63:0]	power2,power3;


reg [8:0]freq_out1_reg;
reg [8:0]freq_out2_reg;
reg [63:0]pow_out1_reg;
reg [63:0]pow_out2_reg;


//延迟
reg 			ce;		//有效信号
always @(posedge sys_clk)
begin
	if(!sys_rst_n)begin
		xk_index1 	<=	0;
		xk_index2 	<=	0;
		xk_index3 	<=	0;
		power2 		<=	0;
		power3 		<=	0;
	end
	else if(!m_axis_data_tvalid1)
	begin
		xk_index1 	<=	0;
		ce 		<=	1'b1;
	end
	else if(xk_index1 >16'd8191)
		ce 		=	0;
	else if(ce == 1'b1)
	begin
		xk_index1 	<=	xk_index1+1;
		xk_index2 	<=	xk_index1;
		xk_index3 	<=	xk_index2;
		power2 		<=	power;
		power3 		<=	power2;
	end
end


//判断峰值，取出频率和功率
always @(posedge sys_clk)
begin
	if(!sys_rst_n)begin
		freq1 		<=	0;
		freq2 		<=	0;
		freq_out1_reg 	<=	0;
		freq_out2_reg 	<=	0;
		pow1 		<=	0;
		pow2 		<=	0;
		pow_out1_reg 	<=	0;
		pow_out2_reg 	<=	0;
	end
	else if((power2>power)&(power2>power3)&(power2 > 64'd100000000000))
	begin
		pow1 		<=	power2;
		pow2 		<=	pow1;
		freq1 		<=	xk_index3[8:0]-9'd3;
		freq2 		<=	freq1;
	end

	if (xk_index1 > 16'd8191)begin
		freq_out1_reg 	<=	freq1;
		freq_out2_reg 	<=	freq2;
		pow_out1_reg  	<=	pow1 ;
		pow_out2_reg  	<=	pow2 ;
	end

end
reg judge1;
reg judge2;
always @(posedge sys_clk)begin
	if(	pow_out1_reg <= 63'd500000000000 && 			freq_out1_reg <=15'd45) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>45  && freq_out1_reg <=15'd55) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>55  && freq_out1_reg <=15'd65) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>65  && freq_out1_reg <=15'd75) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>75  && freq_out1_reg <=15'd85) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>85  && freq_out1_reg <=15'd95) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>95  && freq_out1_reg <=15'd105) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>105 && freq_out1_reg <=15'd115) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>115 && freq_out1_reg <=15'd125) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>125 && freq_out1_reg <=15'd135) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>135 && freq_out1_reg <=15'd145) 	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>145 && freq_out1_reg <=15'd155)	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>155 && freq_out1_reg <=15'd165)	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>165 && freq_out1_reg <=15'd175)	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>175 && freq_out1_reg <=15'd185)	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>185 && freq_out1_reg <=15'd195)	judge1<=1'd1;
	else if(pow_out1_reg <= 63'd500000000000 &&freq_out1_reg>195 && freq_out1_reg <=15'd205)	judge1<=1'd1;
	else							  				 	judge1<=1'd0;

	if(	pow_out2_reg <= 63'd500000000000 && 			freq_out1_reg <=15'd45)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>45  && freq_out1_reg <=15'd55)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>55  && freq_out1_reg <=15'd65)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>65  && freq_out1_reg <=15'd75)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>75  && freq_out1_reg <=15'd85)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>85  && freq_out1_reg <=15'd95)		judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>95  && freq_out1_reg <=15'd105)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>105 && freq_out1_reg <=15'd115)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>115 && freq_out1_reg <=15'd125)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>125 && freq_out1_reg <=15'd135)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>135 && freq_out1_reg <=15'd145)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>145 && freq_out1_reg <=15'd155)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>155 && freq_out1_reg <=15'd165)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>165 && freq_out1_reg <=15'd175)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>175 && freq_out1_reg <=15'd185)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>185 && freq_out1_reg <=15'd195)	judge2<=1'd1;
	else if(pow_out2_reg <= 63'd500000000000 &&freq_out1_reg>195 && freq_out1_reg <=15'd205)	judge2<=1'd1;
	else							  		 			judge2	<=1'd0;
end

reg [1:0] tri_judge_reg;
always @(posedge sys_clk)
if(judge1 == 1'b0 && judge2 == 1'b0)		tri_judge_reg <= 0;
else if(judge1 == 1'b0 && judge2 == 1'b1)	tri_judge_reg <= 1;
else if(judge1 == 1'b1 && judge2 == 1'b0)	tri_judge_reg <= 2;
else if(judge1 == 1'b1 && judge2 == 1'b1)	tri_judge_reg <= 3;



assign freq_out1 = freq_out1_reg;
assign freq_out2 = freq_out2_reg;
assign pow_out1  = pow_out2_reg ;	//交换以匹配频率
assign pow_out2  = pow_out1_reg ;
assign tri_judge = tri_judge_reg;

endmodule                       
















