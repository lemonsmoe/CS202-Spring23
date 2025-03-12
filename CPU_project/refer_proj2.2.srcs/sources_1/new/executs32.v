`timescale 1ns / 1ps

module executs32(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4);
                 
    input[5:0]   Exe_opcode;  		// ȡַ��Ԫ���Ĳ�����
    input[5:0]   Function_opcode;  	// ȡַ��Ԫ����r-����ָ�����,r-form instructions[5:0]
    input [4:0] Shamt;  // shiftƫ������= instruction[10:6]

    // from Controller
    input Jr;  // ���Կ��Ƶ�Ԫ��������JRָ��
    input ALUSrc;  // Ϊ1���ڶ�����������ALU�е�Binput������������beq��bne���⣩��Ϊ0���ڶ������������ԼĴ���
    input I_format;  // Ϊ1����ָ���ǳ�beq��bne��lw��sw֮���I-����ָ��
    input Sftmd;  // Ϊ1����ָ������λָ��
    input [1:0] ALUOp;  // ��ָ��ΪR-type��I_formatʱ��ALUOp�ĸ߱���λΪ1; ��ָ��Ϊbeq��bneʱ��ALUOp�ĵͱ���λΪ1
    
    // from Decoder
    input [31:0] Read_data_1;  // �ӼĴ����ж�����ֵ1
    input [31:0] Read_data_2;  // �ӼĴ����ж�����ֵ2
    input [31:0] Sign_extend;  // ������������
    
    // from IFetch
    input [31:0] PC_plus_4;  // pc+4  

    output [31:0] ALU_Result; // ALU��������
    output [31:0] Addr_Result; // ��ָ֧���Ŀ���ַ
    output Zero; // 1��ALU��������Ϊ0(����������ֵ���)�� �����ж�beq/bneָ���Ƿ�ﵽ��ת����

////////////////////////////////////////////////////////////////////////////////////////////////////

    // ALU����������
    wire [31:0] Ainput, Binput;  
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 1) ? Sign_extend : Read_data_2;
    
    // ����ALU���������źţ�����ALU�����߼�����
    wire [2:0] ALU_ctrl;  // ALU���������ź�
    wire [5:0] Exe_code;  // ��������ALU_ctrl
    assign Exe_code = (I_format == 1) ? {3'b000, Exe_opcode[2:0]} : Function_opcode;
    assign ALU_ctrl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctrl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctrl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    // ALU �����߼�������
    reg [31:0] ALU_output_mux;
    always @ (ALU_ctrl or Ainput or Binput) begin
        case (ALU_ctrl)
            // ��"*"��ָ���ڼ���ALU������ʱ�ᵥ�����ǣ��ʲ����õ�������õ�ALU_output_mux
            3'b000: ALU_output_mux = Ainput & Binput;  // and, andi
            3'b001: ALU_output_mux = Ainput | Binput;  // or, ori
            3'b010: ALU_output_mux = $signed(Ainput) + $signed(Binput);  // add, addi, lw, sw
            3'b011: ALU_output_mux = $unsigned(Ainput) + $unsigned(Binput);  // addu, addui
            3'b100: ALU_output_mux = Ainput ^ Binput;  // xor, xori
            3'b101: ALU_output_mux = ~(Ainput | Binput);  // nor, lui*
            3'b110: ALU_output_mux = $signed(Ainput) - $signed(Binput);  // sub, slti*, beq, bne
            3'b111: ALU_output_mux = $unsigned(Ainput) - $unsigned(Binput);// subu, sltiu*, slt*, sltu*
            default: begin end
        endcase
    end
    
    // ALU shift������
    reg [31:0] Shift_Result;
    wire [2:0] Sftm;  // ������λָ��
    assign Sftm = Function_opcode[2:0];
    always @ (*) begin
        if (Sftmd) begin
            case (Sftm)
                3'b000: Shift_Result = Binput << Shamt;  // sll rd,rt,shamt
                3'b010: Shift_Result = Binput >> Shamt;  // srl rd,rt,shamt
                3'b100: Shift_Result = Binput << Ainput;  // sllv rd,rt,rs
                3'b110: Shift_Result = Binput >> Ainput;  // srlv rd,rt,rs
                3'b011: Shift_Result = $signed(Binput) >>> Shamt;  // sra rd,rt,shamt
                3'b111: Shift_Result = $signed(Binput) >>> Ainput;  // srav rd,rt,rs
                default: begin end
            endcase
        end
        else begin end
    end
    
    // ����ALU��������
    reg [31:0] result;    
    always @ (*) begin
        if ((Exe_opcode == 6'b000000 && Function_opcode == 6'b101010) || (Exe_opcode == 6'b001010))  // slt, slti
            result = ($signed(Ainput) - $signed(Binput) < 0) ? 32'b1 : 32'b0;
        else if ((Exe_opcode == 6'b000000 && Function_opcode == 6'b101011) || (Exe_opcode == 6'b001011))  // sltu, sltiu
            result = ($signed($unsigned(Ainput) - $unsigned(Binput)) < 0) ? 32'b1 : 32'b0;
        else if (Exe_opcode == 6'b001111)  // lui
            result = {Binput[15:0], 16'b0};
        else if (Sftmd == 1)  // shift operation
            result = Shift_Result;
        else  // ����������Ҫ���⿼�ǵ��������������߼�����
            result = ALU_output_mux;
    end
    
    assign ALU_Result = result;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);
    assign Zero = (ALU_output_mux == 32'b0) ? 1'b1 : 1'b0;

endmodule
