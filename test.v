`timescale 1ns / 1ps

module test;

reg clk;
reg rst;

Top uut (
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 1;
    rst = 0;
    #5;
    rst = 1;
    #10;
    rst = 0;
end

always begin
    #5;
    clk = ~clk;
end

endmodule
