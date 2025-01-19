`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:25:24
// Design Name: 
// Module Name: butterfly_2
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



module butterfly_2 #(
    parameter   WIDTH = 16
)(
    i_rX,
    i_iX,
    i_rX2,
    i_iX2,
    control,
    conjugate,
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
    input conjugate;
    
    output [WIDTH-1:0] o_rZ;
    output [WIDTH-1:0] o_iZ;
    output [WIDTH-1:0] o_rZ2;
    output [WIDTH-1:0] o_iZ2;
    
    wire cc;
    //wire [WIDTH-1:0] w_mux_r;
    //wire [WIDTH-1:0] w_mux_i;
    
    assign cc = conjugate;
    
    //assign w_mux_r = c ? i_iX2 : i_rX2;
    //assign w_mux_i = c ? -i_rX2 : i_iX2;
    
    assign o_rZ = control ? (cc ? (i_rX + i_iX2) : (i_rX + i_rX2)) : i_rX;
    assign o_iZ = control ? (cc ? (i_iX - i_rX2) : (i_iX + i_iX2)) : i_iX;
    
    assign o_rZ2 = control ? (cc ? (i_rX - i_iX2) : (i_rX - i_rX2)) : i_rX2;
    assign o_iZ2 = control ? (cc ? (i_iX + i_rX2) : (i_iX - i_iX2)) : i_iX2;    
    
endmodule
