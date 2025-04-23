0x000297b7	lui x15 41	lui x15, 0x29 # x15 = 101001
0x00578793	addi x15 x15 5	addi x15, x15, 0x5 # x15 += const
0x00f02023	sw x15 0(x0)	sw x15, 0x0(x0) #загружаем
0x000000b7	lui x1 0	lui x1, 0x00000 # Загружаем старшие биты (но в данном случае они нулевые)
0x00508093	addi x1 x1 5	addi x1, x1, 0x5 # x1 = 0x00000514
0x00002103	lw x2 0(x0)	lw x2, 0(x0) # x2 = sw_i
0x00700193	addi x3 x0 7	addi x3, x0, 7 # x3 = 7
0x00000213	addi x4 x0 0	addi x4, x0, 0 # x4 = 0
0x00000293	addi x5 x0 0	addi x5, x0, 0 # x5 = 0
0x00100313	addi x6 x0 1	addi x6, x0, 1 # x6 = 1
0x00000393	addi x7 x0 0	addi x7, x0, 0 # x7 = 0
0x00000413	addi x8 x0 0	addi x8, x0, 0 # x8 = 0
0x00300493	addi x9 x0 3	addi x9, x0, 3 # x9 = 3
0x00000513	addi x10 x0 0	addi x10, x0, 0 # x10 = 0
0x00317133	and x2 x2 x3	and x2, x2, x3 # x2 = x2 & x3 (маска 0b111)
0x0030f2b3	and x5 x1 x3	and x5, x1, x3 # x5 = x1 & x3
0x02510063	beq x2 x5 32	beq x2, x5, match_case # Если равны -> match_case
0x0060f3b3	and x7 x1 x6	and x7, x1, x6 # x7 = x1 & x6 (x6=1)
0x004393b3	sll x7 x7 x4	sll x7, x7, x4 # x7 = x7 << x4
0x00746433	or x8 x8 x7	or x8, x8, x7 # x8 = x8 | x7
0x00620233	add x4 x4 x6	add x4, x4, x6 # x4 = x4 + x6 (x6=1)
0x0010d093	srli x1 x1 1	srli x1, x1, 1 # x1 = x1 >> 1
0xfea090e3	bne x1 x10 -32	bne x1, x10, loop_start # if (x1 != 0) goto loop_start
0x0000006f	jal x0 0	jal x0, output_loop # Бесконечный цикл (вывод x8)
0x0030d093	srli x1 x1 3	srli x1, x1, 3 # x1 = x1 >> 3
0xfca09ae3	bne x1 x10 -44	bne x1, x10, loop_start # if (x1 != 0) goto loop_start
0xff5ff06f	jal x0 -12
