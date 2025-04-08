using System;
using System.Collections.Generic;

class Program
{
    public static void Main()
    {
        var binaries = new List<string>();
        Console.WriteLine("Вводите двоичные числа построчно. Пустая строка — конец ввода:");

        while (true)
        {
            string? line = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(line))
                break;

            binaries.Add(line);
        }

        Console.WriteLine("\nПеревод в шестнадцатеричную систему:");
        foreach (var binary in binaries)
        {
            try
            {
                int decimalValue = Convert.ToInt32(binary, 2);
                string hex = decimalValue.ToString("X");
                string hex32 = hex.PadLeft(8, '0');
                Console.WriteLine($"{hex32}");
            }
            catch (FormatException)
            {
                Console.WriteLine($"{binary} — некорректный двоичный формат");
            }
        }
    }
}
