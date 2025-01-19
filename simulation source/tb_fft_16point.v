`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 18:37:42
// Design Name: 
// Module Name: tb_fft_16point
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


module tb_fft_16point();
    reg clk;
    reg reset;
    reg i_valid;
    
    reg [15:0] i_re;
    reg [15:0] i_im;
    
    wire o_valid;
    wire [15:0] o_re;
    wire [15:0] o_im;
    wire o_busy;
    
    reg [15:0]	imem[0:127];
    reg [15:0]	omem[0:127];    
    
    integer n;
    
    always
    begin
    #100 clk = ~clk;
    end  
    
    fft_16point udf1(
        .clk(clk),
        .i_reset(reset),
        .i_valid(i_valid),
        .i_re(i_re),
        .i_im(i_re),
        .o_valid(o_valid),
        .o_re(o_re),
        .o_im(o_im),
        .o_busy(o_busy)
    );
    
    initial begin

        clk = 0;
        reset = 1;
        i_valid = 0;#200;
        reset = 0;
        i_valid = 1;
        $readmemh("C:/Users/82107/project_1_fft/0_16_input.txt", imem);
        
        for (n = 0; n < 64; n = n + 1) begin
            i_re <= imem[2*n];
            i_im <= imem[2*n+1];
            @(posedge clk);
            if (n == 16)begin
            i_valid <= 0;
            i_re <= 'bx;
            i_im <= 'bx;    
            end
        end
        #3100;
        
        i_valid = 0;#5000;
        $finish;
    end
endmodule
