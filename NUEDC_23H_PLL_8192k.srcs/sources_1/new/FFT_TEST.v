`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/05 22:53:57
// Design Name: 
// Module Name: FFT_TEST
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


module FFT_TEST(
	input sys_clk,			//时钟
	input [9:0] ad1_data,		//输入
	input [9:0] ad2_data,		//

	input key1,			//按钮
	input key2,			//

	output ad1_clk,			//ad时钟
	output ad1_oe,			//使能信号
	output ad2_clk,			//
	output ad2_oe,			//

	output [9:0]da1_out,		//da1输出
	output da1_clk,			//da1时钟
	output [9:0]da2_out,		//da2输出
	output da2_clk			//da2时钟
	);




//复位信号
wire 				clk_8192k;			//全局时钟实际是8.192M
wire 				pll_locked;
reg 				sys_rst_n = 0;			//复位信号
reg 	[15:0] 			reset_counter = 0;

clk_wiz_0 u_clk_wiz_0
   (
    .clk_out1(clk_8192k),
    .reset(1'b0),
    .locked(pll_locked),       		// output locked，用于生成复位信号
    .clk_in1(sys_clk));
always @(posedge clk_8192k) begin
	if (!pll_locked) begin
		reset_counter <= 0;
		sys_rst_n <= 0;
	end else begin
		if (reset_counter < 16'hFFFF) begin
			reset_counter <= reset_counter + 1;
			sys_rst_n <= 0;  			// 保持复位状态
		end else begin
			sys_rst_n <= 1;  			// 释放复位
		end
	end
end
//分离   正弦波 /三角波


//按键消抖
wire keyshape1,	keyshape2;
key_shape u1_key_shape(
    .sys_clk(clk_8192k),
    .key(~key1),
    .shape(keyshape1)
    );
key_shape u2_key_shape(
    .sys_clk(clk_8192k),
    .key(~key2),
    .shape(keyshape2)
    );

//ADDA
wire	signed	[9:0]	data1;
wire	signed	[9:0]	data2;
wire	signed	[9:0]	datasum;
assign	ad1_oe 		=	1'b0;		//始终使能ADC输出
assign	ad1_clk		=	clk_8192k;
assign	ad2_oe 		=	1'b0;		//始终使能ADC输出
assign	ad2_clk		=	clk_8192k;
assign	da1_clk		=	clk_8192k;
assign	da2_clk		=	clk_8192k;
assign	data1 		= 	ad1_data - 512;
assign	data2 		= 	ad2_data - 512;
assign	datasum 	=	(data1+data2)<<<1;
wire 		[31:0] 	out_im1_f1,	out_re1_f1;
wire			m_axis_data_tvalid1;


//傅里叶变换
FFT u_FFT(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.datasum(datasum),
	.out_re1_f1(out_re1_f1),
	.out_im1_f1(out_im1_f1),
	.m_axis_data_tvalid1(m_axis_data_tvalid1)
);
//计算功率
wire 	[63:0] 	power;
Cal_pwoer u_Cal_pwoer(
	.sys_clk(clk_8192k),
	.out_re1_f1(out_re1_f1),
	.out_im1_f1(out_im1_f1),
	.power(power)
);
//FFT输出频率
wire 		[8:0] 	freq_out1,	freq_out2;
wire 		[63:0] 	pow_out1,	pow_out2;
wire		[1:0]	tri_judge;

P_and_F_out u_P_and_F_out(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.m_axis_data_tvalid1(m_axis_data_tvalid1),
	.power(power),
	.freq_out1(freq_out1),
	.freq_out2(freq_out2),
	.pow_out1(pow_out1),
	.pow_out2(pow_out2),
	.tri_judge(tri_judge)
);
wire		[47:0]	Fre1,		Fre2;
wire		[9:0]	data_out1,	data_out2;
wire		[10:0]	Delay;
apart u_apart(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.freq_out1(freq_out1),
	.freq_out2(freq_out2),
	.datasum(datasum),
	.Fre1(Fre1),
	.Fre2(Fre2)
    );

wire tri_sin_control;
  PllOneOrder U1_PllOneOrder(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.signal(1'b0),
	.tri_judge(tri_judge),
	.data_in(datasum),
	.Fre(Fre1),
	.Power(pow_out1),
	.tri_sin_control(tri_sin_control),
	.data_out(data_out1)
    );

  PllOneOrder U2_PllOneOrder(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.signal(1'b1),
	.tri_judge(tri_judge),
	.data_in(datasum),
	.Fre(Fre2),
	.Power(pow_out2),
	.tri_sin_control(tri_sin_control),
	.data_out(data_out2)
    );
wire	signed	[9:0]	data_out1_delay;
wire	signed	[9:0]	data_out2_delay;

outdelay u_outdelay(
	.sys_clk(clk_8192k),
	.sys_rst_n(sys_rst_n),
	.freq_out1(freq_out1),
	.freq_out2(freq_out2),
	.data_out1(data_out1),
	.data_out2(data_out2),
	.data_out1_delay(data_out1_delay),
	.data_out2_delay(data_out2_delay)	
    );



// vio_0 u_vio(
  // .clk(clk_8192k),                // input wire clk
  // .probe_in0(pow_out1),    // input wire [63 : 0] probe_in0
  // .probe_in1(pow_out2),    // input wire [63 : 0] probe_in1
  // .probe_out0(powersize),  // output wire [63 : 0] probe_out0
  // .probe_out1(outputDelay1),  // output wire [11 : 0] probe_out1
  // .probe_out2(outputDelay2),  // output wire [11 : 0] probe_out1
  // .probe_out3(tri_sin_control)  // output wire [11 : 0] probe_out1
// );


assign da1_out =data_out1_delay + 10'd512;
assign da2_out =data_out2_delay + 10'd512;


endmodule

