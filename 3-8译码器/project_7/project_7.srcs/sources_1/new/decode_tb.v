`timescale 1ns / 1ps

`include "Decode.v"

module Decode_tb;
    reg A;
    reg B;
    reg C;
    reg enable;
    wire[7:0] data_out;
    Decoder DD(
        .A(A),
        .B(B),
        .C(C),
        .data_outs(data_out),
        .enable(enable)
    );
    initial begin
        enable = 1;
        A = 1;
        B = 1;
        C = 1;
        A <= 1'b1;
        B <= 1'b1;
        C <= 1'b1;
        #100;
        A <= 1'b1;
        B <= 1'b1;
        C <= 1'b0;
        #100;
        A <= 1'b1;
        B <= 1'b0;
        C <= 1'b1;
        #100;
        A <= 1'b1;
        B <= 1'b0;
        C <= 1'b0;
        #100;
        A <= 1'b0;
        B <= 1'b1;
        C <= 1'b1;
        #100;
        A <= 1'b0;
        B <= 1'b1;
        C <= 1'b0;
        #100;
        A <= 1'b0;
        B <= 1'b0;
        C <= 1'b1;
        #100;
        A <= 1'b0;
        B <= 1'b0;
        C <= 1'b0;
    end
endmodule
