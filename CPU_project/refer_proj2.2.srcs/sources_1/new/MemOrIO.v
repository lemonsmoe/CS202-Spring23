`timescale 1ns / 1ps

module MemOrIO(MemRead, MemWrite, IORead, IOWrite, addr_in, addr_out, M_ReadData, IO_ReadData, test_index, InputCtrl, Reg_WriteData, Reg_ReadData, write_data, LEDCtrl, LEDELCtrl, SwitchCtrl); 
    
    //from controller
    input MemRead;                          
    input MemWrite;                          
    input IORead;                          
    input IOWrite;                        
    
    input[31:0] addr_in;                  
    output[31:0] addr_out;                
    
    input[31:0] M_ReadData;                   
    input[15:0] IO_ReadData;                
    input[2:0] test_index;
    input InputCtrl;                       
    
    output reg[31:0] Reg_WriteData;              

    input[31:0] Reg_ReadData;                  
    output reg[31:0] write_data;         
    output LEDCtrl;                     
    output LEDELCtrl;
    output SwitchCtrl;                  

    assign addr_out = addr_in;
    
    //当需要一个输入时，参数a来自低16位的输入
    //当需要两个输入时，参数ab分别来自高16位和低16位的输入
    
    //通过地址的lw和sw来实现IO交互
    always @(*) begin
        if(IORead == 1)begin
            if ((addr_in >= 32'hffff_fc70) && (addr_in <= 32'hffff_fc73)) begin//input data
                Reg_WriteData <= IO_ReadData;
                //lw $v0,0xC70($28) #v0存放a的值，a存在C70字的低16位
            end
            else if((addr_in >= 32'hffff_fc7c) && (addr_in <= 32'hffff_fc7f)) begin//input ctrl
                Reg_WriteData <= InputCtrl;//确认输入的指令
                
                //asm中，lw $s7,0xC7C($28)代表确认输入
            end
            else if((addr_in >= 32'hffff_fc78) && (addr_in <= 32'hffff_fc7b)) begin//input test_index
                Reg_WriteData <= test_index;
                
                 //asm中， lw $a3,0xC78($28)代表将测试用例的编号读取到$a3中
                
            end else
                Reg_WriteData <= 0;
        end
        else begin
            Reg_WriteData <= M_ReadData;
        end
    end
    
    assign LEDCtrl = ((addr_in >= 32'hffff_fc60) && ((addr_in <= 32'hffff_fc68)) && (IOWrite == 1))? 1 : 0;
    //asm中，用led展示某个值，sw $v0,0xC60($28)
    assign LEDELCtrl = (addr_in == 32'hffff_fc68)? 1 : 0;
    
    //单独LED灯
    assign SwitchCtrl = ((addr_in >= 32'hffff_fc70) && (addr_in <= 32'hffff_fc73) && (IORead == 1))? 1 : 0;
    always @* begin 
        if((MemWrite==1)||(IOWrite==1)) 
            write_data = Reg_ReadData;
        else 
            write_data = 32'hZZZZ_ZZZZ; 
    end

endmodule