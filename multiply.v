`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:26:15
// Design Name: 
// Module Name: multiply
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


module multiply #(
    parameter   WIDTH = 16
)(
    input   signed  [WIDTH-1:0] a_re,
    input   signed  [WIDTH-1:0] a_im,
    input   signed  [WIDTH-1:0] b_re,
    input   signed  [WIDTH-1:0] b_im,
    output  signed  [2*WIDTH-1:0] m_re,
    output  signed  [2*WIDTH-1:0] m_im
);

    wire signed [WIDTH*2-1:0]   arbr, arbi, aibr, aibi;
    
    //  Signed Multiplication
    assign  arbr = a_re * b_re;
    assign  arbi = a_re * b_im;
    assign  aibr = a_im * b_re;
    assign  aibi = a_im * b_im;
    
    
    //  Sub/Add
    //  These sub/add may overflow if unnormalized data is input.
    assign  m_re = arbr - aibi;
    assign  m_im = arbi + aibr;

endmodule
