`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 10:35:18
// Design Name: 
// Module Name: VCU128_40g_eth_top
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


module VCU128_40g_eth_top#(
    parameter                       P_MIN_LENGTH  = 8'd64    ,
    parameter                       P_MAX_LENGTH  = 15'd9600 ,
    parameter                       P_CHANNEL_NUM = 2           
)(
    input                           i_gt0_refclk_p  ,
    input                           i_gt0_refclk_n  ,
    // input                           i_gt1_refclk_p  ,
    // input                           i_gt1_refclk_n  ,
    input                           i_sys_clk_p     ,
    input                           i_sys_clk_n     ,

    output [1 :0]                   o_staus_led     ,

    output [P_CHANNEL_NUM*4 - 1: 0] o_gt_txp        ,
    output [P_CHANNEL_NUM*4 - 1: 0] o_gt_txn        ,
    input  [P_CHANNEL_NUM*4 - 1: 0] i_gt_rxp        ,
    input  [P_CHANNEL_NUM*4 - 1: 0] i_gt_rxn        

);

wire            w_dclk              ;
wire            w_locked            ;
wire            w_sys_reset         ;

wire            w_gt0_refclk        ;
wire            w_gt0_refclk_out    ;
wire            w_gt1_refclk        ;
wire            w_gt1_refclk_out    ;

wire            w_0_tx_clk_out      ;
wire            w_0_rx_clk_out      ;
wire            w_0_user_tx_reset   ;
wire            w_0_user_rx_reset   ;
wire            w_0_stat_rx_status  ;
wire            w_1_tx_clk_out      ;
wire            w_1_rx_clk_out      ;
wire            w_1_user_tx_reset   ;
wire            w_1_user_rx_reset   ;
wire            w_1_stat_rx_status  ;
wire            w_0_rx_core_clk     ;
wire            w_1_rx_core_clk     ;

wire            tx0_axis_tready     ;
wire            tx0_axis_tvalid     ;
wire [255:0]    tx0_axis_tdata      ;
wire            tx0_axis_tuser      ;
wire [31 :0]    tx0_axis_tkeep      ;
wire            tx0_axis_tlast      ;
wire            rx0_axis_tvalid     ;
wire [255:0]    rx0_axis_tdata      ;
wire            rx0_axis_tuser      ;
wire [31 :0]    rx0_axis_tkeep      ;
wire            rx0_axis_tlast      ;

wire            tx1_axis_tready     ;
wire            tx1_axis_tvalid     ;
wire [255:0]    tx1_axis_tdata      ;
wire            tx1_axis_tuser      ;
wire [31 :0]    tx1_axis_tkeep      ;
wire            tx1_axis_tlast      ;
wire            rx1_axis_tvalid     ;
wire [255:0]    rx1_axis_tdata      ;
wire            rx1_axis_tuser      ;
wire [31 :0]    rx1_axis_tkeep      ;
wire            rx1_axis_tlast      ;

assign o_staus_led = {w_0_stat_rx_status,w_1_stat_rx_status};

ila_axis_rx0 ila_axis_rx0_u0 (
	.clk   (w_0_tx_clk_out), // input wire clk
	.probe0(tx0_axis_tvalid), // input wire [0:0]  probe0  
	.probe1(tx0_axis_tdata ), // input wire [255:0]  probe1 
	.probe2(tx0_axis_tready ), // input wire [0:0]  probe2 
	.probe3(tx0_axis_tkeep ), // input wire [31:0]  probe3 
	.probe4(tx0_axis_tlast ) // input wire [0:0]  probe4
);

ila_axis_rx0 ila_axis_rx0_u1 (
	.clk   (w_0_rx_core_clk), // input wire clk
	.probe0(rx0_axis_tvalid), // input wire [0:0]  probe0  
	.probe1(rx0_axis_tdata ), // input wire [255:0]  probe1 
	.probe2(rx0_axis_tuser ), // input wire [0:0]  probe2 
	.probe3(rx0_axis_tkeep ), // input wire [31:0]  probe3 
	.probe4(rx0_axis_tlast ) // input wire [0:0]  probe4
);

ila_axis_rx0 ila_axis_rx0_u2 (
	.clk   (w_1_tx_clk_out), // input wire clk
	.probe0(tx1_axis_tvalid), // input wire [0:0]  probe0  
	.probe1(tx1_axis_tdata ), // input wire [255:0]  probe1 
	.probe2(tx1_axis_tready ), // input wire [0:0]  probe2 
	.probe3(tx1_axis_tkeep ), // input wire [31:0]  probe3 
	.probe4(tx1_axis_tlast ) // input wire [0:0]  probe4
);

ila_axis_rx0 ila_axis_rx0_u3 (
	.clk   (w_1_rx_core_clk), // input wire clk
	.probe0(rx1_axis_tvalid), // input wire [0:0]  probe0  
	.probe1(rx1_axis_tdata ), // input wire [255:0]  probe1 
	.probe2(rx1_axis_tuser ), // input wire [0:0]  probe2 
	.probe3(rx1_axis_tkeep ), // input wire [31:0]  probe3 
	.probe4(rx1_axis_tlast ) // input wire [0:0]  probe4
);

clk_wiz_100mhz clk_wiz_100mhz_u0
(
    .clk_out1   (w_dclk         ),   
    .locked     (w_locked       ),       
    .clk_in1_p  (i_sys_clk_p    ), 
    .clk_in1_n  (i_sys_clk_n    )  
);

l_ethernet_1_clocking_wrapper i_l_ethernet_1_clocking_wrapper0
(
    .gt_refclk_p            (i_gt0_refclk_p     ),
    .gt_refclk_n            (i_gt0_refclk_n     ),
    .gt_refclk_out          (w_gt0_refclk_out   ),
    .gt_ref_clk             (w_gt0_refclk       )
);

// l_ethernet_1_clocking_wrapper i_l_ethernet_1_clocking_wrapper1
// (
//     .gt_refclk_p            (i_gt1_refclk_p     ),
//     .gt_refclk_n            (i_gt1_refclk_n     ),
//     .gt_refclk_out          (w_gt1_refclk_out   ),
//     .gt_ref_clk             (w_gt1_refclk       )
// );

rst_gen_module#(
    .P_RST_CYCLE            (20)   
)rst_gen_module_u0(
    .i_clk                  (w_dclk         ),
    .i_rst                  (~w_locked      ),
    .o_rst                  (w_sys_reset    ) 
);

AXIS_gen_module AXIS_gen_module_u0(
    .i_clk                  (w_0_tx_clk_out     ),
    .i_rst                  (w_0_user_tx_reset  ),
    .i_stat_rx_status       (w_0_stat_rx_status ),
    .m_axis_tx_tready       (tx0_axis_tready    ),
    .m_axis_tx_tvalid       (tx0_axis_tvalid    ),
    .m_axis_tx_tdata        (tx0_axis_tdata     ),
    .m_axis_tx_tlast        (tx0_axis_tlast     ),
    .m_axis_tx_tkeep        (tx0_axis_tkeep     ),
    .m_axis_tx_tuser        (tx0_axis_tuser     ),
    .s_axis_rx_tvalid       (rx0_axis_tvalid    ),
    .s_axis_rx_tdata        (rx0_axis_tdata     ),
    .s_axis_rx_tlast        (rx0_axis_tlast     ),
    .s_axis_rx_tkeep        (rx0_axis_tkeep     ),
    .s_axis_rx_tuser        (rx0_axis_tuser     ) 
);

AXIS_gen_module AXIS_gen_module_u1(
    .i_clk                  (w_1_tx_clk_out     ),
    .i_rst                  (w_1_user_tx_reset  ),
    .i_stat_rx_status       (w_1_stat_rx_status ),
    .m_axis_tx_tready       (tx1_axis_tready    ),
    .m_axis_tx_tvalid       (tx1_axis_tvalid    ),
    .m_axis_tx_tdata        (tx1_axis_tdata     ),
    .m_axis_tx_tlast        (tx1_axis_tlast     ),
    .m_axis_tx_tkeep        (tx1_axis_tkeep     ),
    .m_axis_tx_tuser        (tx1_axis_tuser     ),
    .s_axis_rx_tvalid       (rx1_axis_tvalid    ),
    .s_axis_rx_tdata        (rx1_axis_tdata     ),
    .s_axis_rx_tlast        (rx1_axis_tlast     ),
    .s_axis_rx_tkeep        (rx1_axis_tkeep     ),
    .s_axis_rx_tuser        (rx1_axis_tuser     ) 
);



uplus_40g_eth_module#(
    .GTYE4_COMMON_QPLL0REFCLKSEL(3'b001),//QSFP1使用本QUAD的GTREFCLK00
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)uplus_40g_eth_module_u0(
    .i_gt_refclk            (w_gt0_refclk       ),
    .i_dclk                 (w_dclk             ),
    .i_sys_rst              (w_sys_reset        ),
    .o_tx_clk_out           (w_0_tx_clk_out     ),
    .o_rx_clk_out           (w_0_rx_clk_out     ),
    .o_rx_core_clk          (w_0_rx_core_clk    ),
    .o_user_tx_reset        (w_0_user_tx_reset  ),
    .o_user_rx_reset        (w_0_user_rx_reset  ),
    .o_stat_rx_status       (w_0_stat_rx_status ),
    .tx_axis_tready         (tx0_axis_tready    ),
    .tx_axis_tvalid         (tx0_axis_tvalid    ),
    .tx_axis_tdata          (tx0_axis_tdata     ),
    .tx_axis_tuser          (tx0_axis_tuser     ),
    .tx_axis_tkeep          (tx0_axis_tkeep     ),
    .tx_axis_tlast          (tx0_axis_tlast     ),
    .rx_axis_tvalid         (rx0_axis_tvalid    ),
    .rx_axis_tdata          (rx0_axis_tdata     ),
    .rx_axis_tuser          (rx0_axis_tuser     ),
    .rx_axis_tkeep          (rx0_axis_tkeep     ),
    .rx_axis_tlast          (rx0_axis_tlast     ),
    .o_gt_txp               (o_gt_txp[4-1 : 0]  ),
    .o_gt_txn               (o_gt_txn[4-1 : 0]  ),
    .i_gt_rxp               (i_gt_rxp[4-1 : 0]  ),
    .i_gt_rxn               (i_gt_rxn[4-1 : 0]  ) 
);

uplus_40g_eth_module#(
    .GTYE4_COMMON_QPLL0REFCLKSEL(3'b011),//QSFP2使用北QUAD的GTNORTHREFCLK00
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)uplus_40g_eth_module_u1(
    .i_gt_refclk            (w_gt0_refclk       ),
    .i_dclk                 (w_dclk             ),
    .i_sys_rst              (w_sys_reset        ),
    .o_tx_clk_out           (w_1_tx_clk_out     ),
    .o_rx_clk_out           (w_1_rx_clk_out     ),
    .o_rx_core_clk          (w_1_rx_core_clk    ),
    .o_user_tx_reset        (w_1_user_tx_reset  ),
    .o_user_rx_reset        (w_1_user_rx_reset  ),
    .o_stat_rx_status       (w_1_stat_rx_status ),
    .tx_axis_tready         (tx1_axis_tready    ),
    .tx_axis_tvalid         (tx1_axis_tvalid    ),
    .tx_axis_tdata          (tx1_axis_tdata     ),
    .tx_axis_tuser          (tx1_axis_tuser     ),
    .tx_axis_tkeep          (tx1_axis_tkeep     ),
    .tx_axis_tlast          (tx1_axis_tlast     ),
    .rx_axis_tvalid         (rx1_axis_tvalid    ),
    .rx_axis_tdata          (rx1_axis_tdata     ),
    .rx_axis_tuser          (rx1_axis_tuser     ),
    .rx_axis_tkeep          (rx1_axis_tkeep     ),
    .rx_axis_tlast          (rx1_axis_tlast     ),
    .o_gt_txp               (o_gt_txp[8-1 : 4]  ),
    .o_gt_txn               (o_gt_txn[8-1 : 4]  ),
    .i_gt_rxp               (i_gt_rxp[8-1 : 4]  ),
    .i_gt_rxn               (i_gt_rxn[8-1 : 4]  ) 
);

endmodule
