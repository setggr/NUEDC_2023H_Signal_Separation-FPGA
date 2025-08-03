`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/06 18:07:54
// Design Name: 
// Module Name: tst_fft
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



module tst_fft();

reg	sys_clk;
reg	sys_rst_n;
reg	signed	[9:0] data_in;
wire 		[31:0] 	out_im1_f1,	out_re1_f1;
wire			m_axis_data_tvalid1;

reg [9:0] stimulus[0:16384];
initial begin
	sys_clk = 0;
	sys_rst_n = 0;
	data_in = 0;
	$readmemb("D:/FPGA/Smart_ZYNQ_SP_SL/Phase-Locked_Loop/data.txt",stimulus);
	#100
	sys_rst_n = 1;
end

parameter CLK_PERIOD = 122.0703;
always #(CLK_PERIOD/2) sys_clk <= ~sys_clk;


integer Pattern=0;

always @(posedge sys_clk)
   begin
	   Pattern=Pattern+1;
	   data_in =stimulus[Pattern];
	   if( Pattern == 16383)	Pattern = 0;
	end

FFT u_FFT(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.datasum(data_in),
	.out_re1_f1(out_re1_f1),
	.out_im1_f1(out_im1_f1),
	.m_axis_data_tvalid1(m_axis_data_tvalid1)
);

//计算功率
wire 	[63:0] 	power;
Cal_pwoer u_Cal_pwoer(
	.sys_clk(sys_clk),
	.out_re1_f1(out_re1_f1),
	.out_im1_f1(out_im1_f1),
	.power(power)
);

endmodule

