`timescale 1ns / 1ps

module exciting(
    input clk,
    input rst,
    input switch,
    output signal
    );

    reg lag1, lag2;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            lag1 <= switch;
            lag2 <= lag1;
        end
        else begin
            lag1 <= switch;
            lag2 <= lag1;
        end
    end

    //���Ϊһ��ʱ�����ڵ��ź�
    assign signal = lag1 & ~lag2;

endmodule