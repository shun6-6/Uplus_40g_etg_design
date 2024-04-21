`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 22:01:14
// Design Name: 
// Module Name: uplus_40g_eth_channel
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


module uplus_40g_eth_channel#(
    parameter       P_MIN_LENGTH = 8'd64      ,
    parameter       P_MAX_LENGTH = 15'd9600
)(
    input           i_dclk              ,
    input           i_sys_rst           ,

    output          o_tx_clk_out        ,
    output          o_rx_clk_out        ,
    output          o_rx_core_clk       ,
    output          o_user_tx_reset     ,
    output          o_user_rx_reset     ,
    output          o_stat_rx_status    ,

    output [0 :0]   o_qpll0reset        ,
    input  [0 :0]   i_qpll0lock         ,
    input  [3 :0]   i_qpll0outclk       ,
    input  [3 :0]   i_qpll0outrefclk    ,
    output [0 :0]   o_qpll1reset        ,
    input  [0 :0]   i_qpll1lock         ,
    input  [3 :0]   i_qpll1outclk       ,
    input  [3 :0]   i_qpll1outrefclk    ,

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

wire            w_gtwiz_reset_tx_datapath_in    ;
wire            w_gtwiz_reset_rx_datapath_in    ;
wire   [3 :0]   w_rxrecclkout                   ;
wire            w_gt_reset_tx_done_out          ;
wire            w_gt_reset_rx_done_out          ;
wire            w_gtwiz_reset_tx_datapath_out   ;
wire            w_gtwiz_reset_rx_datapath_out   ;
wire            w_tx_core_reset                 ;
wire            w_rx_core_reset                 ;
wire            w_rx_serdes_reset               ;
wire            w_gtwiz_reset_all               ;
wire            w_rx_core_clk                   ;

//rx ctrl
wire [55 : 0]   rx_preambleout_0                ;
wire            ctl_rx_test_pattern_0           ;
wire            ctl_rx_enable_0                 ;
wire            ctl_rx_delete_fcs_0             ;
wire            ctl_rx_ignore_fcs_0             ;
wire [14 : 0]   ctl_rx_max_packet_len_0         ;
wire [7 : 0]    ctl_rx_min_packet_len_0         ;
wire            ctl_rx_custom_preamble_enable_0 ;
wire            ctl_rx_check_sfd_0              ;
wire            ctl_rx_check_preamble_0         ;
wire            ctl_rx_process_lfi_0            ;
wire            ctl_rx_force_resync_0           ;
wire [3 : 0]    stat_rx_block_lock_0            ;
wire            stat_rx_framing_err_valid_0_0   ;
wire            stat_rx_framing_err_0_0         ;
wire            stat_rx_framing_err_valid_1_0   ;
wire            stat_rx_framing_err_1_0         ;
wire            stat_rx_framing_err_valid_2_0   ;
wire            stat_rx_framing_err_2_0         ;
wire            stat_rx_framing_err_valid_3_0   ;
wire            stat_rx_framing_err_3_0         ;
wire [3 : 0]    stat_rx_vl_demuxed_0            ;
wire [1 : 0]    stat_rx_vl_number_0_0           ;
wire [1 : 0]    stat_rx_vl_number_1_0           ;
wire [1 : 0]    stat_rx_vl_number_2_0           ;
wire [1 : 0]    stat_rx_vl_number_3_0           ;
wire [3 : 0]    stat_rx_synced_0                ;
wire [3 : 0]    stat_rx_synced_err_0            ;
wire [3 : 0]    stat_rx_mf_len_err_0            ;
wire [3 : 0]    stat_rx_mf_repeat_err_0         ;
wire [3 : 0]    stat_rx_mf_err_0                ;
wire            stat_rx_misaligned_0            ;
wire            stat_rx_aligned_err_0           ;
wire            stat_rx_bip_err_0_0             ;
wire            stat_rx_bip_err_1_0             ;
wire            stat_rx_bip_err_2_0             ;
wire            stat_rx_bip_err_3_0             ;
wire            stat_rx_aligned_0               ;
wire            stat_rx_hi_ber_0                ;
wire [1 : 0]    stat_rx_bad_code_0              ;
wire [1 : 0]    stat_rx_total_packets_0         ;
wire            stat_rx_total_good_packets_0    ;
wire [5 : 0]    stat_rx_total_bytes_0           ;
wire [13 : 0]   stat_rx_total_good_bytes_0      ;
wire [1 : 0]    stat_rx_packet_small_0          ;
wire            stat_rx_jabber_0                ;
wire            stat_rx_packet_large_0          ;
wire            stat_rx_oversize_0              ;
wire [1 : 0]    stat_rx_undersize_0             ;
wire            stat_rx_toolong_0               ;
wire [1 : 0]    stat_rx_fragment_0              ;
wire            stat_rx_packet_64_bytes_0       ;
wire            stat_rx_packet_65_127_bytes_0   ;
wire            stat_rx_packet_128_255_bytes_0  ;
wire            stat_rx_packet_256_511_bytes_0  ;
wire            stat_rx_packet_512_1023_bytes_0 ;
wire            stat_rx_packet_1024_1518_bytes_0;
wire            stat_rx_packet_1519_1522_bytes_0;
wire            stat_rx_packet_1523_1548_bytes_0;
wire [1 : 0]    stat_rx_bad_fcs_0               ;
wire            stat_rx_packet_bad_fcs_0        ;
wire [1 : 0]    stat_rx_stomped_fcs_0           ;
wire            stat_rx_packet_1549_2047_bytes_0;
wire            stat_rx_packet_2048_4095_bytes_0;
wire            stat_rx_packet_4096_8191_bytes_0;
wire            stat_rx_packet_8192_9215_bytes_0;
wire            stat_rx_unicast_0               ;
wire            stat_rx_multicast_0             ;
wire            stat_rx_broadcast_0             ;
wire            stat_rx_vlan_0                  ;
wire            stat_rx_inrangeerr_0            ;
wire            stat_rx_bad_preamble_0          ;
wire            stat_rx_bad_sfd_0               ;
wire            stat_rx_got_signal_os_0         ;
wire [1 : 0]    stat_rx_test_pattern_mismatch_0 ;
wire            stat_rx_truncated_0             ;
wire            stat_rx_local_fault_0           ;
wire            stat_rx_remote_fault_0          ;
wire            stat_rx_internal_local_fault_0  ;
wire            stat_rx_received_local_fault_0  ;
//tx single
wire            tx_unfout_0                     ;
wire [55 : 0]   tx_preamblein_0                 ;
wire            stat_tx_total_packets_0         ;
wire [4 : 0]    stat_tx_total_bytes_0           ;
wire            stat_tx_total_good_packets_0    ;
wire [13 : 0]   stat_tx_total_good_bytes_0      ;
wire            stat_tx_packet_64_bytes_0       ;
wire            stat_tx_packet_65_127_bytes_0   ;
wire            stat_tx_packet_128_255_bytes_0  ;
wire            stat_tx_packet_256_511_bytes_0  ;
wire            stat_tx_packet_512_1023_bytes_0 ;
wire            stat_tx_packet_1024_1518_bytes_0;   
wire            stat_tx_packet_1519_1522_bytes_0;   
wire            stat_tx_packet_1523_1548_bytes_0;
wire            stat_tx_packet_small_0          ;
wire            stat_tx_packet_large_0          ;
wire            stat_tx_packet_1549_2047_bytes_0;
wire            stat_tx_packet_2048_4095_bytes_0;
wire            stat_tx_packet_4096_8191_bytes_0;
wire            stat_tx_packet_8192_9215_bytes_0;
wire            stat_tx_unicast_0               ;
wire            stat_tx_multicast_0             ;
wire            stat_tx_broadcast_0             ;
wire            stat_tx_vlan_0                  ;
wire            stat_tx_bad_fcs_0               ;
wire            stat_tx_frame_error_0           ;
wire            stat_tx_local_fault_0           ;
wire            stat_tx_underflow_err_0         ;
wire            stat_tx_overflow_err_0          ;
wire            ctl_tx_test_pattern_0           ;
wire            ctl_tx_enable_0                 ;
wire            ctl_tx_fcs_ins_enable_0         ;
wire [3 : 0]    ctl_tx_ipg_value_0              ;
wire            ctl_tx_send_lfi_0               ;
wire            ctl_tx_send_rfi_0               ;
wire            ctl_tx_send_idle_0              ;
wire            ctl_tx_custom_preamble_enable_0 ;
wire            ctl_tx_ignore_fcs_0             ;
wire [11 : 0]   gt_loopback_in_0                ;

assign w_gtwiz_reset_tx_datapath = 1'b0;
assign w_gtwiz_reset_rx_datapath = 1'b0;

l_ethernet_1_shared_logic_wrapper i_l_ethernet_1_sharedlogic_wrapper
(
    .gt_txusrclk2_0                 (o_tx_clk_out                   ),
    .gt_rxusrclk2_0                 (o_rx_clk_out                   ),
    .rx_core_clk_0                  (w_rx_core_clk                  ),
    .gt_tx_reset_in_0               (w_gt_reset_tx_done_out|w_gtwiz_reset_tx_datapath_in),
    .gt_rx_reset_in_0               (w_gt_reset_rx_done_out|w_gtwiz_reset_rx_datapath_in),
    .tx_core_reset_in_0             (i_sys_rst),
    .rx_core_reset_in_0             (i_sys_rst),
    .tx_core_reset_out_0            (w_tx_core_reset                ),
    .rx_core_reset_out_0            (w_rx_core_reset                ),
    .usr_tx_reset_0                 (o_user_tx_reset                ),
    .usr_rx_reset_0                 (o_user_rx_reset                ),
    .rx_serdes_reset_out_0          (w_rx_serdes_reset              ),
    .gtwiz_reset_all_0              (w_gtwiz_reset_all              ),
    .gtwiz_reset_tx_datapath_out_0  (w_gtwiz_reset_tx_datapath_out  ),
    .gtwiz_reset_rx_datapath_out_0  (w_gtwiz_reset_rx_datapath_out  ),
    .sys_reset                      (i_sys_rst          ),
    .dclk                           (i_dclk             )
);

l_ethernet_0 l_ethernet_0_u0 (
  .gt_txp_out                       (o_gt_txp                           ),  // output wire [3 : 0] gt_txp_out
  .gt_txn_out                       (o_gt_txn                           ),  // output wire [3 : 0] gt_txn_out
  .gt_rxp_in                        (i_gt_rxp                           ),  // input wire [3 : 0] gt_rxp_in
  .gt_rxn_in                        (i_gt_rxn                           ),  // input wire [3 : 0] gt_rxn_in
  .txoutclksel_in_0                 ({4{3'b101}}                        ),  // input wire [11 : 0] txoutclksel_in_0
  .rxoutclksel_in_0                 ({4{3'b101}}                        ),  // input wire [11 : 0] rxoutclksel_in_0
  .rxrecclkout_0                    (w_rxrecclkout                      ),  // output wire [3 : 0] rxrecclkout_0
  .sys_reset                        (i_sys_rst                          ),  // input wire sys_reset
  .dclk                             (i_dclk                             ),  // input wire dclk
  .gt_reset_tx_done_out_0           (w_gt_reset_tx_done_out             ),  // output wire gt_reset_tx_done_out_0
  .gt_reset_rx_done_out_0           (w_gt_reset_rx_done_out             ),  // output wire gt_reset_rx_done_out_0
  .gt_reset_all_in_0                (w_gtwiz_reset_all                  ),  // input wire gt_reset_all_in_0
  .gt_tx_reset_in_0                 (w_gtwiz_reset_tx_datapath_out      ),  // input wire gt_tx_reset_in_0
  .gt_rx_reset_in_0                 (w_gtwiz_reset_rx_datapath_out      ),  // input wire gt_rx_reset_in_0
  .tx_clk_out_0                     (o_tx_clk_out                       ),  // output wire tx_clk_out_0
  .rx_clk_out_0                     (o_rx_clk_out                       ),  // output wire rx_clk_out_0
  .gtpowergood_out_0                (                                   ),  // output wire [3 : 0] gtpowergood_out_0
  .qpll0_clk_in_0                   (i_qpll0outclk                      ),  // input wire [3 : 0] qpll0_clk_in_0
  .qpll0_refclk_in_0                (i_qpll0outrefclk                   ),  // input wire [3 : 0] qpll0_refclk_in_0
  .qpll1_clk_in_0                   (i_qpll1outclk                      ),  // input wire [3 : 0] qpll1_clk_in_0
  .qpll1_refclk_in_0                (i_qpll1outrefclk                   ),  // input wire [3 : 0] qpll1_refclk_in_0
  .gtwiz_reset_qpll0_lock_in_0      (i_qpll0lock                        ),  // input wire [0 : 0] gtwiz_reset_qpll0_lock_in_0
  .gtwiz_reset_qpll1_lock_in_0      (i_qpll1lock                        ),  // input wire [0 : 0] gtwiz_reset_qpll1_lock_in_0
  .gtwiz_reset_qpll0_reset_out_0    (o_qpll0reset                       ),  // output wire [0 : 0] gtwiz_reset_qpll0_reset_out_0
  .gtwiz_reset_qpll1_reset_out_0    (o_qpll1reset                       ),  // output wire [0 : 0] gtwiz_reset_qpll1_reset_out_0
  .rx_reset_0                       (w_rx_core_reset                    ),  // input wire rx_reset_0
  .rx_serdes_reset_0                (w_rx_serdes_reset                  ),  // input wire rx_serdes_reset_0
  .rx_axis_tvalid_0                 (rx_axis_tvalid                     ),  // output wire rx_axis_tvalid_0
  .rx_axis_tdata_0                  (rx_axis_tdata                      ),  // output wire [255 : 0] rx_axis_tdata_0
  .rx_axis_tuser_0                  (rx_axis_tuser                      ),  // output wire [0 : 0] rx_axis_tuser_0
  .rx_axis_tkeep_0                  (rx_axis_tkeep                      ),  // output wire [31 : 0] rx_axis_tkeep_0
  .rx_axis_tlast_0                  (rx_axis_tlast                      ),  // output wire rx_axis_tlast_0
  .rx_preambleout_0                 (rx_preambleout_0                   ),  // output wire [55 : 0] rx_preambleout_0
  .ctl_rx_test_pattern_0            (ctl_rx_test_pattern_0              ),  // input wire ctl_rx_test_pattern_0
  .ctl_rx_enable_0                  (ctl_rx_enable_0                    ),  // input wire ctl_rx_enable_0
  .ctl_rx_delete_fcs_0              (ctl_rx_delete_fcs_0                ),  // input wire ctl_rx_delete_fcs_0
  .ctl_rx_ignore_fcs_0              (ctl_rx_ignore_fcs_0                ),  // input wire ctl_rx_ignore_fcs_0
  .ctl_rx_max_packet_len_0          (ctl_rx_max_packet_len_0            ),  // input wire [14 : 0] ctl_rx_max_packet_len_0
  .ctl_rx_min_packet_len_0          (ctl_rx_min_packet_len_0            ),  // input wire [7 : 0] ctl_rx_min_packet_len_0
  .ctl_rx_custom_preamble_enable_0  (ctl_rx_custom_preamble_enable_0    ),  // input wire ctl_rx_custom_preamble_enable_0
  .ctl_rx_check_sfd_0               (ctl_rx_check_sfd_0                 ),  // input wire ctl_rx_check_sfd_0
  .ctl_rx_check_preamble_0          (ctl_rx_check_preamble_0            ),  // input wire ctl_rx_check_preamble_0
  .ctl_rx_process_lfi_0             (ctl_rx_process_lfi_0               ),  // input wire ctl_rx_process_lfi_0
  .ctl_rx_force_resync_0            (ctl_rx_force_resync_0              ),  // input wire ctl_rx_force_resync_0
  .stat_rx_block_lock_0             (stat_rx_block_lock_0               ),  // output wire [3 : 0] stat_rx_block_lock_0
  .stat_rx_framing_err_valid_0_0    (stat_rx_framing_err_valid_0_0      ),  // output wire stat_rx_framing_err_valid_0_0
  .stat_rx_framing_err_0_0          (stat_rx_framing_err_0_0            ),  // output wire stat_rx_framing_err_0_0
  .stat_rx_framing_err_valid_1_0    (stat_rx_framing_err_valid_1_0      ),  // output wire stat_rx_framing_err_valid_1_0
  .stat_rx_framing_err_1_0          (stat_rx_framing_err_1_0            ),  // output wire stat_rx_framing_err_1_0
  .stat_rx_framing_err_valid_2_0    (stat_rx_framing_err_valid_2_0      ),  // output wire stat_rx_framing_err_valid_2_0
  .stat_rx_framing_err_2_0          (stat_rx_framing_err_2_0            ),  // output wire stat_rx_framing_err_2_0
  .stat_rx_framing_err_valid_3_0    (stat_rx_framing_err_valid_3_0      ),  // output wire stat_rx_framing_err_valid_3_0
  .stat_rx_framing_err_3_0          (stat_rx_framing_err_3_0            ),  // output wire stat_rx_framing_err_3_0
  .stat_rx_vl_demuxed_0             (stat_rx_vl_demuxed_0               ),  // output wire [3 : 0] stat_rx_vl_demuxed_0
  .stat_rx_vl_number_0_0            (stat_rx_vl_number_0_0              ),  // output wire [1 : 0] stat_rx_vl_number_0_0
  .stat_rx_vl_number_1_0            (stat_rx_vl_number_1_0              ),  // output wire [1 : 0] stat_rx_vl_number_1_0
  .stat_rx_vl_number_2_0            (stat_rx_vl_number_2_0              ),  // output wire [1 : 0] stat_rx_vl_number_2_0
  .stat_rx_vl_number_3_0            (stat_rx_vl_number_3_0              ),  // output wire [1 : 0] stat_rx_vl_number_3_0
  .stat_rx_synced_0                 (stat_rx_synced_0                   ),  // output wire [3 : 0] stat_rx_synced_0
  .stat_rx_synced_err_0             (stat_rx_synced_err_0               ),  // output wire [3 : 0] stat_rx_synced_err_0
  .stat_rx_mf_len_err_0             (stat_rx_mf_len_err_0               ),  // output wire [3 : 0] stat_rx_mf_len_err_0
  .stat_rx_mf_repeat_err_0          (stat_rx_mf_repeat_err_0            ),  // output wire [3 : 0] stat_rx_mf_repeat_err_0
  .stat_rx_mf_err_0                 (stat_rx_mf_err_0                   ),  // output wire [3 : 0] stat_rx_mf_err_0
  .stat_rx_misaligned_0             (stat_rx_misaligned_0               ),  // output wire stat_rx_misaligned_0
  .stat_rx_aligned_err_0            (stat_rx_aligned_err_0              ),  // output wire stat_rx_aligned_err_0
  .stat_rx_bip_err_0_0              (stat_rx_bip_err_0_0                ),  // output wire stat_rx_bip_err_0_0
  .stat_rx_bip_err_1_0              (stat_rx_bip_err_1_0                ),  // output wire stat_rx_bip_err_1_0
  .stat_rx_bip_err_2_0              (stat_rx_bip_err_2_0                ),  // output wire stat_rx_bip_err_2_0
  .stat_rx_bip_err_3_0              (stat_rx_bip_err_3_0                ),  // output wire stat_rx_bip_err_3_0
  .stat_rx_aligned_0                (stat_rx_aligned_0                  ),  // output wire stat_rx_aligned_0
  .stat_rx_hi_ber_0                 (stat_rx_hi_ber_0                   ),  // output wire stat_rx_hi_ber_0
  .stat_rx_status_0                 (o_stat_rx_status                   ),  // output wire stat_rx_status_0
  .stat_rx_bad_code_0               (stat_rx_bad_code_0                 ),  // output wire [1 : 0] stat_rx_bad_code_0
  .stat_rx_total_packets_0          (stat_rx_total_packets_0            ),  // output wire [1 : 0] stat_rx_total_packets_0
  .stat_rx_total_good_packets_0     (stat_rx_total_good_packets_0       ),  // output wire stat_rx_total_good_packets_0
  .stat_rx_total_bytes_0            (stat_rx_total_bytes_0              ),  // output wire [5 : 0] stat_rx_total_bytes_0
  .stat_rx_total_good_bytes_0       (stat_rx_total_good_bytes_0         ),  // output wire [13 : 0] stat_rx_total_good_bytes_0
  .stat_rx_packet_small_0           (stat_rx_packet_small_0             ),  // output wire [1 : 0] stat_rx_packet_small_0
  .stat_rx_jabber_0                 (stat_rx_jabber_0                   ),  // output wire stat_rx_jabber_0
  .stat_rx_packet_large_0           (stat_rx_packet_large_0             ),  // output wire stat_rx_packet_large_0
  .stat_rx_oversize_0               (stat_rx_oversize_0                 ),  // output wire stat_rx_oversize_0
  .stat_rx_undersize_0              (stat_rx_undersize_0                ),  // output wire [1 : 0] stat_rx_undersize_0
  .stat_rx_toolong_0                (stat_rx_toolong_0                  ),  // output wire stat_rx_toolong_0
  .stat_rx_fragment_0               (stat_rx_fragment_0                 ),  // output wire [1 : 0] stat_rx_fragment_0
  .stat_rx_packet_64_bytes_0        (stat_rx_packet_64_bytes_0          ),  // output wire stat_rx_packet_64_bytes_0
  .stat_rx_packet_65_127_bytes_0    (stat_rx_packet_65_127_bytes_0      ),  // output wire stat_rx_packet_65_127_bytes_0
  .stat_rx_packet_128_255_bytes_0   (stat_rx_packet_128_255_bytes_0     ),  // output wire stat_rx_packet_128_255_bytes_0
  .stat_rx_packet_256_511_bytes_0   (stat_rx_packet_256_511_bytes_0     ),  // output wire stat_rx_packet_256_511_bytes_0
  .stat_rx_packet_512_1023_bytes_0  (stat_rx_packet_512_1023_bytes_0    ),  // output wire stat_rx_packet_512_1023_bytes_0
  .stat_rx_packet_1024_1518_bytes_0 (stat_rx_packet_1024_1518_bytes_0   ),  // output wire stat_rx_packet_1024_1518_bytes_0
  .stat_rx_packet_1519_1522_bytes_0 (stat_rx_packet_1519_1522_bytes_0   ),  // output wire stat_rx_packet_1519_1522_bytes_0
  .stat_rx_packet_1523_1548_bytes_0 (stat_rx_packet_1523_1548_bytes_0   ),  // output wire stat_rx_packet_1523_1548_bytes_0
  .stat_rx_bad_fcs_0                (stat_rx_bad_fcs_0                  ),  // output wire [1 : 0] stat_rx_bad_fcs_0
  .stat_rx_packet_bad_fcs_0         (stat_rx_packet_bad_fcs_0           ),  // output wire stat_rx_packet_bad_fcs_0
  .stat_rx_stomped_fcs_0            (stat_rx_stomped_fcs_0              ),  // output wire [1 : 0] stat_rx_stomped_fcs_0
  .stat_rx_packet_1549_2047_bytes_0 (stat_rx_packet_1549_2047_bytes_0   ),  // output wire stat_rx_packet_1549_2047_bytes_0
  .stat_rx_packet_2048_4095_bytes_0 (stat_rx_packet_2048_4095_bytes_0   ),  // output wire stat_rx_packet_2048_4095_bytes_0
  .stat_rx_packet_4096_8191_bytes_0 (stat_rx_packet_4096_8191_bytes_0   ),  // output wire stat_rx_packet_4096_8191_bytes_0
  .stat_rx_packet_8192_9215_bytes_0 (stat_rx_packet_8192_9215_bytes_0   ),  // output wire stat_rx_packet_8192_9215_bytes_0
  .stat_rx_unicast_0                (stat_rx_unicast_0                  ),  // output wire stat_rx_unicast_0
  .stat_rx_multicast_0              (stat_rx_multicast_0                ),  // output wire stat_rx_multicast_0
  .stat_rx_broadcast_0              (stat_rx_broadcast_0                ),  // output wire stat_rx_broadcast_0
  .stat_rx_vlan_0                   (stat_rx_vlan_0                     ),  // output wire stat_rx_vlan_0
  .stat_rx_inrangeerr_0             (stat_rx_inrangeerr_0               ),  // output wire stat_rx_inrangeerr_0
  .stat_rx_bad_preamble_0           (stat_rx_bad_preamble_0             ),  // output wire stat_rx_bad_preamble_0
  .stat_rx_bad_sfd_0                (stat_rx_bad_sfd_0                  ),  // output wire stat_rx_bad_sfd_0
  .stat_rx_got_signal_os_0          (stat_rx_got_signal_os_0            ),  // output wire stat_rx_got_signal_os_0
  .stat_rx_test_pattern_mismatch_0  (stat_rx_test_pattern_mismatch_0    ),  // output wire [1 : 0] stat_rx_test_pattern_mismatch_0
  .stat_rx_truncated_0              (stat_rx_truncated_0                ),  // output wire stat_rx_truncated_0
  .stat_rx_local_fault_0            (stat_rx_local_fault_0              ),  // output wire stat_rx_local_fault_0
  .stat_rx_remote_fault_0           (stat_rx_remote_fault_0             ),  // output wire stat_rx_remote_fault_0
  .stat_rx_internal_local_fault_0   (stat_rx_internal_local_fault_0     ),  // output wire stat_rx_internal_local_fault_0
  .stat_rx_received_local_fault_0   (stat_rx_received_local_fault_0     ),  // output wire stat_rx_received_local_fault_0
  .tx_reset_0                       (w_tx_core_reset                    ),  // input wire tx_reset_0
  .tx_unfout_0                      (tx_unfout_0                        ),  // output wire tx_unfout_0
  .tx_axis_tready_0                 (tx_axis_tready                     ),  // output wire tx_axis_tready_0
  .tx_axis_tvalid_0                 (tx_axis_tvalid                     ),  // input wire tx_axis_tvalid_0
  .tx_axis_tdata_0                  (tx_axis_tdata                      ),  // input wire [255 : 0] tx_axis_tdata_0
  .tx_axis_tuser_0                  (tx_axis_tuser                      ),  // input wire [0 : 0] tx_axis_tuser_0
  .tx_axis_tkeep_0                  (tx_axis_tkeep                      ),  // input wire [31 : 0] tx_axis_tkeep_0
  .tx_axis_tlast_0                  (tx_axis_tlast                      ),  // input wire tx_axis_tlast_0
  .tx_preamblein_0                  (tx_preamblein_0                    ),  // input wire [55 : 0] tx_preamblein_0
  .stat_tx_total_packets_0          (stat_tx_total_packets_0            ),  // output wire stat_tx_total_packets_0
  .stat_tx_total_bytes_0            (stat_tx_total_bytes_0              ),  // output wire [4 : 0] stat_tx_total_bytes_0
  .stat_tx_total_good_packets_0     (stat_tx_total_good_packets_0       ),  // output wire stat_tx_total_good_packets_0
  .stat_tx_total_good_bytes_0       (stat_tx_total_good_bytes_0         ),  // output wire [13 : 0] stat_tx_total_good_bytes_0
  .stat_tx_packet_64_bytes_0        (stat_tx_packet_64_bytes_0          ),  // output wire stat_tx_packet_64_bytes_0
  .stat_tx_packet_65_127_bytes_0    (stat_tx_packet_65_127_bytes_0      ),  // output wire stat_tx_packet_65_127_bytes_0
  .stat_tx_packet_128_255_bytes_0   (stat_tx_packet_128_255_bytes_0     ),  // output wire stat_tx_packet_128_255_bytes_0
  .stat_tx_packet_256_511_bytes_0   (stat_tx_packet_256_511_bytes_0     ),  // output wire stat_tx_packet_256_511_bytes_0
  .stat_tx_packet_512_1023_bytes_0  (stat_tx_packet_512_1023_bytes_0    ),  // output wire stat_tx_packet_512_1023_bytes_0
  .stat_tx_packet_1024_1518_bytes_0 (stat_tx_packet_1024_1518_bytes_0   ),  // output wire stat_tx_packet_1024_1518_bytes_0
  .stat_tx_packet_1519_1522_bytes_0 (stat_tx_packet_1519_1522_bytes_0   ),  // output wire stat_tx_packet_1519_1522_bytes_0
  .stat_tx_packet_1523_1548_bytes_0 (stat_tx_packet_1523_1548_bytes_0   ),  // output wire stat_tx_packet_1523_1548_bytes_0
  .stat_tx_packet_small_0           (stat_tx_packet_small_0             ),  // output wire stat_tx_packet_small_0
  .stat_tx_packet_large_0           (stat_tx_packet_large_0             ),  // output wire stat_tx_packet_large_0
  .stat_tx_packet_1549_2047_bytes_0 (stat_tx_packet_1549_2047_bytes_0   ),  // output wire stat_tx_packet_1549_2047_bytes_0
  .stat_tx_packet_2048_4095_bytes_0 (stat_tx_packet_2048_4095_bytes_0   ),  // output wire stat_tx_packet_2048_4095_bytes_0
  .stat_tx_packet_4096_8191_bytes_0 (stat_tx_packet_4096_8191_bytes_0   ),  // output wire stat_tx_packet_4096_8191_bytes_0
  .stat_tx_packet_8192_9215_bytes_0 (stat_tx_packet_8192_9215_bytes_0   ),  // output wire stat_tx_packet_8192_9215_bytes_0
  .stat_tx_unicast_0                (stat_tx_unicast_0                  ),  // output wire stat_tx_unicast_0
  .stat_tx_multicast_0              (stat_tx_multicast_0                ),  // output wire stat_tx_multicast_0
  .stat_tx_broadcast_0              (stat_tx_broadcast_0                ),  // output wire stat_tx_broadcast_0
  .stat_tx_vlan_0                   (stat_tx_vlan_0                     ),  // output wire stat_tx_vlan_0
  .stat_tx_bad_fcs_0                (stat_tx_bad_fcs_0                  ),  // output wire stat_tx_bad_fcs_0
  .stat_tx_frame_error_0            (stat_tx_frame_error_0              ),  // output wire stat_tx_frame_error_0
  .stat_tx_local_fault_0            (stat_tx_local_fault_0              ),  // output wire stat_tx_local_fault_0
  .stat_tx_underflow_err_0          (stat_tx_underflow_err_0            ),  // output wire stat_tx_underflow_err_0
  .stat_tx_overflow_err_0           (stat_tx_overflow_err_0             ),  // output wire stat_tx_overflow_err_0
  .ctl_tx_test_pattern_0            (ctl_tx_test_pattern_0              ),  // input wire ctl_tx_test_pattern_0
  .ctl_tx_enable_0                  (ctl_tx_enable_0                    ),  // input wire ctl_tx_enable_0
  .ctl_tx_fcs_ins_enable_0          (ctl_tx_fcs_ins_enable_0            ),  // input wire ctl_tx_fcs_ins_enable_0
  .ctl_tx_ipg_value_0               (ctl_tx_ipg_value_0                 ),  // input wire [3 : 0] ctl_tx_ipg_value_0
  .ctl_tx_send_lfi_0                (ctl_tx_send_lfi_0                  ),  // input wire ctl_tx_send_lfi_0
  .ctl_tx_send_rfi_0                (ctl_tx_send_rfi_0                  ),  // input wire ctl_tx_send_rfi_0
  .ctl_tx_send_idle_0               (ctl_tx_send_idle_0                 ),  // input wire ctl_tx_send_idle_0
  .ctl_tx_custom_preamble_enable_0  (ctl_tx_custom_preamble_enable_0    ),  // input wire ctl_tx_custom_preamble_enable_0
  .ctl_tx_ignore_fcs_0              (ctl_tx_ignore_fcs_0                ),  // input wire ctl_tx_ignore_fcs_0
  .gt_loopback_in_0                 (gt_loopback_in_0                   ),  // input wire [11 : 0] gt_loopback_in_0
  .rx_core_clk_0                    (w_rx_core_clk                      )   // input wire rx_core_clk_0
);

assign w_gtwiz_reset_tx_datapath_in = 0           ;
assign w_gtwiz_reset_rx_datapath_in = 0           ;

assign w_rx_core_clk = o_tx_clk_out ;
assign o_rx_core_clk = w_rx_core_clk;
//rx single 
assign ctl_rx_test_pattern_0            = 1'b0  ;
assign ctl_rx_enable_0                  = 1'b1  ;
assign ctl_rx_delete_fcs_0              = 1'b1  ;
assign ctl_rx_ignore_fcs_0              = 1'b0  ;
assign ctl_rx_max_packet_len_0          = P_MAX_LENGTH;
assign ctl_rx_min_packet_len_0          = P_MIN_LENGTH;
assign ctl_rx_custom_preamble_enable_0  = 1'b0  ;
assign ctl_rx_check_sfd_0               = 1'b1  ;
assign ctl_rx_check_preamble_0          = 1'b1  ;
assign ctl_rx_process_lfi_0             = 1'b0  ;
assign ctl_rx_force_resync_0            = 1'b0  ;
//tx single 
assign tx_preamblein_0                  = {7{8'h55}};
assign ctl_tx_test_pattern_0            = 1'b0  ;
assign ctl_tx_enable_0                  = 1'b1  ;
assign ctl_tx_fcs_ins_enable_0          = 1'b1  ;
assign ctl_tx_ipg_value_0               = 4'hC  ;
assign ctl_tx_send_lfi_0                = 1'b0  ;
assign ctl_tx_send_rfi_0                = 1'b0  ;
assign ctl_tx_send_idle_0               = 1'b0  ;
assign ctl_tx_custom_preamble_enable_0  = 1'b0  ;
assign ctl_tx_ignore_fcs_0              = 1'b0  ;
assign gt_loopback_in_0                 = {4{3'b000}};
                  

endmodule
