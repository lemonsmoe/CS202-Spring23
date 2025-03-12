`timescale 1ns / 1ps

module control32(Opcode, Function_opcode, Jr, RegDST, ALUSrc, MemorIOtoReg, RegWrite, MemWrite, 
                 Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, Alu_resultHigh, MemRead, IORead, IOWrite);
    
    // ָ������             
    input[5:0]  Opcode;            // ����IFetchģ���ָ���6bit
    input[5:0]  Function_opcode;  	// ����IFetchģ���ָ���6bit����������r-�����е�ָ��
    
    // ָ������
    output Jr;  // instr == "jr"
    output Jmp; // instr == "j"
    output Jal;  // instr == "jal"
    output Branch;  // instr == "beq"
    output nBranch;  // instr == "bne"
    
    // to Decoder
    output RegDST;  // Ϊ1��Ŀ�ļĴ�����rd��Ϊ0��Ŀ�ļĴ�����rt
    output RegWrite;  // Ϊ1����Ҫ��д�Ĵ���
    
    // to ALU
    output ALUSrc;  // Ϊ1���ڶ�����������ALU�е�Binput������������beq��bne���⣩��Ϊ0���ڶ������������ԼĴ���
    output I_format;  // Ϊ1����ָ���ǳ�beq��bne��lw��sw֮���I-����ָ��
    output Sftmd;  // Ϊ1����ָ������λָ��
    output [1:0] ALUOp;  // ��ָ��ΪR-type��I_formatʱ��ALUOp�ĸ߱���λΪ1; ��ָ��Ϊbeq��bneʱ��ALUOp�ĵͱ���λΪ1
    
    // to memory
    output MemWrite;  // Ϊ1����Ҫд�洢��
//    output MemtoReg;  // Ϊ1����д�������Դ洢����I/O��Ϊ0����д��������ALU
    
    // new port for IO
    input [21:0] Alu_resultHigh;
    output MemorIOtoReg;  // Ϊ1����д�������Դ洢����I/O��Ϊ0����д��������ALU
    output MemRead;  // Ϊ1�����memory�ж�ȡ
    output IORead;  // Ϊ1��Ҫ��IO��ȡ
    output IOWrite;  // Ϊ1��Ҫ�����IO
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    wire sw, lw;
    assign sw = (Opcode == 6'b101011)? 1 : 0;
    assign lw = (Opcode == 6'b100011)? 1 : 0;
    
    assign MemWrite = ((sw == 1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1 : 0; 
    assign MemRead =((lw == 1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1 : 0;
    assign IORead = ((lw == 1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1 : 0;
    assign IOWrite = ((sw == 1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1 : 0;
    assign MemorIOtoReg = IORead || MemRead;
    
    
    wire R_type;  // R����ָ��
    assign R_type = (Opcode == 6'b000000) ? 1'b1 : 1'b0;
    assign I_format = (Opcode[5:3] == 3'b001) ? 1'b1 : 1'b0;

    assign Jr = ((R_type == 1) && (Function_opcode == 6'b001000)) ? 1'b1 : 1'b0;
    assign Jmp = (Opcode == 6'b000010) ? 1'b1 : 1'b0;
    assign Jal = (Opcode == 6'b000011) ? 1'b1 : 1'b0;
    assign Branch = (Opcode == 6'b000100) ? 1'b1 : 1'b0;
    assign nBranch = (Opcode == 6'b000101) ? 1'b1 : 1'b0;
    assign Sftmd = ((R_type == 1) && (Function_opcode[5:3] == 3'b000)) ? 1'b1 : 1'b0;
    
    assign RegDST = R_type;  // ��ָ������ΪR-type
//    assign MemtoReg = (Opcode == 6'b100011) ? 1'b1 : 1'b0;  // ��ָ��Ϊlw
    assign RegWrite = (((R_type == 1) || (Opcode == 6'b100011) || (I_format == 1) || (Jal == 1)) && (!Jr)) ? 1'b1 : 1'b0;  // ��ָ��ΪR-type/lw/������alu/jal���Ҳ�Ϊjr
    assign ALUSrc = ((I_format == 1) || (Opcode == 6'b100011) || (Opcode == 6'b101011)) ? 1'b1 : 1'b0;  // ��ָ��Ϊ������alu����Ϊlw,sw
    assign ALUOp = {(R_type || I_format), (Branch || nBranch)};
//    assign MemWrite = (Opcode == 6'b101011) ? 1'b1 : 1'b0;  // ��ָ��Ϊsw
      
endmodule

