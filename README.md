MIPS CPU
========

**注意**：本项目是计算机组成原理课程大作业，依原样（AS IS）提供，没有任何保证。只实现了MIPS CPU的部分规范，并且不会在课程结束后继续维护。

目前实现的特性：

- 五级流水线
- 检测流水线冒险，包括“下一条指令被之前的指令修改了”这种情况
- 遇到冒险时阻塞
- 总预测分支不发生，预测错误时清空流水线

目前支持的指令：

- `addiu`
- `andi`
- `ori`
- `xori`
- `lui`
- `slti`
- `sltiu`
- `clo`
- `clz`
- `beq`
- `bgtz`
- `blez`
- `bltz`
- `bne`
- `j`
- `lw`
- `sw`
- `addu`
- `and`
- `nor`
- `or`
- `subu`
- `xor`
- `slt`
- `sltu`

由于未实现中断功能，所以无法支持，但提供近似支持的指令：

- `addi`
- `add`

打算支持的指令：

- `lb`
- `lbu`
- `lh`
- `lhu`
- `movn`
- `movz`
- `sll`
- `sllb`
- `sra`
- `srav`
- `srl`
- `srlv`
- `jr`
