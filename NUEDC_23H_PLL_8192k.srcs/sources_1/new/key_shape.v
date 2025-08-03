`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/29 20:36:58
// Design Name: 
// Module Name: key_shape
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


module key_shape(
    input sys_clk,
    input key,
    output reg shape
    );

reg kt = 0;		//存储上一个周期按键状态
reg rs = 0;		//上升沿检测
reg rf = 0;		//下降沿检测


always@(posedge sys_clk)
kt <= key;

always @(posedge sys_clk) begin
rs <= key&(!kt);	//上升沿检测
rf <= (!key)&kt;	//下降沿检测
end

wire [27:0] t20ms = 28'd1000000;
reg [27:0] cn_begin = 0;
reg [27:0] cn_end = 0;

always @(posedge sys_clk)
//按键第一次松开20ms后清零
if((cn_begin == t20ms)&(cn_end == t20ms))
	cn_begin <= 0;
//检测到案件动作，且未计满20ms
else if ((rs)&(cn_begin < t20ms))
	cn_begin <= cn_begin +1;
	//已开始计数，但未满20ms
else if ((cn_begin > 0)&(cn_begin < t20ms))
	cn_begin <= cn_begin +1;
	
always @(posedge sys_clk)
if(cn_end > t20ms)
	cn_end <= 0;
//检测到案件动作，且未计满20ms
else if ((rf)&(cn_begin == t20ms))
	cn_end <= cn_end +1;
	//已开始计数，但未满20ms
else if (cn_end >0)
	cn_end <= cn_end +1;
	
	
//输出按键消抖后的信号
always @(posedge sys_clk)
shape <= (cn_begin == 1)?1'b1:1'b0;

endmodule