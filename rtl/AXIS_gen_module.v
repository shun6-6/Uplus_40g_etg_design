`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 11:28:39
// Design Name: 
// Module Name: AXIS_gen_module
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


module AXIS_gen_module(
    input           i_clk               ,
    input           i_rst               ,
    input           i_stat_rx_status    ,

    input           m_axis_tx_tready    ,
    output          m_axis_tx_tvalid    ,
    output [255:0]  m_axis_tx_tdata     ,
    output          m_axis_tx_tlast     ,
    output [31 :0]  m_axis_tx_tkeep     ,
    output          m_axis_tx_tuser     ,

    input           s_axis_rx_tvalid    ,
    input [255:0]   s_axis_rx_tdata     ,
    input           s_axis_rx_tlast     ,
    input [31 :0]   s_axis_rx_tkeep     ,
    input           s_axis_rx_tuser     
);

localparam  P_SEND_LEN = 10;
localparam  P_SRC_MAC = 48'h01_02_03_04_05_06;
localparam  P_DST_MAC = 48'hff_ff_ff_ff_ff_ff;
localparam  P_TYPE    = 16'h0800            ;

reg             rm_axis_tx_tvalid   = 'd0;
reg  [255:0]    rm_axis_tx_tdata    = 'd0;
reg             rm_axis_tx_tlast    = 'd0;
reg  [31 :0]    rm_axis_tx_tkeep    = 'd0;
reg  [5 : 0]    r_init_cnt          = 'd0;
reg             ri_stat_rx_status   = 'd0;
reg  [15: 0]    r_send_cnt          = 'd0;

wire            w_send_en           ;
wire            w_tx_active         ;

assign m_axis_tx_tvalid = rm_axis_tx_tvalid;
assign m_axis_tx_tdata  = { rm_axis_tx_tdata[7  :  0],rm_axis_tx_tdata[15 :  8],
                            rm_axis_tx_tdata[23 : 16],rm_axis_tx_tdata[31 : 24],
                            rm_axis_tx_tdata[39 : 32],rm_axis_tx_tdata[47 : 40],
                            rm_axis_tx_tdata[55 : 48],rm_axis_tx_tdata[63 : 56],

                            rm_axis_tx_tdata[71 : 64],rm_axis_tx_tdata[79 : 72],
                            rm_axis_tx_tdata[87 : 80],rm_axis_tx_tdata[95 : 88],
                            rm_axis_tx_tdata[103: 96],rm_axis_tx_tdata[111:104],
                            rm_axis_tx_tdata[119:112],rm_axis_tx_tdata[127:120],

                            rm_axis_tx_tdata[135:128],rm_axis_tx_tdata[143:136],
                            rm_axis_tx_tdata[151:144],rm_axis_tx_tdata[159:152],
                            rm_axis_tx_tdata[167:160],rm_axis_tx_tdata[175:168],
                            rm_axis_tx_tdata[183:176],rm_axis_tx_tdata[191:184],

                            rm_axis_tx_tdata[199:192],rm_axis_tx_tdata[207:200],
                            rm_axis_tx_tdata[215:208],rm_axis_tx_tdata[223:216],
                            rm_axis_tx_tdata[231:224],rm_axis_tx_tdata[239:232],
                            rm_axis_tx_tdata[247:240],rm_axis_tx_tdata[255:248]} ;
assign m_axis_tx_tlast  = rm_axis_tx_tlast ;
assign m_axis_tx_tkeep  = { rm_axis_tx_tkeep[0],rm_axis_tx_tkeep[1],
                            rm_axis_tx_tkeep[2],rm_axis_tx_tkeep[3],
                            rm_axis_tx_tkeep[4],rm_axis_tx_tkeep[5],
                            rm_axis_tx_tkeep[6],rm_axis_tx_tkeep[7],

                            rm_axis_tx_tkeep[8],rm_axis_tx_tkeep[9],
                            rm_axis_tx_tkeep[10],rm_axis_tx_tkeep[11],
                            rm_axis_tx_tkeep[12],rm_axis_tx_tkeep[13],
                            rm_axis_tx_tkeep[14],rm_axis_tx_tkeep[15],

                            rm_axis_tx_tkeep[16],rm_axis_tx_tkeep[17],
                            rm_axis_tx_tkeep[18],rm_axis_tx_tkeep[19],
                            rm_axis_tx_tkeep[20],rm_axis_tx_tkeep[21],
                            rm_axis_tx_tkeep[22],rm_axis_tx_tkeep[23],

                            rm_axis_tx_tkeep[24],rm_axis_tx_tkeep[25],
                            rm_axis_tx_tkeep[26],rm_axis_tx_tkeep[27],
                            rm_axis_tx_tkeep[28],rm_axis_tx_tkeep[29],
                            rm_axis_tx_tkeep[30],rm_axis_tx_tkeep[31]} ;
assign m_axis_tx_tuser  = 'd0 ;

assign w_send_en   = &r_init_cnt;
assign w_tx_active = rm_axis_tx_tvalid & m_axis_tx_tready;

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_stat_rx_status <= 'd0;
    else
        ri_stat_rx_status <= i_stat_rx_status;
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_init_cnt <= 'd0;
    else if(&r_init_cnt)
        r_init_cnt <= r_init_cnt;
    else if(i_stat_rx_status)
        r_init_cnt <= r_init_cnt + 1;
    else
        r_init_cnt <= r_init_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_send_cnt <= 'd0;
    else if(r_send_cnt == P_SEND_LEN - 1)
        r_send_cnt <= 'd0;
    else if(w_tx_active)
        r_send_cnt <= r_send_cnt + 'd1;
    else
        r_send_cnt <= r_send_cnt;
end

 
 
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_axis_tx_tvalid <= 'd0;
    else if(r_send_cnt == P_SEND_LEN - 1)
        rm_axis_tx_tvalid <= 'd0;
    else if(w_send_en)
        rm_axis_tx_tvalid <= 'd1;
    else
        rm_axis_tx_tvalid <= rm_axis_tx_tvalid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_axis_tx_tdata <= 'd0;
    else if(r_send_cnt == 0 && w_tx_active)
        rm_axis_tx_tdata <= {16{16'haa_bb}};
    else if(r_send_cnt == 0)
        rm_axis_tx_tdata <= {P_DST_MAC,P_SRC_MAC,P_TYPE,{18{8'haa}}};
    else if(w_tx_active)
        rm_axis_tx_tdata <= {16{r_send_cnt}};
    else
        rm_axis_tx_tdata <= rm_axis_tx_tdata;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_axis_tx_tlast <= 'd0;
    else if(r_send_cnt == P_SEND_LEN - 2 && w_tx_active)
        rm_axis_tx_tlast <= 'd1;
    else if(r_send_cnt == P_SEND_LEN - 1 && w_tx_active)
        rm_axis_tx_tlast <= 'd0;
    else
        rm_axis_tx_tlast <= rm_axis_tx_tlast;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_axis_tx_tkeep <= 'd0;
    else
        rm_axis_tx_tkeep <= 32'hffff_ffff;
end

endmodule
