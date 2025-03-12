`timescale 1ns / 1ps
module test1_tb(

    );
    
    reg clk =1;
    reg rst =1;
    reg [2:0]test_index= 3'b001;
    reg [15:0]IO_ReadData=16'b0000_0000_0000_0000;
    reg InputCtrl=0;
    wire [16:0]IO_LED_Data;
    wire [7:0]seg_en;
    wire [7:0]seg_out;
    reg [3:0]row;
    wire[3:0]col;
    reg backspace_button;
    
    reg start_pg=0;
    reg rx;
    wire tx;
    reg boardOrSwCtrl=0;
        
    cpu cpu_top(.clk(clk),.rst(rst),.test_index(test_index),.boardOrSwCtrl(boardOrSwCtrl),.IO_ReadData(IO_ReadData),.InputCtrl(InputCtrl),
    .IO_LED_Data(IO_LED_Data), .start_pg(start_pg),.rx(rx),.tx(tx)
    ,.seg_en(seg_en),.seg_out(seg_out),.row(row),.col(col),.backspace_button(backspace_button));
    
                      
                always #5 begin
                    clk = ~clk;
                end
                
                initial begin
                #100 rst=1;
                #100 rst=0;
               
//                #20  uart_start=1;
//                      rx=1;     

                #200 IO_ReadData= 16'b0000_0000_0000_0001;
                
               
                
                while(1)begin
                #1000 InputCtrl=~InputCtrl;
                #1000 InputCtrl=~InputCtrl;
                end
                
                end
                
                
endmodule
