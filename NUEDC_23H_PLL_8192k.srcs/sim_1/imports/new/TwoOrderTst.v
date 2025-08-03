`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/13 22:08:51
// Design Name: 
// Module Name: TwoOrderTst
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
module TwoOrderTst();


reg			sys_clk;
reg			sys_rst_n;
reg	signed	[9:0]	data_in;
wire	signed	[9:0]	data_out1;
wire	signed	[9:0]	data_out2;

parameter CLK_PERIOD = 20;
reg [9:0] stimulus[0:60000];
initial begin
	sys_clk = 0;
	sys_rst_n = 0;
	data_in = 0;
	$readmemb("D:/USEFUL/FILES/NUEDC/23H/NUEDC_23H_8/matlab_to_vivado/nue13.txt",stimulus);
	#100	sys_rst_n = 1;
end

integer Pattern=0;

always @(posedge sys_clk)begin
	Pattern=Pattern+1;
	data_in =stimulus[Pattern];
	if( Pattern == 59999)	Pattern = 0;
end



always #(CLK_PERIOD/2) sys_clk <= ~sys_clk;


PllTwoOrder PllTwoOrder_Inst(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.Fre1(48'd8796093022),
	.Fre2(48'd10995116277),
	.data_in(data_in),
	.data_out1(data_out1),
	.data_out2(data_out2)
);

endmodule