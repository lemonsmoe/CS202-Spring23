`timescale 1ns / 1ps

module dmemory32(
input ram_clk_i, // from CPU top 
input ram_wen_i, // from controller 
input [13:0] ram_adr_i, // from alu_result of ALU 
input [31:0] ram_dat_i, // from read_data_2 of decoder 
output [31:0] ram_dat_o // the data read from ram 
// UART Programmer Pinouts 
//input upg_rst_i, // UPG reset (Active High) 
//input upg_clk_i, // UPG ram_clk_i (10MHz) 
//input upg_wen_i, // UPG write enable 
//input [13:0] upg_adr_i, // UPG write address 
//input [31:0] upg_dat_i, // UPG write data 
//input upg_done_i // 1 if programming is finished
    );

wire ram_clk = !ram_clk_i; // CPU work on normal mode when kickOff is 1. 
//CPU work on Uart communicate mode when kickOff is 0.
//wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i); 
//RAM ram ( 
//.clka (kickOff ? ram_clk : upg_clk_i), 
//.wea (kickOff ? ram_wen_i : upg_wen_i), 
//.addra (kickOff ? ram_adr_i : upg_adr_i), 
//.dina (kickOff ? ram_dat_i : upg_dat_i), 
//.douta (ram_dat_o) );

RAM ram ( 
.clka (ram_clk), 
.wea (ram_wen_i), 
.addra (ram_adr_i ), 
.dina (ram_dat_i), 
.douta (ram_dat_o) );

endmodule