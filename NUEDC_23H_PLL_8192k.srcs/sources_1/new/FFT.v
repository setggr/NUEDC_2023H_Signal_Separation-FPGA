`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/29 10:16:56
// Design Name: 
// Module Name: FFT
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


module FFT(
	input sys_clk,
	input sys_rst_n,
	input signed [9:0] datasum,
	output [31:0] 	out_re1_f1,
	output [31:0] 	out_im1_f1,
	output m_axis_data_tvalid1
    );

wire event_frame_started, event_tlast_unexpected, event_tlast_missing, event_status_channel_halt, event_data_in_channel_halt, event_data_out_channel_halt;

reg 		[15:0]	index_fft;

reg 			s_axis_data_tvalid1;	//等于1，持续一个傅里叶变换

wire 			s_axis_data_tready1;	//为1代表准备就绪
// wire			m_axis_data_tvalid1;
//reg m_axis_data_tready1;
wire 			s_axis_config_tready1;

reg 			s_axis_data_last1;	//拉高代表完成
wire 			m_axis_data_last1;


//配置FFT代码
always @(posedge sys_clk) begin
	if (!sys_rst_n) begin
		s_axis_data_tvalid1 <= 1'b0;
		s_axis_data_last1 <= 1'b0;
		index_fft <= 0;
	end
	else begin
		if(s_axis_data_tready1) begin
			s_axis_data_tvalid1 <= 1'b1;
			if(index_fft == 16383) begin
				s_axis_data_last1 <= 1'b1;
				index_fft <= 0;
			end
			else begin
				s_axis_data_last1 <= 1'b0;
				index_fft <= index_fft + 1;
			end
		end
		else begin
			s_axis_data_tvalid1 <= 1'b0;
			s_axis_data_last1 <= 1'b0;
		end
	end
end

//傅里叶变换
xfft_0 u1 (
	.aclk(sys_clk),                                            	// input wire aclk
	.aresetn(sys_rst_n),                                       	// input wire aclken
	.s_axis_config_tdata(8'd1),                  			// input wire [7 : 0] s_axis_config_tdata
	.s_axis_config_tvalid(1'b1),                			// input wire s_axis_config_tvalid
	.s_axis_config_tready(s_axis_config_tready1),                	// output wire s_axis_config_tready
	.s_axis_data_tdata({16'h0000,6'b0,datasum}),		 	//输入高十六位为虚部，低十六位为实
	.s_axis_data_tvalid(s_axis_data_tvalid1),                   	// input wire s_axis_data_tvalid
	.s_axis_data_tready(s_axis_data_tready1),                   	// output wire s_axis_data_tready
	.s_axis_data_tlast(s_axis_data_last1),                      	// input wire s_axis_data_tlast输入完成信号，拉高代表完成
	.m_axis_data_tdata({out_im1_f1,out_re1_f1}),    		//输出都是32位 
	.m_axis_data_tvalid(m_axis_data_tvalid1),                    	// output wire m_axis_data_tvalid
	.m_axis_data_tready(1'b1),                    			// input wire m_axis_data_tready
	.m_axis_data_tlast(m_axis_data_last1),                      	// output wire m_axis_data_tlast
	.event_frame_started(event_frame_started),                  	// output wire event_frame_started
	.event_tlast_unexpected(event_tlast_unexpected),            	// output wire event_tlast_unexpected
	.event_tlast_missing(event_tlast_missing),                  	// output wire event_tlast_missing
	.event_status_channel_halt(event_status_channel_halt),      	// output wire event_status_channel_halt
	.event_data_in_channel_halt(event_data_in_channel_halt),    	// output wire event_data_in_channel_halt
	.event_data_out_channel_halt(event_data_out_channel_halt)); 	// output wire event_data_out_channel_halt

endmodule
