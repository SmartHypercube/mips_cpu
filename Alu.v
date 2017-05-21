`timescale 1ns / 1ps

module Alu(
    input clk,
    input [2:0]op,
    input signed [31:0]a,
    input signed [31:0]b,
    output reg signed [31:0]out
);

parameter ADD = 1;
parameter GT  = 7;

always@(posedge clk) begin
    case(op)
        ADD:     out <= a + b;
        GT:      out <= a > b;
        default: out <= 0;
    endcase
end

endmodule
