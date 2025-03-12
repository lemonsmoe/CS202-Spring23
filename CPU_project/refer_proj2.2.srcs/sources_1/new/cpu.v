`timescale 1ns / 1ps


module cpu(clk, rst, IO_ReadData, test_index, InputCtrl, IO_LED_Data, 
seg_en, seg_out, 
start_pg, rx, tx);

    input clk, rst;
    
    // 拨码开关输入
    input [15:0] IO_ReadData;
    input [2:0] test_index;

    // 确认按钮
    input InputCtrl;
    
    // 数码管及LED灯输出
    output [16:0] IO_LED_Data;
    output [7:0] seg_en;
    output [7:0] seg_out;
    
    //uart port
    input start_pg;
    input rx;
    output tx;
 
//////////////////////////////////////////////////////////
    
    
    wire[31:0]  Instruction;
    wire[31:0]  Reg_WriteData;           
    wire[31:0]  ALU_result;             
    wire[31:0]  write_data;


    // 分频
    wire upg_clk, cpu_clk, debounce_clk;
    divclk dclk(.clk(clk), .clr(rst), .cpu_clk(cpu_clk), .upg_clk(upg_clk), .clk_190Hz(debounce_clk));

    // 消抖
    
    // 拨码开关输入
    wire [15:0] IO_ReadData_Debounce; 
    debounce sw0(debounce_clk, rst, IO_ReadData[0], IO_ReadData_Debounce[0]);
    debounce sw1(debounce_clk, rst, IO_ReadData[1], IO_ReadData_Debounce[1]);
    debounce sw2(debounce_clk, rst, IO_ReadData[2], IO_ReadData_Debounce[2]);
    debounce sw3(debounce_clk, rst, IO_ReadData[3], IO_ReadData_Debounce[3]);
    debounce sw4(debounce_clk, rst, IO_ReadData[4], IO_ReadData_Debounce[4]);
    debounce sw5(debounce_clk, rst, IO_ReadData[5], IO_ReadData_Debounce[5]);
    debounce sw6(debounce_clk, rst, IO_ReadData[6], IO_ReadData_Debounce[6]);
    debounce sw7(debounce_clk, rst, IO_ReadData[7], IO_ReadData_Debounce[7]);
    debounce sw8(debounce_clk, rst, IO_ReadData[8], IO_ReadData_Debounce[8]);
    debounce sw9(debounce_clk, rst, IO_ReadData[9], IO_ReadData_Debounce[9]);
    debounce sw10(debounce_clk, rst, IO_ReadData[10], IO_ReadData_Debounce[10]);
    debounce sw11(debounce_clk, rst, IO_ReadData[11], IO_ReadData_Debounce[11]);
    debounce sw12(debounce_clk, rst, IO_ReadData[12], IO_ReadData_Debounce[12]);
    debounce sw13(debounce_clk, rst, IO_ReadData[13], IO_ReadData_Debounce[13]);
    debounce sw14(debounce_clk, rst, IO_ReadData[14], IO_ReadData_Debounce[14]);
    debounce sw15(debounce_clk, rst, IO_ReadData[15], IO_ReadData_Debounce[15]);

    // 测试样例
    wire [2:0] test_index_Debounce;
    debounce ts0(debounce_clk, rst, test_index[0], test_index_Debounce[0]);
    debounce ts1(debounce_clk, rst, test_index[1], test_index_Debounce[1]);
    debounce ts2(debounce_clk, rst, test_index[2], test_index_Debounce[2]);

    // 确认按钮
    wire InputCtrl_Debounce;
    debounce in(debounce_clk, rst, InputCtrl, InputCtrl_Debounce);


    //ifetch
    
    wire[31:0]  branch_base_addr; 
    wire[31:0]  Addr_result;      
    wire[31:0]  Read_data_1;      
    wire        Branch;           
    wire        nBranch;          
    wire        Jmp;              
    wire        Jal;              
    wire        Jr;               
    wire        Zero;             
    wire [31:0] link_addr;          
    wire [31:0] PC_plus_4;           
    //port of program
    wire[31:0] rom_adr_w;

    Ifetc32 ifetch(.Instruction(Instruction), .branch_base_addr(branch_base_addr), .Addr_result(Addr_result),
                    .Read_data_1(Read_data_1),.Branch(Branch), .nBranch(nBranch), .Jmp(Jmp), .Jal(Jal),
                    .Jr(Jr), .Zero(Zero), .clock(cpu_clk), .reset(rst), .link_addr(link_addr), 
                    .PC_plus_4(PC_plus_4), .PC(rom_adr_w));
    
    
    // ROM
      programrom rom_inst (
      .rom_clk_i(cpu_clk),
      .rom_adr_i(rom_adr_w[15:2]),
      .Instruction_o(Instruction)
    );


    // controller

    wire [5:0] Opcode;             
    assign Opcode = Instruction[31:26];
    wire [5:0] Function_opcode;  
    assign Function_opcode = Instruction[5:0];
    wire       RegDST;            
    wire       ALUSrc;           
    wire       MemorIOtoReg;      
    wire       RegWrite;   	      
    wire       MemWrite;          
    wire       I_format;          
    wire       Sftmd;             
    wire [1:0] ALUOp;             
    wire [21:0] Alu_resultHigh;
    assign Alu_resultHigh = ALU_result[31:10];
    wire MemRead;
    wire IORead;
    wire IOWrite;
    
    control32 controller(.Opcode(Opcode), .Function_opcode(Function_opcode), .Jr(Jr), .RegDST(RegDST),
                         .ALUSrc(ALUSrc), .MemorIOtoReg(MemorIOtoReg), .RegWrite(RegWrite), .MemWrite(MemWrite),
                         .Branch(Branch), .nBranch(nBranch), .Jmp(Jmp), .Jal(Jal), .I_format(I_format),
                         .Sftmd(Sftmd), .ALUOp(ALUOp), .Alu_resultHigh(Alu_resultHigh), .MemRead(MemRead), .IORead(IORead), .IOWrite(IOWrite));


    // decoder

    wire[31:0] Read_data_2;
    wire[31:0] Sign_extend;
    
    decode32 decoder(.read_data_1(Read_data_1), .read_data_2(Read_data_2), .Instruction(Instruction),
                     .mem_data(Reg_WriteData), .ALU_result(ALU_result), .Jal(Jal), .RegWrite(RegWrite),
                     .MemtoReg(MemorIOtoReg), .RegDst(RegDST), .Sign_extend(Sign_extend), .clock(cpu_clk),
                     .reset(rst), .opcplus4(link_addr));


    // execute

    wire [4:0] Shamt;              
    assign Shamt = Instruction [10:6];
    
    executs32 ALU(.Read_data_1(Read_data_1), .Read_data_2(Read_data_2), .Sign_extend(Sign_extend),
                 .Function_opcode(Function_opcode), .Exe_opcode(Opcode), .ALUOp(ALUOp),
                 .Shamt(Shamt), .ALUSrc(ALUSrc), .I_format(I_format), .Zero(Zero), .Jr(Jr), .Sftmd(Sftmd),
                 .ALU_Result(ALU_result), .Addr_Result(Addr_result), .PC_plus_4(PC_plus_4));
    
    
    // mem_or_io
    
    wire [31:0] addr_out;
    wire [31:0] mem_data;
    wire LEDCtrl;
    wire LEDELCtrl;
    wire SwitchCtrl;

    MemOrIO MemorIO(.MemRead(MemRead), .MemWrite(MemWrite), .IORead(IORead), .IOWrite(IOWrite),
                     .addr_in(ALU_result), .addr_out(addr_out), .M_ReadData(mem_data), .IO_ReadData(IO_ReadData_Debounce),
                     .test_index(test_index_Debounce), .InputCtrl(InputCtrl_Debounce), .Reg_WriteData(Reg_WriteData), .Reg_ReadData(Read_data_2), 
                     .write_data(write_data), .LEDCtrl(LEDCtrl), .LEDELCtrl(LEDELCtrl), .SwitchCtrl(SwitchCtrl));


    // dememory

    wire ram_wen_w;
    assign ram_wen_w = MemWrite;
    wire[13:0] ram_adr_w;
    assign ram_adr_w = addr_out[15:2];
    wire[31:0] ram_dat_i_w;
    assign ram_dat_i_w = Read_data_2;
    wire[31:0] ram_dat_o_w;
    assign ram_dat_o_w = mem_data;

  dmemory32 mem(.ram_clk_i(cpu_clk),.ram_wen_i(ram_wen_w),.ram_adr_i(ram_adr_w),
    .ram_dat_i(ram_dat_i_w),.ram_dat_o(ram_dat_o_w));


    // 处理 LED
//    handleLED hled( .IO_LED_Data(IO_LED_Data),.LEDCtrl(LEDCtrl), .LEDELCtrl(LEDELCtrl), .rst(rst), .write_data(write_data));
   LED led1(.showled(LEDCtrl),.showoneled(LEDELCtrl),.rst(rst),.write_data(write_data), .IO_LED_Data(IO_LED_Data));

    assign seg_en =0;
    assign seg_out=1;


endmodule