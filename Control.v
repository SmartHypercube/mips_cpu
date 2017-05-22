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

// 目前支持的指令列表
// 使用了简化的指令解析，在遇到不支持的指令时会出现不可预料的行为

// op:
parameter ADDIU = 6'b001001;
parameter ANDI  = 6'b001100;
parameter ORI   = 6'b001101;
parameter XORI  = 6'b001110;
parameter LUI   = 6'b001111;
parameter SLTI  = 6'b001010;
parameter SLTIU = 6'b001011;

parameter CL    = 6'b011100;
    parameter CLO   = 6'b100001;
    parameter CLZ   = 6'b100000;

parameter BEQ   = 6'b000100;
parameter BGTZ  = 6'b000111;
parameter BLEZ  = 6'b000110;
parameter BLTZ  = 6'b000001;
parameter BNE   = 6'b000101;
parameter J     = 6'b000010;

parameter LB    = 6'b100000; // 此区暂未支持
parameter LBU   = 6'b100100;
parameter LH    = 6'b100001;
parameter LHU   = 6'b100101;

parameter LW    = 6'b100011;
parameter SW    = 6'b101011;

// op = 0, funct:
parameter ADDU  = 6'b100001;
parameter AND   = 6'b100100;
parameter NOR   = 6'b100111;
parameter OR    = 6'b100101;
parameter SUBU  = 6'b100011;
parameter XOR   = 6'b100110;
parameter SLT   = 6'b101010;
parameter SLTU  = 6'b101011;

parameter MOVN  = 6'b001011; // 此区暂未支持
parameter MOVZ  = 6'b001010;

parameter SLL   = 6'b000000; // 此区暂未支持
parameter SLLB  = 6'b000100;
parameter SRA   = 6'b000011;
parameter SRAV  = 6'b000111;
parameter SRL   = 6'b000010;
parameter SRLV  = 6'b000110;

parameter JR    = 6'b001000; // 此区暂未支持

// 未实现中断所以无法正确支持，但因使用广泛，故提供近似支持的指令
parameter ADDI  = 6'b001000;
parameter ADD   = 6'b100000;

always@(posedge clk) begin
    i_or_r <= !op;
    reg_write <= (op[5] ^ op[3]) || op;
    bus_write <= op[5] & op[3];
    load <= op[5] & ~op[3];
    branch <= ~op[5] & ~op[3] & (op[2] | ~op[1] & op[0]);
    jump <= ~op[5] & ~op[3] & ~op[2] & op[1];
    alu_op <= op[5] ? 0 :
              op ? (op[3] ? 0 : 16) | (op == CL ? funct : 0) | op :
              funct;
end

endmodule
