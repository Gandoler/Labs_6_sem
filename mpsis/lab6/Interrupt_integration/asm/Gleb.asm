lui x15, 0x0 # x15 = 0
addi x15, x15, 0x5 # x15 += const =101
sw x15, 0x0(x0) #загружаем

# x1 = a (константа 0x00000514)
lui x1, 0x29        # Загружаем старшие биты (но в данном случае они нулевые)
addi x1, x1, 0x5     # x1 = 101001000000000101: a = 29005
# x2 = sw_i (входные данные, изначально 0)
lw   x2, 0(x0)         # x2 = sw_i
# x3 = маска (0b111)
addi x3, x0, 7         # x3 = 7
# x4 = переменная переноса (изначально 0)
addi x4, x0, 0         # x4 = 0
# x5 = правые 3 бита a (временно 0)
addi x5, x0, 0         # x5 = 0
# x6 = 1 (для счетчика)
addi x6, x0, 1         # x6 = 1
# x7 = tmp (временно 0)
addi x7, x0, 0         # x7 = 0
# x8 = answer (изначально 0)
addi x8, x0, 0         # x8 = 0
# x9 = 3 (для сдвига на 3)
addi x9, x0, 3         # x9 = 3
# x10 = 0 (константа для сравнения)
addi x10, x0, 0        # x10 = 0

# ===== Основной цикл =====
loop_start:
# Получаем правые 3 бита sw_i: x2 = sw_i & 0b111
and x2, x2, x3         # x2 = x2 & x3 (маска 0b111)

# Получаем правые 3 бита a: x5 = a & 0b111
and x5, x1, x3         # x5 = x1 & x3

# Сравниваем x2 и x5 (sw_i[2:0] и a[2:0])
beq x2, x5, match_case # Если равны -> match_case

# ===== Нет совпадения (No match) =====
# Получаем младший бит a: x7 = a & 1
and x7, x1, x6         # x7 = x1 & x6 (x6=1)

# Сдвигаем бит на текущую позицию: x7 = x7 << x4
sll x7, x7, x4         # x7 = x7 << x4

# Добавляем бит в ответ: x8 = x8 | x7
or x8, x8, x7          # x8 = x8 | x7

# Увеличиваем счетчик позиции: x4 = x4 + 1
add x4, x4, x6         # x4 = x4 + x6 (x6=1)

# Сдвигаем a вправо на 1 бит: x1 = x1 >> 1
srli x1, x1, 1         # x1 = x1 >> 1

# Если a != 0, продолжаем цикл
bne x1, x10, loop_start # if (x1 != 0) goto loop_start

# ===== Вывод результата (бесконечный цикл) =====
output_loop:
    add x8, x8, x0      # Увеличиваем x8 на 1 (или другую операцию)
    jal x0, output_loop # Бесконечный цикл (переход на метку output_loop)

# ===== Совпадение младших 3 бит (Match case) =====
match_case:
# Сдвигаем a вправо на 3 бита: x1 = x1 >> 3
srl x1, x1, x9         # x1 = x1 >> 3

# Если a != 0, продолжаем цикл
bne x1, x10, loop_start # if (x1 != 0) goto loop_start

# Иначе переходим в бесконечный цикл вывода
jal x0, output_loop
