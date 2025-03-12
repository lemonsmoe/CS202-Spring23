`timescale 1ns / 1ps

module executs32(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4);
                 
    input[5:0]   Exe_opcode;  		// 取址单元来的操作码
    input[5:0]   Function_opcode;  	// 取址单元来的r-类型指令功能码,r-form instructions[5:0]
    input [4:0] Shamt;  // shift偏移量，= instruction[10:6]

    // from Controller
    input Jr;  // 来自控制单元，表明是JR指令
    input ALUSrc;  // 为1：第二个操作数（ALU中的Binput）是立即数（beq，bne除外）；为0：第二个操作数来自寄存器
    input I_format;  // 为1：该指令是除beq，bne，lw，sw之外的I-类型指令
    input Sftmd;  // 为1：该指令是移位指令
    input [1:0] ALUOp;  // 当指令为R-type或I_format时，ALUOp的高比特位为1; 当指令为beq或bne时，ALUOp的低比特位为1
    
    // from Decoder
    input [31:0] Read_data_1;  // 从寄存器中读到的值1
    input [31:0] Read_data_2;  // 从寄存器中读到的值2
    input [31:0] Sign_extend;  // 扩充后的立即数
    
    // from IFetch
    input [31:0] PC_plus_4;  // pc+4  

    output [31:0] ALU_Result; // ALU的运算结果
    output [31:0] Addr_Result; // 分支指令的目标地址
    output Zero; // 1：ALU的输出结果为0(即两个输入值相等)。 用以判断beq/bne指令是否达到跳转条件

////////////////////////////////////////////////////////////////////////////////////////////////////

    // ALU的两个输入
    wire [31:0] Ainput, Binput;  
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 1) ? Sign_extend : Read_data_2;
    
    // 计算ALU操作控制信号，用于ALU算术逻辑运算
    wire [2:0] ALU_ctrl;  // ALU操作控制信号
    wire [5:0] Exe_code;  // 用于生成ALU_ctrl
    assign Exe_code = (I_format == 1) ? {3'b000, Exe_opcode[2:0]} : Function_opcode;
    assign ALU_ctrl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctrl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctrl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    // ALU 算数逻辑运算结果
    reg [31:0] ALU_output_mux;
    always @ (ALU_ctrl or Ainput or Binput) begin
        case (ALU_ctrl)
            // 标"*"的指令在计算ALU输出结果时会单独考虑，故不会用到这里算得的ALU_output_mux
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
    
    // ALU shift运算结果
    reg [31:0] Shift_Result;
    wire [2:0] Sftm;  // 具体移位指令
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
    
    // 计算ALU的输出结果
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
        else  // 除了以上需要特殊考虑的情况以外的算术逻辑运算
            result = ALU_output_mux;
    end
    
    assign ALU_Result = result;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);
    assign Zero = (ALU_output_mux == 32'b0) ? 1'b1 : 1'b0;

endmodule
