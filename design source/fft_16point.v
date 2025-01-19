`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 18:26:38
// Design Name: 
// Module Name: fft_16point
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


module fft_16point(
    clk,
    i_reset,
    i_valid,
    i_re,
    i_im,
    o_valid,
    o_re,
    o_im,
    o_busy
    );
    
    input clk;
    input i_reset;
    input i_valid;
    input [15:0] i_re;
    input [15:0] i_im;
    
    output o_valid;
    output [15:0] o_re;
    output [15:0] o_im;
    output o_busy;
    
    wire w_sdf1_o_valid;
    wire [15:0] w_sdf1_o_re;
    wire [15:0] w_sdf1_o_im;
    
    wire w_sdf2_o_valid;
    wire [15:0] w_sdf2_o_re;
    wire [15:0] w_sdf2_o_im;
    
    sdf_16point SDF1(
        .clk(clk),
        .i_reset(i_reset),
        .i_valid(i_valid),
        .i_re(i_re),
        .i_im(i_im),
        .o_valid(w_sdf1_o_valid),
        .o_re(w_sdf1_o_re),
        .o_im(w_sdf1_o_im)
    );
    
    sdf_16point2 SDF2(
        .clk(clk),
        .i_reset(i_reset),
        .i_valid(w_sdf1_o_valid),
        .i_re(w_sdf1_o_re),
        .i_im(w_sdf1_o_im),
        .o_valid(w_sdf2_o_valid),
        .o_re(w_sdf2_o_re),
        .o_im(w_sdf2_o_im)
    );
    
    assign o_re = w_sdf2_o_re;
    assign o_im = w_sdf2_o_im;
    
    assign o_valid = w_sdf2_o_valid;
    
    assign o_busy = (i_valid || w_sdf1_o_valid || o_valid);
    
endmodule
