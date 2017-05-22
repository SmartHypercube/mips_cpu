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

// 这个优秀的思路来自 http://stackoverflow.com/a/2376530
wire [4:0]clo;
assign clo[4] = a[31:16] == 16'b1111111111111111;
wire [15:0]clo_v16;
assign clo_v16 = clo[4] ? a[15:0] : a[31:16];
assign clo[3] = clo_v16[15:8] == 8'b11111111;
wire [7:0]clo_v8;
assign clo_v8 = clo[3] ? clo_v16[7:0] : clo_v16[15:8];
assign clo[2] = clo_v8[7:4] == 4'b1111;
wire [3:0]clo_v4;
assign clo_v4 = clo[2] ? clo_v8[3:0] : clo_v8[7:4];
assign clo[1] = clo_v4[3:2] == 2'b11;
assign clo[0] = clo[1] ? clo_v4[1] : clo_v4[3];

wire [4:0]clz;
assign clz[4] = a[31:16] == 16'b0;
wire [15:0]clz_v16;
assign clz_v16 = clz[4] ? a[15:0] : a[31:16];
assign clz[3] = clz_v16[15:8] == 8'b0;
wire [7:0]clz_v8;
assign clz_v8 = clz[3] ? clz_v16[7:0] : clz_v16[15:8];
assign clz[2] = clz_v8[7:4] == 4'b0;
wire [3:0]clz_v4;
assign clz_v4 = clz[2] ? clz_v8[3:0] : clz_v8[7:4];
assign clz[1] = clz_v4[3:2] == 2'b0;
assign clz[0] = clz[1] ? ~clz_v4[1] : ~clz_v4[3];


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
