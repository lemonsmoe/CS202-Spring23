`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 17:50:45
// Design Name: 
// Module Name: Ifetc32
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


module Ifetc32 (Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,
                PC_plus_4,PC);

    input clock, reset;
    
    // from ALU
    input[31:0] Addr_result; // ALU计算出的跳转地址
    input Zero; // 1：ALU的输出结果为0(即两个输入值相等)。 用以判断beq/bne指令是否达到跳转条件
    
    // from Decoder
    input [31:0] Read_data_1;  // 从寄存器中读到的值1，用于确定jr指令的跳转地址
    
    // from Controller: 指令类型
    input Jr, Jmp, Jal, Branch, nBranch;
  
    input [31:0] Instruction;			// 从这个模块获取到的指令，输出到其他模块
    output [31:0] branch_base_addr;      // 用于beq,bne指令，(pc+4)输出到ALU
    output [31:0] link_addr;             // 用于jal指令，(pc+4)输出到解码器
    
    output [31:0] PC_plus_4;             // PC + 4;
    output reg [31:0] PC;
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    reg [31:0] Next_PC;
    reg [31:0] link;
    
    initial begin
        Next_PC = 32'b0;
    end
    
    assign PC_plus_4 = PC + 4;
    assign branch_base_addr = PC_plus_4;
    assign link_addr = link;
//    assign link_addr = PC_plus_4;
    
    // 更新PC寄存器
    always @ (*) begin
        if (((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result;
        else if (Jr == 1)
            Next_PC = Read_data_1;
        else if ((Jmp == 1) || (Jal == 1))
            Next_PC = {PC[31:28], Instruction[25:0], 2'b00};
        else
            Next_PC = PC + 4;
    end
    always @ (negedge clock or posedge reset) begin
        if (reset)
            PC <= 32'h0000_0000;
        else
            PC <= Next_PC;
    end
    always @ (negedge clock or posedge reset) begin
        if (reset)
            link <= 0;
        else
            link <= PC_plus_4;
    end
    
endmodule
