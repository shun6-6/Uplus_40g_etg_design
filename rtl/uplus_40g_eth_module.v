`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 22:01:14
// Design Name: 
// Module Name: uplus_40g_eth_module
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


module uplus_40g_eth_module#(
    parameter GTYE4_COMMON_QPLL0REFCLKSEL = 3'b001,
    parameter       P_MIN_LENGTH = 8'd64      ,
    parameter       P_MAX_LENGTH = 15'd9600
)(
    input           i_gt_refclk         ,
    input           north_refclk        ,
    input           south_refclk        ,
    input           i_dclk              ,
    input           i_sys_rst           ,
    output          o_tx_clk_out        ,
    output          o_rx_clk_out        ,
    output          o_rx_core_clk       ,
    output          o_user_tx_reset     ,
    output          o_user_rx_reset     ,
    output          o_stat_rx_status    ,

    output          tx_axis_tready      ,
    input           tx_axis_tvalid      ,
    input  [255:0]  tx_axis_tdata       ,
    input           tx_axis_tuser       ,
    input  [31 :0]  tx_axis_tkeep       ,
    input           tx_axis_tlast       ,
    output          rx_axis_tvalid      ,
    output [255:0]  rx_axis_tdata       ,
    output          rx_axis_tuser       ,
    output [31 :0]  rx_axis_tkeep       ,
    output          rx_axis_tlast       ,

    output [3 : 0]  o_gt_txp            ,
    output [3 : 0]  o_gt_txn            ,
    input  [3 : 0]  i_gt_rxp            ,
    input  [3 : 0]  i_gt_rxn            
);

wire w_qpll0reset       ;
wire w_qpll0lock        ;
wire w_qpll0outclk      ;
wire w_qpll0outrefclk   ;
wire w_qpll1reset       ;
wire w_qpll1lock        ;
wire w_qpll1outclk      ;
wire w_qpll1outrefclk   ;

wire [3 :0] w_4channel_qpll0outclk     ;
wire [3 :0] w_4channel_qpll0outrefclk  ;
wire [3 :0] w_4channel_qpll1outclk     ;
wire [3 :0] w_4channel_qpll1outrefclk  ;

assign w_4channel_qpll0outclk    = {4{w_qpll0outclk   }};
assign w_4channel_qpll0outrefclk = {4{w_qpll0outrefclk}};
assign w_4channel_qpll1outclk    = {4{w_qpll1outclk   }};
assign w_4channel_qpll1outrefclk = {4{w_qpll1outrefclk}};

//// GT Common
l_ethernet_1_common_wrapper#(
    .GTYE4_COMMON_QPLL0REFCLKSEL(GTYE4_COMMON_QPLL0REFCLKSEL)

) i_l_ethernet_1_common_wrapper
(
    .refclk                 (i_gt_refclk        ),
    .north_refclk           (north_refclk        ),
    .south_refclk           (south_refclk        ),
    .qpll0reset             (w_qpll0reset       ),
    .qpll0lock              (w_qpll0lock        ),
    .qpll0outclk            (w_qpll0outclk      ),
    .qpll0outrefclk         (w_qpll0outrefclk   ),
    .drpclk_common_in       (i_dclk             ),
    .qpll1reset             (w_qpll1reset       ),
    .qpll1lock              (w_qpll1lock        ),
    .qpll1outclk            (w_qpll1outclk      ),
    .qpll1outrefclk         (w_qpll1outrefclk   )
);


uplus_40g_eth_channel#(
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)uplus_40g_eth_channel_u0(
    .i_dclk                 (i_dclk             ),
    .i_sys_rst              (i_sys_rst          ),
    .o_tx_clk_out           (o_tx_clk_out       ),
    .o_rx_clk_out           (o_rx_clk_out       ),
    .o_rx_core_clk          (o_rx_core_clk      ),
    .o_user_tx_reset        (o_user_tx_reset    ),
    .o_user_rx_reset        (o_user_rx_reset    ),
    .o_stat_rx_status       (o_stat_rx_status   ),
    .o_qpll0reset           (w_qpll0reset       ),
    .i_qpll0lock            (w_qpll0lock        ),
    .i_qpll0outclk          (w_4channel_qpll0outclk      ),
    .i_qpll0outrefclk       (w_4channel_qpll0outrefclk   ),
    .o_qpll1reset           (w_qpll1reset       ),
    .i_qpll1lock            (w_qpll1lock        ),
    .i_qpll1outclk          (w_4channel_qpll1outclk      ),
    .i_qpll1outrefclk       (w_4channel_qpll1outrefclk   ),
    .tx_axis_tready         (tx_axis_tready     ),
    .tx_axis_tvalid         (tx_axis_tvalid     ),
    .tx_axis_tdata          (tx_axis_tdata      ),
    .tx_axis_tuser          (tx_axis_tuser      ),
    .tx_axis_tkeep          (tx_axis_tkeep      ),
    .tx_axis_tlast          (tx_axis_tlast      ),
    .rx_axis_tvalid         (rx_axis_tvalid     ),
    .rx_axis_tdata          (rx_axis_tdata      ),
    .rx_axis_tuser          (rx_axis_tuser      ),
    .rx_axis_tkeep          (rx_axis_tkeep      ),
    .rx_axis_tlast          (rx_axis_tlast      ),
    .o_gt_txp               (o_gt_txp           ),
    .o_gt_txn               (o_gt_txn           ),
    .i_gt_rxp               (i_gt_rxp           ),
    .i_gt_rxn               (i_gt_rxn           ) 
);


endmodule
