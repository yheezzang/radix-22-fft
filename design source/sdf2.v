`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 17:16:54
// Design Name: 
// Module Name: sdf_16point2
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


module sdf_16point2(
    clk,
    i_reset,
    i_valid,
    i_re,
    i_im,
    o_valid,
    o_re,
    o_im
    );
    
    input clk;
    input i_reset;
    input i_valid;
    
    input [15:0] i_re;
    input [15:0] i_im;
    
    output o_valid;
    output [15:0] o_re;
    output [15:0] o_im;
    
    // stage 1 -------------------------  
    wire [15:0] w_bf1_out_re;
    wire [15:0] w_bf1_out_im;
    wire [15:0] w_bf1_out2_re;
    wire [15:0] w_bf1_out2_im;
    
    wire [15:0] w_delay1_out_re;
    wire [15:0] w_delay1_out_im;
    
    // stage 2 -------------------------  
    wire [15:0] w_bf2_out_re;
    wire [15:0] w_bf2_out_im;
    wire [15:0] w_bf2_out2_re;
    wire [15:0] w_bf2_out2_im;
    
    wire [15:0] w_delay2_out_re;
    wire [15:0] w_delay2_out_im;
    
    // stage 1 -------------------------  
    reg [5:0] r_clk_count;
    reg r_bf1_start;
    reg [3:0] r_bf1_count;
    reg r_bf1_control;
    
    // stage 2 -------------------------  
    reg r_bf2_start;
    reg [3:0] r_bf2_count;
    reg r_bf2_control;
    reg r_bf2_conjugate;
    
    
    initial
    begin
        r_clk_count = 6'b0;
        r_bf1_start = 0;
        r_bf1_count = 4'b0;
        r_bf1_control = 0;
        r_bf2_start = 0;
        r_bf2_count = 4'b0;
        r_bf2_control = 0;
        r_bf2_conjugate = 0;
    end

    
    always @ (posedge clk)
    begin
        if(i_reset)begin
            r_clk_count <= 6'b0;
            r_bf1_start <= 0;
            r_bf1_count <= 4'b0;
            r_bf1_control <= 0;
            r_bf2_start <= 0;
            r_bf2_count <= 4'b0;
            r_bf2_control <= 0;
            r_bf2_conjugate <= 0;
        end
        else begin
            r_bf2_control <= 0;
            
            if(i_valid)begin
                r_clk_count <= r_clk_count + 1;
            end 
            else begin
                r_clk_count <= 0;
            end
            
            if(r_clk_count == 1) begin
                r_bf1_start <= 1;
                r_bf1_control <= 1;
            end
            else if (r_clk_count == 2) begin 
                r_bf2_start <= 1;
                r_bf2_control <= 1;
            end
            
            if(r_bf1_start) begin
                r_bf1_count <= r_bf1_count + 1;
            end
            else begin
            end
            
            if (r_bf1_count[1:0] == 2'b01) begin //01
                r_bf1_control <= 0;
            end
            else if (r_bf1_count[1:0] == 2'b11 && r_bf1_count != 15) begin //011
                r_bf1_control <= 1;
            end
            else if (r_bf1_count == 15) begin //01111
                r_bf1_control <= 0;
                r_bf1_start <= 0;
            end
            else begin
            end
            
            
            if (r_bf1_count[1:0] == 2'b10) begin 
                r_bf2_conjugate <= 1;
            end
            else begin 
                r_bf2_conjugate <= 0;
            end
            
            if(r_bf2_start) begin
                r_bf2_count <= r_bf2_count + 1;
            end
            else begin
            end
            
            if (r_bf2_count[0] == 1 && r_bf2_count != 15) begin
                r_bf2_control <= 1;
            end
            else if (r_bf2_count == 15) begin
                r_bf2_start <= 0;
                r_bf2_control <= 0;
            end
            else begin
            end
    
        end
    end
    
    
    delay #(
        .DEPTH(2), 
        .WIDTH(16)) 
    Delay1(
        .clk(clk),
        .i_rZ(w_bf1_out2_re),
        .i_iZ(w_bf1_out2_im),
        .o_rZ(w_delay1_out_re),
        .o_iZ(w_delay1_out_im)
    );
    
    butterfly_1 #(
        .WIDTH(16)) 
    Bf1(
        .i_rX(w_delay1_out_re),
        .i_iX(w_delay1_out_im),
        .i_rX2(i_re),
        .i_iX2(i_im),
        .control(r_bf1_control),
        .o_rZ(w_bf1_out_re),
        .o_iZ(w_bf1_out_im),
        .o_rZ2(w_bf1_out2_re),
        .o_iZ2(w_bf1_out2_im)
    );
    
    
    delay #(
        .DEPTH(1), 
        .WIDTH(16)) 
    Delay2(
        .clk(clk),
        .i_rZ(w_bf2_out2_re),
        .i_iZ(w_bf2_out2_im),
        .o_rZ(w_delay2_out_re),
        .o_iZ(w_delay2_out_im)
    );
    
    butterfly_2 #(
        .WIDTH(16)) 
    Bf2(
        .i_rX(w_delay2_out_re),
        .i_iX(w_delay2_out_im),
        .i_rX2(w_bf1_out_re),
        .i_iX2(w_bf1_out_im),
        .control(r_bf2_control),
        .conjugate(r_bf2_conjugate),
        .o_rZ(w_bf2_out_re),
        .o_iZ(w_bf2_out_im),
        .o_rZ2(w_bf2_out2_re),//delay input
        .o_iZ2(w_bf2_out2_im)//delay input
     );
     
     // output --------------------------------
     assign o_re = w_bf2_out_re;
     assign o_im = w_bf2_out_im;
     
     assign o_valid = r_bf2_start;
    
endmodule
