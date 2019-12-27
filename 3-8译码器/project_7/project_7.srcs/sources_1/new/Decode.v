`timescale 1ns / 1ps

module Decoder(
	input wire A,
	input wire B,
	input wire C,
	input wire enable,
	output reg[7:0] data_outs

);


wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;

wire[7:0] data_out;


assign	SYNTHESIZED_WIRE_12 =  ~A;



assign	data_out[7] = A & B & C;

assign	SYNTHESIZED_WIRE_13 =  ~B;

assign	SYNTHESIZED_WIRE_14 =  ~C;

assign	data_out[6] = A & B & SYNTHESIZED_WIRE_14;

assign	data_out[0] = SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_14;

assign	data_out[1]= SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & C;

assign	data_out[2] = SYNTHESIZED_WIRE_12 & B & SYNTHESIZED_WIRE_14;

assign	data_out[3] = SYNTHESIZED_WIRE_12 & B & C;

assign	data_out[4] = A & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_14;

assign	data_out[5] = A & SYNTHESIZED_WIRE_13 & C;

always @ (*)begin
  data_outs = data_out;
  end

endmodule