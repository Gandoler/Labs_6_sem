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
