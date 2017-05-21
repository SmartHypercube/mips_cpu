`timescale 1ns / 1ps

module Regs(
    input clk,
    input [4:0]a_addr,
    output reg [31:0]a_out,
    input [4:0]b_addr,
    output reg [31:0]b_out,
    input [4:0]c_addr,
    input c_we,
    input [31:0]c_in
);

reg [31:0]r[31:0];

always@(posedge clk) begin
    a_out <= a_addr ? ((c_we && a_addr == c_addr) ? c_in : r[a_addr]) : 0;
    b_out <= b_addr ? ((c_we && b_addr == c_addr) ? c_in : r[b_addr]) : 0;
    if(c_we)
        r[c_addr] <= c_in;
end

endmodule
