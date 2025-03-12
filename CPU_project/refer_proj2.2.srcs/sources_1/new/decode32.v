`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 00:50:49
// Design Name: 
// Module Name: decode32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: FINISHED
// 
//////////////////////////////////////////////////////////////////////////////////


module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);   

    input clock, reset;
    
    // from Controller
    input Jal;
    input RegDst;  // 1��Ŀ��reg = "rd"��0��Ŀ��reg = "rt"
    input MemtoReg;  // 1����д��������D-memory / 0����д��������ALU
    input RegWrite;  // 1����дreg
    
    // from IFetch
    input [31:0] Instruction;
    input [31:0] opcplus4;  // PC+4
    
    input [31:0] ALU_result;  // ALU��������
    input [31:0] mem_data;  // ��D-Memory�ж���������
    
    output [31:0] read_data_1;  // �ӼĴ����ж�����ֵ1
    output [31:0] read_data_2;  // �ӼĴ����ж�����ֵ2
    output [31:0] Sign_extend;  // ��չ���������

//////////////////////////////////////////////////////////////////////////

    reg [31:0] registers [0:31];  // �Ĵ�����
    
    integer i;
    initial begin
        for(i=0; i<32; i=i+1) registers[i] <= 32'b0;
    end
    
    // ȷ���ӼĴ�����ȡ�õ�����
    wire [4:0] rs, rt, rd;
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign read_data_1 = registers[rs];
    assign read_data_2 = registers[rt];
    
    // ��sign extension��ȷ����������ֵ
    wire [5:0] opcode;
    assign opcode = Instruction[31:26];
    wire extend_zero;  // 1����0����չ
    assign extend_zero = ((Instruction[15] == 1'b0) || (opcode == 6'b001001) || (opcode == 6'b001011) || 
                         (opcode == 6'b001100) || (opcode == 6'b001101) || (opcode == 6'b001110)) ? 1'b1 : 1'b0;
    assign Sign_extend = (extend_zero == 1) ? {16'h0000, Instruction[15:0]} : {16'hffff, Instruction[15:0]};
    
    // ��д��Ŀ��Ĵ���
    reg [4:0] dest_reg;  // Ŀ��Ĵ������
    reg [31:0] data;  // ��д����
    always @ (*) begin
        // ȷ��Ŀ��Ĵ�������
        if (Jal == 1)
            dest_reg = 5'b11111;
        else begin
            if (RegDst == 1)
                dest_reg = rd;
            else
                dest_reg = rt;
        end
        // ȷ����д����
//        if (Jal == 1 )
          if(Jal == 1 && opcode == 6'b000011)
            data = opcplus4;
        else begin
            if (MemtoReg == 1)
                data = mem_data;
            else
                data = ALU_result;
        end
    end
    
    
    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            for(i=0; i<32; i=i+1) registers[i] <= 32'b0;
        end
        else begin
            if (RegWrite == 1 && dest_reg != 5'b0)
                registers[dest_reg] <= data;
            else begin end
        end
    end

    
endmodule
