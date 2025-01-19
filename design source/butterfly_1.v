`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:24:09
// Design Name: 
// Module Name: butterfly_1
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



module butterfly_1 #(
    parameter   WIDTH = 16
)(
    i_rX,
    i_iX,
    i_rX2,
    i_iX2,
    control,
    o_rZ,
    o_iZ,
    o_rZ2,
    o_iZ2
    );
    
    input [WIDTH-1:0] i_rX;
    input [WIDTH-1:0] i_iX;
    input [WIDTH-1:0] i_rX2;
    input [WIDTH-1:0] i_iX2;
    input control;
    
    output [WIDTH-1:0] o_rZ;
    output [WIDTH-1:0] o_iZ;
    output [WIDTH-1:0] o_rZ2;
    output [WIDTH-1:0] o_iZ2;
    
    assign o_rZ = control ? (i_rX + i_rX2) : i_rX;
    assign o_iZ = control ? (i_iX + i_iX2) : i_iX;
    
    assign o_rZ2 = control ? (i_rX - i_rX2) : i_rX2;
    assign o_iZ2 = control ? (i_iX - i_iX2) : i_iX2;//delay input
    
    
endmodule

