# Kintex test

# General configuration
set_property CFGBVS VCCO                     [current_design]
set_property CONFIG_VOLTAGE 3.3              [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50  [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

## clock
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD DIFF_SSTL15} [get_ports {clk_p}]; #B33_L14_P
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD DIFF_SSTL15} [get_ports {clk_n}]; #B33_L14_N
create_clock -period 5.000 -name sys_clk_pin -waveform {0.000 2.500} -add [get_ports {clk_p}];

## motherboard IOs
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18} [get_ports {reset_n}]; #B18_L3_P
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports {led0_r}]; #B18_L1_P
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS18} [get_ports {led0_g}]; #B18_L1_N
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS18} [get_ports {led0_b}]; #B18_L4_P
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS18} [get_ports {led1_r}]; #B18_L4_N
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS18} [get_ports {led1_g}]; #B18_L12_P
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS18} [get_ports {led1_b}]; #B18_L12_N
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS18} [get_ports {led2_r}]; #B18_L10_P
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS18} [get_ports {led2_g}]; #B18_L10_N
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS18} [get_ports {led2_b}]; #B18_L20_P
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS18} [get_ports {led3_r}]; #B18_L20_N
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS18} [get_ports {led3_g}]; #B18_L11_P
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS18} [get_ports {led3_b}]; #B18_L11_N

set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS18} [get_ports {btn[0]}]; #B18_L3_N
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS18} [get_ports {btn[1]}]; #B18_L2_P
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports {btn[2]}]; #B18_L2_N

set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS18} [get_ports {sw[0]}]; #B17_L3_P
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18} [get_ports {sw[1]}]; #B17_L3_N
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS18} [get_ports {sw[2]}]; #B17_L7_N
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS18} [get_ports {sw[3]}]; #B17_L7_P

## Ethernet RMII
set_property -dict { PACKAGE_PIN E30    IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; #B16_L18_N
set_property -dict { PACKAGE_PIN A27    IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[0] }]; #B16_L7_N
set_property -dict { PACKAGE_PIN C30    IOSTANDARD LVCMOS33 } [get_ports { eth_tx_en }]; #B16_L16_N
set_property -dict { PACKAGE_PIN C24    IOSTANDARD LVCMOS33 } [get_ports { eth_txd[1] }]; #B16_L8_P
set_property -dict { PACKAGE_PIN B27    IOSTANDARD LVCMOS33 } [get_ports { eth_crs_dv }]; #B16_L7_P
set_property -dict { PACKAGE_PIN D29    IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[1] }]; #B16_L16_P
set_property -dict { PACKAGE_PIN B24    IOSTANDARD LVCMOS33 } [get_ports { eth_txd[0] }]; #B16_L8_N
# set_property -dict { PACKAGE_PIN E29    IOSTANDARD LVCMOS33 } [get_ports { mdc }]; #B16_L18_P
# set_property -dict { PACKAGE_PIN D28    IOSTANDARD LVCMOS33 } [get_ports { mdio }]; #B16_L14_N

## UART
 set_property -dict { PACKAGE_PIN M30    IOSTANDARD LVCMOS33 } [get_ports { uart_rxd }]; #B15_L15_N
set_property -dict { PACKAGE_PIN M29    IOSTANDARD LVCMOS33 } [get_ports { uart_txd }]; #B15_L15_P

## RMII constraint
#create_clock -name eth_ref_clk -period 20 -waveform {0 10} [get_ports eth_ref_clk]
set_property IOB TRUE [get_ports eth_txd]
set_property IOB TRUE [get_ports eth_tx_en]

