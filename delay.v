`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:24:48
// Design Name: 
// Module Name: delay
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


module delay #(
    parameter   DEPTH = 8,//16 point fft--> first 8 delay
    parameter   WIDTH = 16
)(
    clk,
    i_rZ,
    i_iZ,
    o_rZ,
    o_iZ
);
    input clk;
    input [WIDTH-1:0]i_rZ;
    input [WIDTH-1:0]i_iZ;
    
    output  [WIDTH-1:0] o_rZ;
    output  [WIDTH-1:0] o_iZ;
    
    reg [WIDTH-1:0] buf_re[0:DEPTH-1];
    reg [WIDTH-1:0] buf_im[0:DEPTH-1];
    
    integer n;

    //  Shift Buffer
    always @(posedge clk) begin
        for (n = DEPTH-1; n > 0; n = n - 1) begin
            buf_re[n] <= buf_re[n-1];
            buf_im[n] <= buf_im[n-1];
        end
        buf_re[0] <= i_rZ;
        buf_im[0] <= i_iZ;
    end
    
    assign  o_rZ = buf_re[DEPTH-1];
    assign  o_iZ = buf_im[DEPTH-1];

endmodule
