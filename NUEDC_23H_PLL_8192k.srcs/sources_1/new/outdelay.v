`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/16 16:16:58
// Design Name: 
// Module Name: outdelay
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


module outdelay(
    input			sys_clk,
    input			sys_rst_n,
    input		[8:0]	freq_out1,
    input		[8:0]	freq_out2,
    input	signed	[9:0]	data_out1,
    input	signed	[9:0]	data_out2,
    output	signed	[9:0]	data_out1_delay,
    output	signed	[9:0]	data_out2_delay 
);
reg [10:0] Constant_Delay1;
reg [10:0] Constant_Delay2;

always @(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)begin
	Constant_Delay1 <= 0;
	end
	else if(freq_out2 <= 15'd45	)	 Constant_Delay1 	<= 	11'd292;
	else if(freq_out2 <= 15'd55	)	 Constant_Delay1 	<= 	11'd230;
	else if(freq_out2 <= 15'd65	)	 Constant_Delay1 	<= 	11'd190;
	else if(freq_out2 <= 15'd75	)	 Constant_Delay1 	<= 	11'd160;
	else if(freq_out2 <= 15'd85	)	 Constant_Delay1 	<= 	11'd137;
	else if(freq_out2 <= 15'd95	)	 Constant_Delay1 	<= 	11'd120;
	else if(freq_out2 <= 15'd105	)	 Constant_Delay1 	<= 	11'd106;
	else if(freq_out2 <= 15'd115	)	 Constant_Delay1 	<= 	11'd96;
	else if(freq_out2 <= 15'd125	)	 Constant_Delay1 	<= 	11'd86;
	else if(freq_out2 <= 15'd135	)	 Constant_Delay1 	<= 	11'd78;
	else if(freq_out2 <= 15'd145	)	 Constant_Delay1 	<= 	11'd70;
	else if(freq_out2 <= 15'd155	)	 Constant_Delay1 	<= 	11'd65;
	else if(freq_out2 <= 15'd165	)	 Constant_Delay1 	<= 	11'd60;
	else if(freq_out2 <= 15'd175	)	 Constant_Delay1 	<= 	11'd54;
	else if(freq_out2 <= 15'd185	)	 Constant_Delay1 	<= 	11'd51;
	else if(freq_out2 <= 15'd195	)	 Constant_Delay1 	<= 	11'd47;
	else if(freq_out2 <= 15'd205	)	 Constant_Delay1 	<= 	11'd44;
	else				 	 Constant_Delay1 	<= 	11'd1; 

always @(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)begin
	Constant_Delay2 <= 0;
	end
	else if(freq_out1 <= 15'd45	)	 Constant_Delay2 	<= 	11'd292;
	else if(freq_out1 <= 15'd55	)	 Constant_Delay2 	<= 	11'd230;
	else if(freq_out1 <= 15'd65	)	 Constant_Delay2 	<= 	11'd190;
	else if(freq_out1 <= 15'd75	)	 Constant_Delay2 	<= 	11'd160;
	else if(freq_out1 <= 15'd85	)	 Constant_Delay2 	<= 	11'd137;
	else if(freq_out1 <= 15'd95	)	 Constant_Delay2 	<= 	11'd120;
	else if(freq_out1 <= 15'd105	)	 Constant_Delay2 	<= 	11'd106;
	else if(freq_out1 <= 15'd115	)	 Constant_Delay2 	<= 	11'd96;
	else if(freq_out1 <= 15'd125	)	 Constant_Delay2 	<= 	11'd86;
	else if(freq_out1 <= 15'd135	)	 Constant_Delay2 	<= 	11'd78;
	else if(freq_out1 <= 15'd145	)	 Constant_Delay2 	<= 	11'd70;
	else if(freq_out1 <= 15'd155	)	 Constant_Delay2 	<= 	11'd65;
	else if(freq_out1 <= 15'd165	)	 Constant_Delay2 	<= 	11'd60;
	else if(freq_out1 <= 15'd175	)	 Constant_Delay2 	<= 	11'd54;
	else if(freq_out1 <= 15'd185	)	 Constant_Delay2 	<= 	11'd51;
	else if(freq_out1 <= 15'd195	)	 Constant_Delay2 	<= 	11'd47;
	else if(freq_out1 <= 15'd205	)	 Constant_Delay2 	<= 	11'd44;
	else				 	 Constant_Delay2 	<= 	11'd1; 



localparam ADDR_WIDTH = 12;
reg	[ADDR_WIDTH-1:0]	wr_ptr = 0;
wire	[ADDR_WIDTH-1:0]	rd_addr1, rd_addr2;

// 输出寄存器
reg	signed	[9:0]	data_out1_delay_reg = 0;
reg	signed	[9:0]	data_out2_delay_reg = 0;
wire	signed	[9:0]	data_out1_delay_wire;
wire	signed	[9:0]	data_out2_delay_wire;

assign	rd_addr1 = wr_ptr - Constant_Delay1;
assign	rd_addr2 = wr_ptr - Constant_Delay2;

delayram bram1_inst (
  .clka(sys_clk),
  .wea(1'b1),
  .addra(wr_ptr),
  .dina(data_out1),
  .clkb(sys_clk),  
  .addrb(rd_addr1),
  .doutb(data_out1_delay_wire)
);

delayram bram2_inst (
  .clka(sys_clk),
  .wea(1'b1),
  .addra(wr_ptr),
  .dina(data_out2),
  .clkb(sys_clk),
  .addrb(rd_addr2),
  .doutb(data_out2_delay_wire)
);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        wr_ptr <= 0;
        data_out1_delay_reg <= 0;
        data_out2_delay_reg <= 0;
    end else begin
        wr_ptr <= wr_ptr + 1;
        data_out1_delay_reg <= data_out1_delay_wire;
        data_out2_delay_reg <= data_out2_delay_wire;
    end
end

assign data_out1_delay = data_out1_delay_reg;
assign data_out2_delay = data_out2_delay_reg;

endmodule
