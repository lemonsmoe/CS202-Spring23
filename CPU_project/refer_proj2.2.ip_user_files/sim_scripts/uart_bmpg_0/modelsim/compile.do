vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../refer_proj2.2.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg.v" \
"../../../../refer_proj2.2.srcs/sources_1/ip/uart_bmpg_0/upg.v" \
"../../../../refer_proj2.2.srcs/sources_1/ip/uart_bmpg_0/sim/uart_bmpg_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

