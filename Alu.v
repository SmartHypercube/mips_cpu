`timescale 1ns / 1ps

module Alu(
    input clk,
    input [4:0]op,
    input [31:0]a,
    input [31:0]b,
    output reg [31:0]out
);

wire signed [31:0]sa;
assign sa = a;
wire signed [31:0]sb;
assign sb = b;
wire [4:0]clo;
wire [4:0]clz;

Cl _clo(
    .value(a),
    .bit(1),
    .result(clo)
);

Cl _clz(
    .value(a),
    .bit(0),
    .result(clz)
);

// 以下编码采用op或funct的低4位
parameter ADD1 = 0;
parameter ADD2 = 1;
parameter SUB  = 3;
parameter AND1 = 4;
parameter OR1  = 5;
parameter XOR1 = 6;
parameter NOR  = 7;
parameter ADD3 = 8;
parameter ADD4 = 9;
parameter LT   = 10;
parameter LTU  = 11;
parameter AND2 = 12;
parameter OR2  = 13;
parameter XOR2 = 14;
parameter LU   = 15;

// 以下编码比较随意，但仍有规律
parameter LTZ  = 17;
parameter EQ   = 20;
parameter NE   = 21;
parameter LEZ  = 22;
parameter GTZ  = 23;
parameter GEZ  = 25;
parameter CLO  = 28;
parameter CLZ  = 29;

always@(posedge clk) begin
    case(op)
        ADD1: out <= a + b;
        ADD2: out <= a + b;
        ADD3: out <= a + b;
        ADD4: out <= a + b;
        SUB:  out <= a - b;
        AND1: out <= a & b;
        AND2: out <= a & b;
        OR1:  out <= a | b;
        OR2:  out <= a | b;
        XOR1: out <= a ^ b;
        XOR2: out <= a ^ b;
        NOR:  out <= ~(a | b);
        LT:   out <= sa < sb;
        LTU:  out <= a < b;
        LU:   out <= {a[15:0], 16'b0};
        LTZ:  out <= a[31];
        EQ:   out <= a == b;
        NE:   out <= a != b;
        LEZ:  out <= a[31] | ~|a;
        GTZ:  out <= ~a[31] & |a;
        GEZ:  out <= ~a[31];
        CLO:  out <= clo;
        CLZ:  out <= clz;
    endcase
end

endmodule
