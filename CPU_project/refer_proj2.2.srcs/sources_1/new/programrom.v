`timescale 1ns / 1ps



module programrom ( 
// Program ROM Pinouts 
input rom_clk_i, // ROM clock 
input [13:0] rom_adr_i, // From IFetch 
output [31:0] Instruction_o // To IFetch 
// UART Programmer Pinouts 
//input upg_rst_i, // UPG reset (Active High) 
//input upg_clk_i, // UPG clock (10MHz) 
//input upg_wen_i, // UPG write enable 
//input[13:0] upg_adr_i, // UPG write address 
//input[31:0] upg_dat_i, // UPG write data 
//input upg_done_i // 1 if program finished 
);

//wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i ); 
//prgrom instmem ( 
//.clka (kickOff ? rom_clk_i : upg_clk_i ), 
//.wea (kickOff ? 1'b0 : upg_wen_i ), 
//.addra (kickOff ? rom_adr_i : upg_adr_i ), 
//.dina (kickOff ? 32'h00000000 : upg_dat_i ), 
//.douta (Instruction_o) ); 

    prgrom instmem (
        .clka ( rom_clk_i),
        .wea ( 1'b0 ),
        .addra ( rom_adr_i  ),
        .dina (32'h00000000),
        .douta (Instruction_o)
    );
    
endmodule