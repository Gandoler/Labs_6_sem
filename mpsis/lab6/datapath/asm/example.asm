00:  addi  x1,  x0, 0x75С
04:  addi  x2,  x0, 0x8A7
08:  add   x3,  x1, x2
0C:  and   x4,  x1, x2
10:  sub   x5,  x4, x3
14:  mul   x6,  x3, x4    // неподдерживаемая инструкция
18:  jal   x15, 0x00050   // прыжок на адрес 0x68
1C:  jalr  x15, 0x0(x6)
20:  slli  x7,  x5, 31
24:  srai  x8,  x7, 1
28:  srli  x9,  x8, 29
2C:  lui   x10, 0xfadec
30:  addi  x10, x10,-1346
34:  sw    x10, 0x0(x4)
38:  sh    x10, 0x6(x4)
3C:  sb    x10, 0xb(x4)
40:  lw    x11, 0x0(x4)
44:  lh    x12, 0x0(x4)
48:  lb    x13, 0x0(x4)
4С:  lhu   x14, 0x0(x4)
50:  lbu   x15, 0x0(x4)
54:  auipc x16, 0x00004
58:  bne   x3,  x4, 0x08  // перескок через
5С:                       // нелегальную нулевую инструкцию
60:  jal   x17, 0x00004
64:  jalr  x14, 0x0(x17)
68:  jalr  x18, 0x4(x15)
