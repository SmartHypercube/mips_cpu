`timescale 1ns / 1ps

module Cl(
    input [31:0]value,
    input bit,
    output [4:0]result
);

// 这个优秀的思路来自 http://stackoverflow.com/a/2376530
assign result[4] = value[31:16] == (bit ? -1 : 0);
wire [15:0]v16;
assign v16 = result[4] ? value[15:0] : value[31:16];

assign result[3] = v16[15:8] == (bit ? -1 : 0);
wire [7:0]v8;
assign v8 = result[3] ? v16[7:0] : v16[15:8];

assign result[2] = v8[7:4] == (bit ? -1 : 0);
wire [3:0]v4;
assign v4 = result[2] ? v8[3:0] : v8[7:4];

assign result[1] = v4[3:2] == (bit ? -1 : 0);

assign result[0] = ~bit ^ (result[1] ? v4[1] : v4[3]);

endmodule
