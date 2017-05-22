`timescale 1ns / 1ps

module Control(
    input clk,
    input [5:0]op,
    input [5:0]funct,
    output reg [4:0]alu_op,
    output reg i_or_r,
    output reg reg_write,
    output reg load,
    output reg bus_write,
    output reg branch,
    output reg jump
);

parameter CL = 6'b011100;

always@(posedge clk) begin
    i_or_r <= !op;
    reg_write <= (op[5] ^ op[3]) || !op;
    bus_write <= op[5] & op[3];
    load <= op[5] & ~op[3];
    branch <= ~op[5] & ~op[3] & (op[2] | ~op[1] & op[0]);
    jump <= ~op[5] & ~op[3] & ~op[2] & op[1];
    alu_op <= op[5] ? 0 :
              op ? (op[3] ? 0 : 16) | (op == CL ? funct : 0) | op :
              funct;
end

endmodule
