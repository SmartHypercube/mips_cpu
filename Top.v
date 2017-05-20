`timescale 1ns / 1ps

/*
GENERAL
 #rst  #########################################
  clk  _####____####____####____####____####____#
 ramaa  <  PC  >
 ramao          < ADDI >
 regaa          < #num1>
 regba          < #num2>
 regao                  < num1 >
 regbo                  < num2 >
 aluop                  <  op  >
 alua                   < num1 >
 alub                   < num2 >
 aluo                           <result>
 ramba                          <ramadd>
 rambw                          ????????
 rambi                          <result>
 rambo                                  <result>
 regca                                  < #out >
 regcw                                  ########
 regci                                  <result>
*/

module Top(
    input clk,
    input rst
);

reg [31:0]PC;
wire [3:0]Stall;
wire [31:0]Instr;
wire [2:0]AluOp;
wire [31:0]BusOut;
wire [31:0]RegA;
wire [31:0]RegB;
reg [31:0]AluOut;
wire [31:0]_AluOut;
reg [9:0]RegDst;
wire IOrR;
reg [1:0]RegWrite;
wire _RegWrite;
reg [1:0]Load;
wire _Load;
reg BusWrite;
wire _BusWrite;
reg [31:0]SignImm;
reg [31:0]RegBPrev;
reg [31:0]InstrPrev;

always@(posedge clk) begin
    RegDst <= {IOrR ? InstrPrev[15:11] : InstrPrev[20:16], RegDst[9:5]};
    RegWrite <= {_RegWrite, RegWrite[1]};
    AluOut <= _AluOut;
    Load <= {_Load, Load[1]};
    BusWrite <= _BusWrite;
    SignImm <= {(Instr[15] ? 16'hffff : 16'h0), Instr[15:0]};
    RegBPrev <= RegB;
    InstrPrev <= Instr;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        PC <= 0;
    else
        PC <= Stall ? PC : PC + 4;
end

Control control(
    .clk(clk),
    .rst(rst),
    .op(Instr[31:26]),
    .funct(Instr[5:0]),
    .stall(Stall),
    .alu_op(AluOp),
    .i_or_r(IOrR),
    .reg_write(_RegWrite),
    .load(_Load),
    .bus_write(_BusWrite)
);

Bus bus(
    .clk(clk),
    .a_addr(PC),
    .a_out(Instr),
    .b_addr(_AluOut),
    .b_we(BusWrite),
    .b_in(RegBPrev),
    .b_out(BusOut)
);

Regs regs(
    .clk(clk),
    .a_addr(Instr[25:21]),
    .a_out(RegA),
    .b_addr(Instr[20:16]),
    .b_out(RegB),
    .c_addr(RegDst[4:0]),
    .c_we(RegWrite[0]),
    .c_in(Load[0] ? BusOut : AluOut)
);

Alu alu(
    .clk(clk),
    .op(AluOp),
    .a(RegA),
    .b(IOrR ? RegB : SignImm),
    .out(_AluOut)
);

endmodule
