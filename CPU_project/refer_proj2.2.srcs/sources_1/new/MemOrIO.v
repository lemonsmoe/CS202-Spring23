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
    
    //����Ҫһ������ʱ������a���Ե�16λ������
    //����Ҫ��������ʱ������ab�ֱ����Ը�16λ�͵�16λ������
    
    //ͨ����ַ��lw��sw��ʵ��IO����
    always @(*) begin
        if(IORead == 1)begin
            if ((addr_in >= 32'hffff_fc70) && (addr_in <= 32'hffff_fc73)) begin//input data
                Reg_WriteData <= IO_ReadData;
                //lw $v0,0xC70($28) #v0���a��ֵ��a����C70�ֵĵ�16λ
            end
            else if((addr_in >= 32'hffff_fc7c) && (addr_in <= 32'hffff_fc7f)) begin//input ctrl
                Reg_WriteData <= InputCtrl;//ȷ�������ָ��
                
                //asm�У�lw $s7,0xC7C($28)����ȷ������
            end
            else if((addr_in >= 32'hffff_fc78) && (addr_in <= 32'hffff_fc7b)) begin//input test_index
                Reg_WriteData <= test_index;
                
                 //asm�У� lw $a3,0xC78($28)�������������ı�Ŷ�ȡ��$a3��
                
            end else
                Reg_WriteData <= 0;
        end
        else begin
            Reg_WriteData <= M_ReadData;
        end
    end
    
    assign LEDCtrl = ((addr_in >= 32'hffff_fc60) && ((addr_in <= 32'hffff_fc68)) && (IOWrite == 1))? 1 : 0;
    //asm�У���ledչʾĳ��ֵ��sw $v0,0xC60($28)
    assign LEDELCtrl = (addr_in == 32'hffff_fc68)? 1 : 0;
    
    //����LED��
    assign SwitchCtrl = ((addr_in >= 32'hffff_fc70) && (addr_in <= 32'hffff_fc73) && (IORead == 1))? 1 : 0;
    always @* begin 
        if((MemWrite==1)||(IOWrite==1)) 
            write_data = Reg_ReadData;
        else 
            write_data = 32'hZZZZ_ZZZZ; 
    end

endmodule