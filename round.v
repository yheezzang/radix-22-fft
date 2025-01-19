`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 15:26:56
// Design Name: 
// Module Name: round
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


module round #(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 16,
    parameter fraction_bit = 14
)(
    i_real,
    i_imag,
    o_round_real,
    o_round_imag
);
    input [IN_WIDTH-1:0] i_real;
    input [IN_WIDTH-1:0] i_imag;
    
    output[OUT_WIDTH-1:0] o_round_real;
    output[OUT_WIDTH-1:0] o_round_imag;
    
    wire [IN_WIDTH-1:0] w_real;
    wire [IN_WIDTH-1:0] w_imag;
    
    wire w_add_bit1;
    wire w_add_bit2;
    
    wire [IN_WIDTH-fraction_bit:0] w_temp_real;
    wire [IN_WIDTH-fraction_bit:0] w_temp_imag;
    
    
    assign w_real = i_real;// the lower 14 bits are the fractional part
    assign w_add_bit1 = w_real[IN_WIDTH-1] ? (w_real[fraction_bit-1] & (|w_real[fraction_bit-2:0])) : w_real[fraction_bit-1];
    assign w_temp_real = {w_real[IN_WIDTH-1],w_real[IN_WIDTH-1:fraction_bit]} + w_add_bit1;//19'b + 13 == IN_WIDTH-fraction_bit+1  +  
    assign o_round_real = { {(fraction_bit-1){w_temp_real[IN_WIDTH-fraction_bit]}}, w_temp_real };//{{(4){i_ina[3]}}, i_ina}
    
    assign w_imag = i_imag;
    assign w_add_bit2 = w_imag[IN_WIDTH-1] ? (w_imag[fraction_bit-1] & (|w_imag[fraction_bit-2:0])) : w_imag[fraction_bit-1];
    assign w_temp_imag[IN_WIDTH-fraction_bit:0] = {w_imag[IN_WIDTH-1],w_imag[IN_WIDTH-1:fraction_bit]} + w_add_bit2;
    assign o_round_imag = { {(fraction_bit-1){w_temp_imag[IN_WIDTH-fraction_bit]}}, w_temp_imag };
    
endmodule

