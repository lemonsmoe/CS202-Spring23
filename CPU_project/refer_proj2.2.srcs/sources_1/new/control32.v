`timescale 1ns / 1ps

module control32(Opcode, Function_opcode, Jr, RegDST, ALUSrc, MemorIOtoReg, RegWrite, MemWrite, 
                 Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, Alu_resultHigh, MemRead, IORead, IOWrite);
    
    // 指令内容             
    input[5:0]  Opcode;            // 来自IFetch模块的指令高6bit
    input[5:0]  Function_opcode;  	// 来自IFetch模块的指令低6bit，用于区分r-类型中的指令
    
    // 指令类型
    output Jr;  // instr == "jr"
    output Jmp; // instr == "j"
    output Jal;  // instr == "jal"
    output Branch;  // instr == "beq"
    output nBranch;  // instr == "bne"
    
    // to Decoder
    output RegDST;  // 为1：目的寄存器是rd；为0：目的寄存器是rt
    output RegWrite;  // 为1：需要回写寄存器
    
    // to ALU
    output ALUSrc;  // 为1：第二个操作数（ALU中的Binput）是立即数（beq，bne除外）；为0：第二个操作数来自寄存器
    output I_format;  // 为1：该指令是除beq，bne，lw，sw之外的I-类型指令
    output Sftmd;  // 为1：该指令是移位指令
    output [1:0] ALUOp;  // 当指令为R-type或I_format时，ALUOp的高比特位为1; 当指令为beq或bne时，ALUOp的低比特位为1
    
    // to memory
    output MemWrite;  // 为1：需要写存储器
//    output MemtoReg;  // 为1：回写数据来自存储器或I/O；为0：回写数据来自ALU
    
    // new port for IO
    input [21:0] Alu_resultHigh;
    output MemorIOtoReg;  // 为1：回写数据来自存储器或I/O；为0：回写数据来自ALU
    output MemRead;  // 为1：需从memory中读取
    output IORead;  // 为1：要从IO读取
    output IOWrite;  // 为1：要输出到IO
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    wire sw, lw;
    assign sw = (Opcode == 6'b101011)? 1 : 0;
    assign lw = (Opcode == 6'b100011)? 1 : 0;
    
    assign MemWrite = ((sw == 1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1 : 0; 
    assign MemRead =((lw == 1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1 : 0;
    assign IORead = ((lw == 1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1 : 0;
    assign IOWrite = ((sw == 1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1 : 0;
    assign MemorIOtoReg = IORead || MemRead;
    
    
    wire R_type;  // R类型指令
    assign R_type = (Opcode == 6'b000000) ? 1'b1 : 1'b0;
    assign I_format = (Opcode[5:3] == 3'b001) ? 1'b1 : 1'b0;

    assign Jr = ((R_type == 1) && (Function_opcode == 6'b001000)) ? 1'b1 : 1'b0;
    assign Jmp = (Opcode == 6'b000010) ? 1'b1 : 1'b0;
    assign Jal = (Opcode == 6'b000011) ? 1'b1 : 1'b0;
    assign Branch = (Opcode == 6'b000100) ? 1'b1 : 1'b0;
    assign nBranch = (Opcode == 6'b000101) ? 1'b1 : 1'b0;
    assign Sftmd = ((R_type == 1) && (Function_opcode[5:3] == 3'b000)) ? 1'b1 : 1'b0;
    
    assign RegDST = R_type;  // 当指令类型为R-type
//    assign MemtoReg = (Opcode == 6'b100011) ? 1'b1 : 1'b0;  // 当指令为lw
    assign RegWrite = (((R_type == 1) || (Opcode == 6'b100011) || (I_format == 1) || (Jal == 1)) && (!Jr)) ? 1'b1 : 1'b0;  // 当指令为R-type/lw/立即数alu/jal，且不为jr
    assign ALUSrc = ((I_format == 1) || (Opcode == 6'b100011) || (Opcode == 6'b101011)) ? 1'b1 : 1'b0;  // 当指令为立即数alu，或为lw,sw
    assign ALUOp = {(R_type || I_format), (Branch || nBranch)};
//    assign MemWrite = (Opcode == 6'b101011) ? 1'b1 : 1'b0;  // 当指令为sw
      
endmodule

