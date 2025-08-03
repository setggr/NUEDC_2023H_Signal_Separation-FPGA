`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/20 14:59:23
// Design Name: 
// Module Name: tst
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


module tst();

// 输入信号
reg         sys_clk;        // 50MHz 主时钟
reg  [9:0]  ad1_data;       // ADC1 模拟输入
reg  [9:0]  ad2_data;       // ADC2 模拟输入
reg         key1;          // 按键1
reg         key2;          // 按键2

// 输出信号
wire        ad1_clk;       // ADC1 时钟
wire        ad1_oe;        // ADC1 输出使能
wire        ad2_clk;       // ADC2 时钟
wire        ad2_oe;        // ADC2 输出使能
wire [9:0]  da1_out;       // DAC1 输出
wire        da1_clk;       // DAC1 时钟
wire [9:0]  da2_out;       // DAC2 输出
wire        da2_clk;       // DAC2 时钟

// 实例化被测模块
FFT_TEST u_FFT_TEST (
    .sys_clk    (sys_clk),
    .ad1_data   (ad1_data),
    .ad2_data   (ad2_data),
    .key1       (key1),
    .key2       (key2),
    .ad1_clk    (ad1_clk),
    .ad1_oe     (ad1_oe),
    .ad2_clk    (ad2_clk),
    .ad2_oe     (ad2_oe),
    .da1_out    (da1_out),
    .da1_clk    (da1_clk),
    .da2_out    (da2_out),
    .da2_clk    (da2_clk)
);
reg [9:0] stimulus[0:30000];

always #10 sys_clk = ~sys_clk;  // 50MHz (周期20ns)


// 初始化输入信号
initial begin
    // 初始状态
    sys_clk = 0;
    ad1_data = 10'd512;  // 初始值（中值）
    ad2_data = 10'd512;
    $readmemb("D:/FPGA/Smart_ZYNQ_SP_SL/Phase-Locked_Loop/data.txt",stimulus);
end

integer Pattern=0;

always @(posedge sys_clk)
   begin
	   Pattern=Pattern+1;
	   ad1_data =stimulus[Pattern];
	   if( ad1_data == 30000)	Pattern = 0;
	end

endmodule