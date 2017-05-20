`timescale 1ns / 1ps

module Bus(
    input clk,
    input [31:0]a_addr,
    output [31:0]a_out,
    input [31:0]b_addr,
    input b_we,
    input [31:0]b_in,
    output [31:0]b_out
);

Ram ram(
    .clka(clk),
    .wea(0),
    .addra(a_addr[7:2]),
    .dina(0),
    .douta(a_out),
    .clkb(clk),
    .web(b_we),
    .addrb(b_addr[7:2]),
    .dinb(b_in),
    .doutb(b_out)
);

endmodule
