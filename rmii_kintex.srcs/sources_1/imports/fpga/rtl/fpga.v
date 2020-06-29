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
    output wire       uart_txd
);

wire clk_buf, CLKFB_int, CLKOUT5, CLKOUT6, clk_int, locked;
// Input buffering
IBUFDS u_clkin_buf (
  .O(clk_buf),
  .I(clk_p),
  .IB(clk_n)
);
// Clocking Primitive
MMCME2_ADV #(
  .BANDWIDTH("HIGH"),        // Jitter programming
  .CLKFBOUT_MULT_F(5.000),          // Multiply value for all CLKOUT
  .CLKFBOUT_PHASE(0.0),           // Phase offset in degrees of CLKFB
  .CLKFBOUT_USE_FINE_PS("FALSE"), // Fine phase shift enable (TRUE/FALSE)
  .CLKIN1_PERIOD(5),            // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  .CLKOUT5_DIVIDE(5.000),         // Divide amount for CLKOUT5
  .CLKOUT5_DUTY_CYCLE(0.5),       // Duty cycle for CLKOUT5
  .CLKOUT5_PHASE(0.0),            // Phase offset for CLKOUT5
  .CLKOUT6_DIVIDE(20.000),         // Divide amount for CLKOUT6
  .CLKOUT6_DUTY_CYCLE(0.5),       // Duty cycle for CLKOUT6
  .CLKOUT6_PHASE(0.0),            // Phase offset for CLKOUT6
  .CLKOUT4_USE_FINE_PS("FALSE"),  // Fine phase shift enable (TRUE/FALSE)
  .CLKOUT5_USE_FINE_PS("FALSE"),  // Fine phase shift enable (TRUE/FALSE)
  .CLKOUT6_USE_FINE_PS("FALSE"),  // Fine phase shift enable (TRUE/FALSE)
  .COMPENSATION("ZHOLD"),          // Clock input compensation
  .DIVCLK_DIVIDE(1),              // Master division value
  .STARTUP_WAIT("FALSE")          // Delays DONE until MMCM is locked
  )
MMCME2_ADV_inst (
  .CLKFBOUT     (CLKFB_int),         // 1-bit output: Feedback clock
  .CLKFBOUTB    (),       // 1-bit output: Inverted CLKFBOUT
  .CLKFBSTOPPED (), // 1-bit output: Feedback clock stopped
  .CLKINSTOPPED (), // 1-bit output: Input clock stopped
  .CLKOUT5      (CLKOUT5),           // 1-bit output: CLKOUT5
  .CLKOUT6      (CLKOUT6),           // 1-bit output: CLKOUT6
  .DO           (),                     // 16-bit output: DRP data output
  .DRDY         (),                 // 1-bit output: DRP ready
  .LOCKED       (locked),             // 1-bit output: LOCK
  .PSDONE       (),             // 1-bit output: Phase shift done
  .CLKFBIN      (CLKFB_int),           // 1-bit input: Feedback clock
  .CLKIN1       (clk_buf),             // 1-bit input: Primary clock
  .CLKIN2       (1'b0),             // 1-bit input: Secondary clock
  .CLKINSEL     (1'b1),         // 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
  .DADDR        (7'h0),               // 7-bit input: DRP address
  .DCLK         (1'b0),                 // 1-bit input: DRP clock
  .DEN          (1'b0),                   // 1-bit input: DRP enable
  .DI           (16'h0),                     // 16-bit input: DRP data input
  .DWE          (1'b0),                   // 1-bit input: DRP write enable
  .PSCLK        (1'b0),               // 1-bit input: Phase shift clock
  .PSEN         (1'b0),                 // 1-bit input: Phase shift enable
  .PSINCDEC     (1'b0),         // 1-bit input: Phase shift increment/decrement
  .PWRDWN       (1'b0),             // 1-bit input: Power-down
  .RST          (1'b0)                    // 1-bit input: Reset
);

// Output buffering
BUFG u_mainclk (
  .O(clk_int),
  .I(CLKOUT5)
);

// Output buffering
BUFG u_ethphyclk (
  .O(eth_ref_clk),
  .I(CLKOUT6)
);

sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_int),
    .rst(~locked),
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
