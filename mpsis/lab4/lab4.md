# lab4 

## 🧠 Как устроена инструкция?
Инструкция — это 32-битное слово:

Биты	Назначение
- [31]	Jump (безусловный переход)
- [30]	Branch (условный переход)
- [29:28]	Мультиплексор данных на запись
- [27:23]	Операция ALU
- [22:18]	Адрес регистра 1 (rd1)
- [17:13]	Адрес регистра 2 (rd2)
- [12:5]	Смещение для перехода или immediate
- [4:0]	Адрес записи (rd)





# перевод в двоичную 

using System;
using System.Collections.Generic;

class Program
{
    public static void Main()
    {
        var numbers = new List<string>();
        Console.WriteLine("Вводите шестнадцатеричные числа построчно. Пустая строка — конец ввода:");

        while (true)
        {
            string? line = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(line))
                break;

            numbers.Add(line);
        }

        foreach (var hex in numbers)
        {
            try
            {
                int decimalValue = Convert.ToInt32(hex, 16);
                string binary = Convert.ToString(decimalValue, 2);
                string binary32 = binary.PadLeft(32, '0');
                Console.WriteLine($"{binary32}");
            }
            catch (FormatException)
            {
                Console.WriteLine($"{hex} — некорректный формат");
            }
        }
    }
}
