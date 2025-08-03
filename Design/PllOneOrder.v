`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/11 19:37:44
// Design Name: 
// Module Name: PllOneOrder
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


module PllOneOrder(
	input			sys_clk,
	input			sys_rst_n,
	input			signal,
	input		[1:0]	tri_judge,
	input	signed	[9:0]	data_in,
	input	signed	[47:0]	Fre,
	input		[63:0]	Power,
	input			tri_sin_control,
	output	signed	[9:0]	data_out
    );

reg	signed	[9:0]	mult_data;
reg	signed	[9:0]	data_out_reg;
wire	signed	[9:0]	dds_sin;
wire	signed	[9:0]	dds_cos;
wire	signed	[9:0]	tri_data;
wire	signed	[31:0]	m_axis_data_tdata;
wire	signed	[31:0]	m_axis_data_tdata_tri;

//鉴相乘法器输出
wire	signed	[19:0]	pd_mult_out;
wire	signed	[31:0]	pd_filter_out;;

always @(posedge sys_clk)
if(signal == 1'b0 && tri_judge == 2'd0)	begin mult_data <= dds_sin;data_out_reg <= dds_sin; end
else if(signal == 1'b0 && tri_judge == 2'd2)	begin mult_data <= dds_sin;data_out_reg <= dds_sin; end
else if(signal == 1'b0 && tri_judge == 2'd1)	begin mult_data <= tri_data;data_out_reg <= tri_data; end
else if(signal == 1'b0 && tri_judge == 2'd3)	begin mult_data <= tri_data;data_out_reg <= tri_data; end
else if(signal == 1'b1 && tri_judge == 2'd0)	begin mult_data <= dds_sin;data_out_reg <= dds_sin; end
else if(signal == 1'b1 && tri_judge == 2'd1)	begin mult_data <= dds_sin;data_out_reg <= dds_sin; end
else if(signal == 1'b1 && tri_judge == 2'd2)	begin mult_data <= tri_data;data_out_reg <= tri_data; end
else if(signal == 1'b1 && tri_judge == 2'd3)	begin mult_data <= tri_data;data_out_reg <= tri_data; end


mult_a10_b10_p20_dls3 u_mult_a10_b10_p20_dls3(
  .CLK(sys_clk),  // input wire CLK
  .A(data_in),      // input wire [9 : 0] A
  .B(mult_data),      // input wire [9 : 0] B
  .P(pd_mult_out)      // output wire [19 : 0] P
);

//鉴相滤波器
fir_compiler_0 u_fir_compiler_0(
  .aclk(sys_clk),					// input wire aclk
  .aresetn(sys_rst_n),                            	// input wire aresetn
  .s_axis_data_tvalid(1'b1),				// input wire s_axis_data_tvalid
  .s_axis_data_tready(),				// output wire s_axis_data_tready
  .s_axis_data_tdata({4'b0,pd_mult_out}),		// input wire [23 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(),				// output wire m_axis_data_tvalid
  .m_axis_data_tdata(pd_filter_out)			// output wire [31 : 0] m_axis_data_tdata
);

dds_PW41_OW10_PIPProgram_ARESETn u_dds_PW41_OW10_PIPProgram_ARESETn(
  .aclk(sys_clk),                                  	// input wire aclk
  .aresetn(sys_rst_n),                            // input wire aresetn
  .s_axis_config_tvalid(1'b1),  			// input wire s_axis_config_tvalid

  .s_axis_config_tdata(Fre+{{22{pd_filter_out[31]}},pd_filter_out[31:6]}),    // input wire [47 : 0] s_axis_config_tdata
  .m_axis_data_tvalid(),				// output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata)        		// output wire [31 : 0] m_axis_data_tdata
);

tri_dds u_tri_dds(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.s_axis_config_tdata(Fre[40:9]+{{14{pd_filter_out[31]}},pd_filter_out[31:14]}),
	.m_axis_data_tdata(m_axis_data_tdata_tri)
);

assign	dds_sin = m_axis_data_tdata[25:16];
assign	dds_cos = m_axis_data_tdata[9:0];
assign	tri_data= m_axis_data_tdata_tri[9:0];
assign	data_out = data_out_reg;
endmodule
