-makelib ies_lib/xil_defaultlib -sv \
  "D:/vivado2/vivadoinstall/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/vivado2/vivadoinstall/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/vivado2/vivadoinstall/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../refer_proj2.2.srcs/sources_1/ip/programrom/sim/programrom.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

