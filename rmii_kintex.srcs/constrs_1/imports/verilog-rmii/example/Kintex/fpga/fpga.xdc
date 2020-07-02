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
# pmod 2
# set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33} [get_ports {eth_ref_clk}]; #B13_L7_P pmod2_1
# set_property -dict {PACKAGE_PIN AC30 IOSTANDARD LVCMOS33} [get_ports {eth_crs_dv}]; #B13_L7_N pmod2_2
# set_property -dict {PACKAGE_PIN AD27 IOSTANDARD LVCMOS33} [get_ports {eth_rxd[0]}]; #B13_L11_P pmod2_3
# set_property -dict {PACKAGE_PIN AD28 IOSTANDARD LVCMOS33} [get_ports {eth_rxd[1]}]; #B13_L11_N pmod2_4
# set_property -dict {PACKAGE_PIN AJ28 IOSTANDARD LVCMOS33} [get_ports {eth_tx_en}]; #B13_L17_P pmod2_5
# set_property -dict {PACKAGE_PIN AJ29 IOSTANDARD LVCMOS33} [get_ports {eth_txd[0]}]; #B13_L17_N pmod2_6
# set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS33} [get_ports {eth_txd[1]}]; #B13_L15_P pmod2_7
# set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS33} [get_ports {pmod_2[7]}]; #B13_L15_N pmod2_8
# pmod 0
# set_property -dict {PACKAGE_PIN AE28 IOSTANDARD LVCMOS25} [get_ports {eth_ref_clk}]; #B13_L14_P
# set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS25} [get_ports {eth_crs_dv}]; #B13_L6_P
# set_property -dict {PACKAGE_PIN AF28 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[0]}]; #B13_L14_N
# set_property -dict {PACKAGE_PIN AB25 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[1]}]; #B13_L6_N
# set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVCMOS25} [get_ports {eth_tx_en}]; #B13_L13_P
# set_property -dict {PACKAGE_PIN AB28 IOSTANDARD LVCMOS25} [get_ports {eth_txd[0]}]; #B13_L5_N
# set_property -dict {PACKAGE_PIN AH29 IOSTANDARD LVCMOS25} [get_ports {eth_txd[1]}]; #B13_L13_N
# set_property -dict {PACKAGE_PIN AA27 IOSTANDARD LVCMOS25} [get_ports {pmod_0[7]}]; #B13_L5_P
# pmod 1
# set_property -dict {PACKAGE_PIN W28  IOSTANDARD LVCMOS25} [get_ports {eth_ref_clk}]; #B13_L2_N
# set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVCMOS25} [get_ports {eth_crs_dv}]; #B13_L18_P
# set_property -dict {PACKAGE_PIN W27  IOSTANDARD LVCMOS25} [get_ports {eth_rxd[0]}]; #B13_L2_P
# set_property -dict {PACKAGE_PIN AH30 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[1]}]; #B13_L18_N
# set_property -dict {PACKAGE_PIN Y30  IOSTANDARD LVCMOS25} [get_ports {eth_tx_en}]; #B13_L8_P
# set_property -dict {PACKAGE_PIN AG28 IOSTANDARD LVCMOS25} [get_ports {eth_txd[0]}]; #B13_L21_N
# set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS25} [get_ports {eth_txd[1]}]; #B13_L8_N
# set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVCMOS25} [get_ports {pmod_1[7]}]; #B13_L21_P
# ## Ethernet RMII
set_property -dict { PACKAGE_PIN E30    IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; #B16_L18_N
set_property -dict { PACKAGE_PIN A27    IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[0] }]; #B16_L7_N
set_property -dict { PACKAGE_PIN C30    IOSTANDARD LVCMOS33 } [get_ports { eth_tx_en }]; #B16_L16_N
set_property -dict { PACKAGE_PIN C24    IOSTANDARD LVCMOS33 } [get_ports { eth_txd[1] }]; #B16_L8_P
set_property -dict { PACKAGE_PIN B27    IOSTANDARD LVCMOS33 } [get_ports { eth_crs_dv }]; #B16_L7_P
set_property -dict { PACKAGE_PIN D29    IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[1] }]; #B16_L16_P
set_property -dict { PACKAGE_PIN B24    IOSTANDARD LVCMOS33 } [get_ports { eth_txd[0] }]; #B16_L8_N
set_property -dict { PACKAGE_PIN E29    IOSTANDARD LVCMOS33 } [get_ports { mdc }]; #B16_L18_P
set_property -dict { PACKAGE_PIN D28    IOSTANDARD LVCMOS33 } [get_ports { mdio }]; #B16_L14_N

## UART
 set_property -dict { PACKAGE_PIN M30    IOSTANDARD LVCMOS33 } [get_ports { uart_rxd }]; #B15_L15_N
set_property -dict { PACKAGE_PIN M29    IOSTANDARD LVCMOS33 } [get_ports { uart_txd }]; #B15_L15_P

## RMII constraint
# create_clock -name eth_ref_clk -period 20 -waveform {0 6} [get_ports eth_ref_clk]
set_property IOB TRUE [get_ports eth_txd]
set_property IOB TRUE [get_ports eth_tx_en]

