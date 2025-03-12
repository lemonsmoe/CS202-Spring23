`timescale 1ns / 1ps


module divclk (

    input clk,
    input clr,
    output cpu_clk,
    output upg_clk,
    output clk_190Hz
    
);

    cpuclk lk1(.clk_in1(clk),.clk_out1(cpu_clk),.clk_out2(upg_clk));
    
    reg [24:0] q;
    always @(posedge clk or posedge clr) begin
        if(clr==1)
            q <= 0;
        else
            q <= q+1;
    end
    
    assign clk_190Hz = q[18];

endmodule
