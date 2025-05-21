#include <stdint.h>
#include <stdio.h>
#include "platform.h"

const int  a = 1;

int progres(uint32_t value) {
    int res = 0;
   uint16_t n = value & 0xFF;
   uint16_t d = (value >> 8) & 0xFF;
   n--;
   while (d > 0) {
       res += n;
       d--;
   }
   res += a;
   return res;
}
// Функция для отображения строки на VGA
void display_result(const char* str) {
    uint32_t x = 0;
    uint32_t y = 0;
    uint32_t index = y * 80 + x;

    for (int i = 0; str[i] != '\0'; i++) {
        vga.char_map[index + i] = str[i];
        vga.color_map[index + i] = 0x0F; // Белый цвет
    }
}

// Обработчик прерываний PS2-клавиатуры
 void int_handler() {
    if (!ps2_ptr->unread_data)
        return;

    uint32_t in = ps2_ptr->scan_code;
    // Реализация ввода с PS2 и отображения на VGA может быть расширена здесь
}

int main(int argc, char** argv) {
    while (1) {
        uint32_t sw_value = sw_ptr->value; // Считываем значение с переключателей
        int count = progres(sw_value); 

        char result[16];
        snprintf(result, sizeof(result), "Count: %d", count); // Формируем строку для отображения

        display_result(result); // Отображаем результат на VGA

        for (volatile int i = 0; i < 1000000; i++); // Небольшая задержка
    }

    return 0;
}
