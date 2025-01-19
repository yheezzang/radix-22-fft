`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:27:33
// Design Name: 
// Module Name: saturation
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


module saturation #(
    parameter IN_WIDTH = 5,
    parameter OUT_WIDTH = 3
)(
    i_real,
    i_imag,
    o_sat_real,
    o_sat_imag
);
    input [IN_WIDTH-1:0] i_real;
    input [IN_WIDTH-1:0] i_imag;
    
    output[OUT_WIDTH-1:0] o_sat_real;
    output[OUT_WIDTH-1:0] o_sat_imag;
    
    wire w_en_sat1;
    wire w_en_sat2;
   
   
    assign w_en_sat1 = i_real[IN_WIDTH-1] ? !(&i_real[IN_WIDTH-1 : OUT_WIDTH-1]) : |i_real[IN_WIDTH-1 : OUT_WIDTH-1];
    assign o_sat_real = w_en_sat1 ? { i_real[IN_WIDTH-1], {(OUT_WIDTH-1){~i_real[IN_WIDTH-1]}} } : i_real[OUT_WIDTH-1:0];
    
    assign w_en_sat2 = i_imag[IN_WIDTH-1] ? !(&i_imag[IN_WIDTH-1 : OUT_WIDTH-1]) : |i_imag[IN_WIDTH-1 : OUT_WIDTH-1];
    assign o_sat_imag = w_en_sat2 ? { i_imag[IN_WIDTH-1], {(OUT_WIDTH-1){~i_imag[IN_WIDTH-1]}} } : i_imag[OUT_WIDTH-1:0];
    
endmodule

