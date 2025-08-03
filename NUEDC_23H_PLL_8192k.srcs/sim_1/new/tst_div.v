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
reg	signed	[9:0] data_in;
wire	signed	[9:0] data_out;
reg [9:0] stimulus[0:30000];
reg key1 = 0;
reg key2 = 0;

initial begin
	sys_clk = 0;
	sys_rst_n = 0;
	data_in = 0;
	key1 = 0;
	key2 = 0;
	$readmemb("D:/USEFUL/FILES/NUEDC/23H/NUEDC_23H_8/matlab_to_vivado/sum.txt",stimulus);
	#100
	sys_rst_n = 1;
	#10000
	key2 <= 1;
	#20
	key2 <= 0;
	#10000
	key1 <= 1;
	#20
	key1 <= 0;
	
	
end


parameter CLK_PERIOD = 20;
always #(CLK_PERIOD/2) sys_clk <= ~sys_clk;


integer Pattern=0;

always @(posedge sys_clk)
   begin
	   Pattern=Pattern+1;
	   data_in =stimulus[Pattern];
	   if( Pattern == 30000)	Pattern = 0;
	end

div div_inst(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.key1(key1),
	.key2(key2),
	.data_in(data_in),
	.data_out(data_out)
    );




endmodule
