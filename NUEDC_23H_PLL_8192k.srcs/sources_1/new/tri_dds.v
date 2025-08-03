`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/16 17:16:01
// Design Name: 
// Module Name: tri_dds
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


module tri_dds(
	input			sys_clk,
	input			sys_rst_n,
	input		[31:0]	s_axis_config_tdata,
	output		[31:0]	m_axis_data_tdata
    );

wire		[31:0] 	Fword;
reg		[31:0] 	phase_acc;
wire		[9:0]	dac_data;
wire		[9:0]  	rom_addr;
wire	signed	[9:0]	data;
assign rom_addr = phase_acc >>22;
assign			Fword = s_axis_config_tdata;

always @(posedge sys_clk or negedge sys_rst_n) begin
if (!sys_rst_n)		phase_acc <= 32'd0;
else			phase_acc <= phase_acc + Fword;      
end


ROM_tri tri_dds //三角波
(
.clka(sys_clk ),  
.ena(1'b1    ),     
.addra(rom_addr), 
.douta(dac_data)  
);
assign data = dac_data - 512;
assign m_axis_data_tdata = {6'd0,data,6'd0,data};




endmodule
