#include <stdint.h>
#include "platform.h"

#define PS2_ENTER 0x5A

// Функция для подсчета количества непересекающихся вхождений "11" в двоичном представлении
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

// Функция для отображения результата на VGA
void display_result(uint32_t count) {
    char str[16];
    // Используем собственную функцию для форматирования строки, чтобы избежать использования snprintf
    int len = 0;
    if (count == 0) {
        str[len++] = '0';
    } else {
        uint32_t temp = count;
        while (temp > 0) {
            len++;
            temp /= 10;
        }
        str[len] = '\0';
        for (int i = len - 1; i >= 0; i--) {
            str[i] = (count % 10) + '0';
            count /= 10;
        }
    }

    for (int i = 0; str[i] != '\0'; i++) {
        char_map[i] = str[i];
        color_map[i] = 0x0F; // Белый цвет
    }
}

// Обработчик прерываний PS2-клавиатуры
void __attribute__((interrupt)) int_handler() {
    if (!ps2_ptr->unread_data)
        return;

    uint32_t in = ps2_ptr->scan_code;
    if (in == PS2_ENTER) {
        uint32_t sw_value = sw_ptr->value;
        int count = progres(sw_value);
        display_result(count);
    }
}

int main(int argc, char** argv) {
    while (1) {
        // Основной цикл может быть пустым, так как вся работа выполняется в обработчике прерываний
    }

    return 0;
}
