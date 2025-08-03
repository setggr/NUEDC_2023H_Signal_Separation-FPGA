`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 22:08:43
// Design Name: 
// Module Name: Cal_pwoer
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


module Cal_pwoer(
	input sys_clk,
	input [31:0] out_re1_f1,
	input [31:0] out_im1_f1,
	output [63:0] power
    );

wire 		[63:0] 	xk_rsq,xk_isq;
//实部平方和虚部平方
mult_re32_im32_p64_dls6 re_mult(
	.CLK(sys_clk),
	.A(out_re1_f1),     	//IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	.B(out_re1_f1),      	//IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	.P(xk_rsq)      		//OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );

mult_re32_im32_p64_dls6 im_mult(
	.CLK(sys_clk),
	.A(out_im1_f1),     	//IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	.B(out_im1_f1),      	//IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	.P(xk_isq)      		//OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );

//功率（峰值）
assign 	power = xk_isq + xk_rsq;



endmodule
