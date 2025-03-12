`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 11:11:44
// Design Name: 
// Module Name: LED
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


module LED(
	input wire showled,
    input wire showoneled,
	input wire rst,
	input wire [31:0] write_data,
	output wire [16:0] IO_LED_Data
);

    reg [16:0] IO_WriteData = 0;
    assign IO_LED_Data = IO_WriteData;


    always @(posedge showled or posedge rst)    
    begin
        if(rst == 1)  IO_WriteData <=0;
        else if(showled == 1)
        begin
            IO_WriteData <= write_data[16:0];
        end
    end


endmodule
