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

reg [159:0]PC;      // 当前PC在低位，高位依次为历史上的PC
reg [3:0]PCE;       // 指示PC四段历史中的有效部分，无效的无须考虑冒险
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
    AluOut <= _AluOut;
    RegWrite <= {_RegWrite, RegWrite[1]};
    Load <= {_Load, Load[1]};
    BusWrite <= _BusWrite;
    SignImm <= {(Instr[15] ? 16'hffff : 16'h0), Instr[15:0]};
    RegBPrev <= RegB;
    InstrPrev <= Instr;
end

// 检测冒险
always@(posedge clk or posedge rst) begin
    if(rst) begin
        PC <= 0;
        PCE <= 0;
    end
    else begin
        PC <= {PC[127:0], PC[31:0] + 4};
        PCE <= {PCE[2:0], 1'b1};
        if(BusWrite & PCE[2]) begin
            // 正在执行的指令可能被修改了
            if(_AluOut == PC[95:64] && PCE[1]) begin
                // 重新执行上两条指令
                PC <= PC[95:64];
                PCE <= 4'b1100;
            end
            else if(_AluOut == PC[63:32] && PCE[0]) begin
                // 重新执行上一条指令
                PC <= PC[63:32];
                PCE <= 4'b1110;
            end
        end
        if(RegWrite[1] & PCE[2]) begin
            // 要读取的寄存器可能被修改了
            if(InstrPrev[25:21] == RegDst[9:5] && PCE[1]) begin
                // 重新执行上两条指令
                PC <= PC[95:64];
                PCE <= {PCE[0], 3'b000};
            end
            else if(InstrPrev[20:16] == RegDst[9:5] && PCE[1]) begin
                // 重新执行上两条指令
                PC <= PC[95:64];
                PCE <= {PCE[0], 3'b000};
            end
            else if(Instr[25:21] == RegDst[9:5] && PCE[0]) begin
                // 重新执行上一条指令
                PC <= PC[63:32];
                PCE <= {PCE[1:0], 2'b00};
            end
            else if(Instr[20:16] == RegDst[9:5] && PCE[0]) begin
                // 重新执行上一条指令
                PC <= PC[63:32];
                PCE <= {PCE[1:0], 2'b00};
            end
        end
    end
end

Control control(
    .clk(clk),
    .op(Instr[31:26]),
    .funct(Instr[5:0]),
    .alu_op(AluOp),
    .i_or_r(IOrR),
    .reg_write(_RegWrite),
    .load(_Load),
    .bus_write(_BusWrite)
);

Bus bus(
    .clk(clk),
    .a_addr(PC[31:0]),
    .a_out(Instr),
    .b_addr(_AluOut),
    .b_we(BusWrite & PCE[2]),
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
    .c_we(RegWrite[0] & PCE[3]),
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
