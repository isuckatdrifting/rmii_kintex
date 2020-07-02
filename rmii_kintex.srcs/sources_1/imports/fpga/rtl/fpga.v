/*

Copyright (c) 2014-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA top-level module
 */
module fpga (
    /*
     * Clock: 100MHz
     * Reset: Push button, active low
     */
    input wire        clk_p,
    input wire        clk_n,
    input  wire       reset_n,

    /*
     * GPIO
     */
    input  wire [3:0] sw,
    input  wire [2:0] btn,
    output wire       led0_r,
    output wire       led0_g,
    output wire       led0_b,
    output wire       led1_r,
    output wire       led1_g,
    output wire       led1_b,
    output wire       led2_r,
    output wire       led2_g,
    output wire       led2_b,
    output wire       led3_r,
    output wire       led3_g,
    output wire       led3_b,

    /*
     * Ethernet: 100BASE-T RMII
     */
    output wire        eth_ref_clk,
    input wire        eth_crs_dv,
    // input wire        eth_rxerr,
    input wire  [1:0] eth_rxd,
    output wire        eth_tx_en,
    output wire  [1:0] eth_txd,  

    /*
     * UART: 500000 bps, 8N1
     */
    input  wire       uart_rxd,
    output wire       uart_txd,
    output wire       mdc,
    inout wire        mdio
);
assign mdc = 0;
assign mdio = 1;
// Clock and reset

wire clk_ibufg;
wire clk_bufg;
wire clk_mmcm_out;

// Internal 125 MHz clock
wire clk_int;
wire rst_int;

wire mmcm_rst = ~reset_n;
wire mmcm_locked;
wire mmcm_clkfb;

// Input buffering
IBUFGDS u_clkin_buf (
  .O(clk_ibufg),
  .I(clk_p),
  .IB(clk_n)
);

wire clk_50mhz_mmcm_out;
wire clk_50mhz_int;

// MMCM instance
// 100 MHz in, 125 MHz out
// PFD range: 10 MHz to 550 MHz
// VCO range: 600 MHz to 1200 MHz
// M = 10, D = 1 sets Fvco = 1000 MHz (in range)
// Divide by 8 to get output frequency of 125 MHz
// Divide by 40 to get output frequency of 25 MHz
// 1000 / 5 = 200 MHz
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKOUT0_DIVIDE_F(8),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0),
    .CLKOUT1_DIVIDE(20),
    .CLKOUT1_DUTY_CYCLE(0.3),
    .CLKOUT1_PHASE(0),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT2_PHASE(0),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT3_PHASE(0),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT4_PHASE(0),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT5_PHASE(0),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT6_PHASE(0),
    .CLKFBOUT_MULT_F(5),
    .CLKFBOUT_PHASE(0),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.010),
    .CLKIN1_PERIOD(5.0),
    .STARTUP_WAIT("FALSE"),
    .CLKOUT4_CASCADE("FALSE")
)
clk_mmcm_inst (
    .CLKIN1(clk_ibufg),
    .CLKFBIN(mmcm_clkfb),
    .RST(mmcm_rst),
    .PWRDWN(1'b0),
    .CLKOUT0(clk_mmcm_out),
    .CLKOUT0B(),
    .CLKOUT1(clk_50mhz_mmcm_out),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(mmcm_clkfb),
    .CLKFBOUTB(),
    .LOCKED(mmcm_locked)
);

BUFG
clk_bufg_inst (
    .I(clk_mmcm_out),
    .O(clk_int)
);

BUFG
clk_50mhz_bufg_inst (
    .I(clk_50mhz_mmcm_out),
    .O(clk_50mhz_int)
);

sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_int),
    .rst(~mmcm_locked),
    .sync_reset_out(rst_int)
);

// GPIO
wire [2:0] btn_int;
wire [3:0] sw_int;

debounce_switch #(
    .WIDTH(7),
    .N(4),
    .RATE(125000)
)
debounce_switch_inst (
    .clk(clk_int),
    .rst(rst_int),
    .in({btn,
        sw}),
    .out({btn_int,
        sw_int})
);

sync_signal #(
    .WIDTH(1),
    .N(2)
)
sync_signal_inst (
    .clk(clk_int),
    .in({uart_rxd}),
    .out({uart_rxd_int})
);

assign eth_ref_clk = clk_50mhz_int;

// reg [5:0] signal;
// assign rst_int_n = ~rst_int;
// reg [31:0] cnt;
// always @(posedge clk_int or negedge rst_int_n) begin
//   if(!rst_int_n) begin
//     signal <= 'h0; // LEDs are active low
//     cnt <= 0;
//   end else begin
//     if(cnt == 32'd100_000_000) begin
//       cnt <= 0;
//       signal[0] <= ~signal[0];
//       signal[1] <= ~signal[1];
//       signal[2] <= ~signal[2];
//       signal[3] <= ~signal[3];
//       signal[4] <= ~signal[4];
//       signal[5] <= ~signal[5];
//     end else begin
//       cnt <= cnt + 1;
//     end
//   end
// end
// assign eth_crs_dv = signal[0];
// assign eth_rxd[0] = signal[1];
// assign eth_txd[0] = signal[2];
// assign eth_rxd[1] = signal[3];
// assign eth_txd[1] = signal[4];
// assign eth_tx_en = signal[5];
wire rmii2mac_col, rmii2mac_crs, rmii2mac_rx_clk, rmii2mac_tx_clk,
    rmii2mac_rx_dv, rmii2mac_rx_er, mac2rmii_tx_en;
wire [3:0] rmii2mac_rxd, mac2rmii_txd;

fpga_core
core_inst (
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    .clk(clk_int),
    .rst(rst_int),
    /*
     * GPIO
     */
    .btn(btn_int),
    .sw(sw_int),
    .led0_r(led0_r),
    .led0_g(led0_g),
    .led0_b(led0_b),
    .led1_r(led1_r),
    .led1_g(led1_g),
    .led1_b(led1_b),
    .led2_r(led2_r),
    .led2_g(led2_g),
    .led2_b(led2_b),
    .led3_r(led3_r),
    .led3_g(led3_g),
    .led3_b(led3_b),

    /*
     * Ethernet: 100BASE-T MII
     */
    .phy_rx_clk(rmii2mac_rx_clk),
    .phy_rxd(rmii2mac_rxd),
    .phy_rx_dv(rmii2mac_rx_dv),
    .phy_rx_er(rmii2mac_rx_er),
    .phy_tx_clk(rmii2mac_tx_clk),
    .phy_txd(mac2rmii_txd),
    .phy_tx_en(mac2rmii_tx_en),
    .phy_col(rmii2mac_col),
    .phy_crs(rmii2mac_crs),
    .phy_reset_n(eth_rst_n),
    /*
     * UART: 115200 bps, 8N1
     */
    .uart_rxd(uart_rxd_int),
    .uart_txd(uart_txd)
);

mii_to_rmii_0 u_mii_to_rmii(
  .ref_clk        (eth_ref_clk),
  .rst_n          (eth_rst_n),
  .rmii2mac_col   (rmii2mac_col),
  .rmii2mac_crs   (rmii2mac_crs),
  .rmii2mac_rx_clk(rmii2mac_rx_clk),
  .rmii2mac_rx_dv (rmii2mac_rx_dv),
  .rmii2mac_rx_er (rmii2mac_rx_er),
  .rmii2mac_rxd   (rmii2mac_rxd),
  .rmii2mac_tx_clk(rmii2mac_tx_clk),
  .mac2rmii_tx_en (mac2rmii_tx_en),
  .mac2rmii_tx_er (1'b0),
  .mac2rmii_txd   (mac2rmii_txd),

  .phy2rmii_crs_dv(eth_crs_dv),
  .phy2rmii_rx_er (1'b0),
  .phy2rmii_rxd   (eth_rxd),
  .rmii2phy_tx_en (eth_tx_en),
  .rmii2phy_txd   (eth_txd)
);

endmodule
