`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 01:39:31
// Design Name: 
// Module Name: sdf_16point
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


module sdf_16point(
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
    
    wire [3:0] w_twi_addr;
    wire [31:0] w_twiddle;
    
    // multiply twiddle factor ------------
    wire [31:0] w_mul_out_re;
    wire [31:0] w_mul_out_im;
    
    wire [31:0] w_round_out_re;
    wire [31:0] w_round_out_im;
    
    wire [15:0] w_sat_out_re;
    wire [15:0] w_sat_out_im;
    
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
    
    // ---------------------------------
    reg [15:0] r_bf2_out_delay1_re;
    reg [15:0] r_bf2_out_delay1_im;
    reg [15:0] r_bf2_out_delay2_re;
    reg [15:0] r_bf2_out_delay2_im;
    
    reg r_o_valid_delay1;
    reg r_o_valid_delay2;
    
    initial
    begin
        r_clk_count     = 6'b0;
        r_bf1_start     = 1'b0;
        r_bf1_count     = 4'b0;
        r_bf1_control   = 1'b0;
        r_bf2_start     = 1'b0;
        r_bf2_count     = 4'b0;
        r_bf2_control   = 1'b0;
        r_bf2_conjugate = 1'b0;
        
        r_bf2_out_delay1_re = 0;
        r_bf2_out_delay1_im = 0;
        r_bf2_out_delay2_re = 0;
        r_bf2_out_delay2_im = 0;
        
        r_o_valid_delay1 = 0;
        r_o_valid_delay2 = 0;
    end

    
    always @ (posedge clk)
    begin
        if(i_reset)begin
            r_clk_count     <= 6'b0;
            r_bf1_start     <= 1'b0;
            r_bf1_count     <= 4'b0;
            r_bf1_control   <= 1'b0;
            r_bf2_start     <= 1'b0;
            r_bf2_count     <= 4'b0;
            r_bf2_control   <= 1'b0;
            r_bf2_conjugate <= 1'b0;
        end
        else begin
            if(i_valid)begin
                r_clk_count <= r_clk_count + 1;
            end 
            else begin
                r_clk_count <= 0;
            end
            
            if(r_clk_count == 7) begin
                r_bf1_start <= 1;
                r_bf1_control <= 1;
            end
            else begin
            end
            
            if(r_bf1_start) begin
                r_bf1_count <= r_bf1_count + 1;
            end
            else begin
            end
            
            
            if (r_bf1_count == 3) begin 
                r_bf2_start <= 1;
                r_bf2_control <= 1;
            end   
            else if (r_bf1_count == 7) begin 
                r_bf1_control <= 0;
            end
            else if (r_bf1_count == 15) begin 
                r_bf1_start <= 0;
            end
            else begin
            end
            
            if(r_bf2_start) begin
                r_bf2_count <= r_bf2_count + 1;
            end
            else begin
            end
            
            if (r_bf2_count == 3) begin
                r_bf2_control <= 0;
            end
            else if (r_bf2_count == 7) begin
                r_bf2_control <= 1;
                r_bf2_conjugate <= 1;
            end
            else if (r_bf2_count == 11) begin
                r_bf2_control <= 0;
                r_bf2_conjugate <= 0;
            end
            else if (r_bf2_count == 15) begin
                r_bf2_start <= 0;
            end
            else begin
            end
    
        end
    end
    
    // stage 1 -----------------------------------------------
    delay #(.DEPTH(8), .WIDTH(16)) Delay1(
        .clk(clk),
        .i_rZ(w_bf1_out2_re),
        .i_iZ(w_bf1_out2_im),
        .o_rZ(w_delay1_out_re),
        .o_iZ(w_delay1_out_im)
    );
    
    butterfly_1 #(.WIDTH(16)) Bf1(
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
    

    // stage 2 -----------------------------------------------
    delay #(.DEPTH(4), .WIDTH(16)) Delay2(
        .clk(clk),
        .i_rZ(w_bf2_out2_re),
        .i_iZ(w_bf2_out2_im),
        .o_rZ(w_delay2_out_re),
        .o_iZ(w_delay2_out_im)
    );
    
    butterfly_2 #(.WIDTH(16)) Bf2(
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
    
    assign w_twi_addr = r_bf2_count[1:0] * {r_bf2_count[2], r_bf2_count[3]};
    
    
    // multiply twiddle factor -----------------------------------------------
    blk_mem_gen_0 Twiddle_ROM (
      .clka(clk),    // input wire clka
      .addra(w_twi_addr),  // input wire [3 : 0] addra
      .douta(w_twiddle)  // output wire [31 : 0] douta
    );
    
    always @(posedge clk)// ROM ÀÌ¶û dealy ¸ÂÃçÁÜ 
    begin
        if(i_reset)begin
        r_bf2_out_delay1_re <= 16'b0;
        r_bf2_out_delay1_im <= 16'b0;
        r_bf2_out_delay2_re <= 16'b0;
        r_bf2_out_delay2_im <= 16'b0;
        
        r_o_valid_delay1 <= 0;
        r_o_valid_delay2 <= 0;
        end
        
        else begin
            r_bf2_out_delay1_re <= w_bf2_out_re;
            r_bf2_out_delay1_im <= w_bf2_out_im;
            
            r_bf2_out_delay2_re <= r_bf2_out_delay1_re;
            r_bf2_out_delay2_im <= r_bf2_out_delay1_im;
            
            r_o_valid_delay1 <= r_bf2_start;
            r_o_valid_delay2 <= r_o_valid_delay1;
        end
    end    
    
    multiply #(.WIDTH(16)) Multilpy1(
        .a_re(r_bf2_out_delay2_re),
        .a_im(r_bf2_out_delay2_im),
        .b_re(w_twiddle[31:16]),
        .b_im(w_twiddle[15:0]),
        .m_re(w_mul_out_re),
        .m_im(w_mul_out_im)
    );
    
    round #(
        .IN_WIDTH(32), 
        .OUT_WIDTH(32), 
        .fraction_bit(14)) 
    Round1 (
        .i_real(w_mul_out_re),
        .i_imag(w_mul_out_im),
        .o_round_real(w_round_out_re),
        .o_round_imag(w_round_out_im)
    );
    
    saturation #(
        .IN_WIDTH(32), 
        .OUT_WIDTH(16)) 
    Sat1(
        .i_real(w_round_out_re),
        .i_imag(w_round_out_im),
        .o_sat_real(w_sat_out_re),
        .o_sat_imag(w_sat_out_im)
    );
    
    // output ----------------------------
     assign o_re = w_sat_out_re;
     assign o_im = w_sat_out_im;
     
     assign o_valid = r_o_valid_delay2;

endmodule
