`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/02 13:40:50
// Design Name: 
// Module Name: tst_div
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


module tst_div();

reg	sys_clk;
reg	sys_rst_n;
reg	signed	[9:0] data_in_10;
reg	signed	[10:0] data_in_11;
wire	signed	[9:0] data_out1;
wire	signed	[9:0] data_out2;
reg [9:0] stimulus[0:30000];
reg [10:0] stimulus11[0:30000];
initial begin
	sys_clk = 0;
	sys_rst_n = 0;
	data_in_10 = 0;
	data_in_11 = 0;
	$readmemb("D:/USEFUL/FILES/NUEDC/23H/NUEDC_23H_8/matlab_to_vivado/signal_r_sin.txt",stimulus);
	$readmemb("D:/USEFUL/FILES/NUEDC/23H/NUEDC_23H_8/matlab_to_vivado/signal_r_sin_11.txt",stimulus11);
	#100
	sys_rst_n = 1;
end


parameter CLK_PERIOD = 20;
always #(CLK_PERIOD/2) sys_clk <= ~sys_clk;


integer Pattern=0;
integer Pattern11=0;

always @(posedge sys_clk)
   begin
	   Pattern=Pattern+1;
	   data_in_10 =stimulus[Pattern];
	   if( Pattern == 30000)	Pattern = 0;
	end
always @(posedge sys_clk)
   begin
	   Pattern11=Pattern11+1;
	   data_in_11 =stimulus11[Pattern11];
	   if( Pattern11 == 30000)	Pattern11 = 0;
	end


div div_inst(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.data_in_10(data_in_10),
	.data_in_11(data_in_11),
	.data_out1(data_out1),
	.data_out2(data_out2)
    );
endmodule
