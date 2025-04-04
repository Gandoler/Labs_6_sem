using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Security.Cryptography;
using Shifr_lab5;

class Program
{
    static void Main()
    {
        while (true)
        {
            Console.Clear();
            Console.WriteLine("Выберите действие:");
            Console.WriteLine("1 - Генерация большого простого числа");
            Console.WriteLine("2 - Вывод простых чисел в заданном диапазоне");
            Console.WriteLine("3 - Нахождение первообразных корней");
            Console.WriteLine("4 - Моделирование обмена ключами по схеме Диффи-Хеллмана");
            Console.WriteLine("<Любое другое> - выход");

            switch (Console.ReadLine())
            {
                case "1":
                    PrimeGenerator.GenerateLargePrime();
                    break;
                case "2":
                    PrimeGenerator.GeneratePrimesInRange();
                    break;
                case "3":
                    PrimitiveRoots.FindPrimitiveRoots();
                    break;
                case "4":
                    DiffieHellmanKeyExchange();
                    break;
                default:
                    Console.WriteLine("выход");
                    return;
            }

            Console.ReadKey();
        }
    }
    static void DiffieHellmanKeyExchange()
    {
        Console.WriteLine("Введите простые числа p и g или оставьте пустыми для случайной генерации:");
        Console.Write("p: ");
        string pInput = Console.ReadLine();
        Console.Write("g: ");
        string gInput = Console.ReadLine();

        // Генерация простых чисел p и g
        BigInteger p = string.IsNullOrEmpty(pInput) ? PrimeGenerator.GenerateRandomPrime(256) : BigInteger.Parse(pInput);
        BigInteger g = string.IsNullOrEmpty(gInput) ? PrimeGenerator.GenerateRandomPrime(256) : BigInteger.Parse(gInput);

        // Проверка на корректность параметров
        if (p <= 1 || g <= 1 || g >= p)
        {
            Console.WriteLine("Ошибка: параметры p и g должны быть простыми числами, а g должно быть меньше p.");
            return;
        }

        Console.WriteLine($"Используемые параметры: p = {p}, g = {g}");

        // Генерация случайных чисел для а и b
        BigInteger a = GeneratePrimesInRange(p);
        BigInteger b = GeneratePrimesInRange(p);

        // Вычисление открытых ключей
        BigInteger A = BigInteger.ModPow(g, a, p);
        BigInteger B = BigInteger.ModPow(g, b, p);

        // Вычисление секретных ключей
        BigInteger secretKeyAlice = BigInteger.ModPow(B, a, p);
        BigInteger secretKeyBob = BigInteger.ModPow(A, b, p);

        Console.WriteLine($"Секретный ключ Алисы: {secretKeyAlice}");
        Console.WriteLine($"Секретный ключ Боба: {secretKeyBob}");
        Console.WriteLine($"Открытый ключ Алисы: {A}");
        Console.WriteLine($"Открытый ключ Алисы: {B}");
    }


    public static BigInteger GeneratePrimesInRange(BigInteger upper)
    {
        for (BigInteger i = upper; i >=0; i--)
        {
            if (PrimeGenerator.IsProbablyPrime(i, 10)) 
                return i;
        }
        throw new Exception("не сгенерировалось");
    }
}
