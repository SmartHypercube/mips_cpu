`timescale 1ns / 1ps

module Control(
    input clk,
    input rst,
    input [5:0]op,
    input [5:0]funct,
    output reg [3:0]stall,
    output reg [2:0]alu_op,
    output reg i_or_r,
    output reg reg_write,
    output reg load,
    output reg bus_write
);

parameter ADDI = 6'b001000;
parameter ADD  = 6'b000000;
parameter LW   = 6'b100011;
parameter SW   = 6'b101011;

always@(posedge clk or posedge rst) begin
    if(rst)
        stall <= 4'b0000;
    else
        stall <= {stall ? 1'b0 : 1'b0, stall[3:1]};
end

always@(posedge clk) begin
    case(op)
        ADDI: begin
            alu_op <= 1;
            i_or_r <= 0;
            reg_write <= 1;
            load <= 0;
            bus_write <= 0;
        end
        ADD: begin
            alu_op <= 1;
            i_or_r <= 1;
            reg_write <= 1;
            load <= 0;
            bus_write <= 0;
        end
        LW: begin
            alu_op <= 1;
            i_or_r <= 0;
            reg_write <= 1;
            load <= 1;
            bus_write <= 0;
        end
        SW: begin
            alu_op <= 1;
            i_or_r <= 0;
            reg_write <= 0;
            load <= 0;
            bus_write <= 1;
        end
        default: begin
            alu_op <= 0;
            i_or_r <= 0;
            reg_write <= 0;
            load <= 0;
        end
    endcase
end

endmodule
