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
    }
    static void DiffieHellmanKeyExchange()
    {
        Console.WriteLine("Введите простые числа p и g или оставьте пустыми для случайной генерации:");
        Console.Write("p: ");
        string pInput = Console.ReadLine();
        Console.Write("g: ");
        string gInput = Console.ReadLine();

        BigInteger p = string.IsNullOrEmpty(pInput) ? PrimeGenerator.GenerateRandomPrime(256) : BigInteger.Parse(pInput);
        BigInteger g = string.IsNullOrEmpty(gInput) ? PrimeGenerator.GenerateRandomPrime(256) : BigInteger.Parse(gInput);

        Console.WriteLine($"Используемые параметры: p = {p}, g = {g}");

        BigInteger a = PrimeGenerator.GenerateRandomBigInteger(256);
        BigInteger b = PrimeGenerator.GenerateRandomBigInteger(256);

        BigInteger A = BigInteger.ModPow(g, a, p);
        BigInteger B = BigInteger.ModPow(g, b, p);

        BigInteger secretKeyAlice = BigInteger.ModPow(B, a, p);
        BigInteger secretKeyBob = BigInteger.ModPow(A, b, p);

        Console.WriteLine($"Секретный ключ Алисы: {secretKeyAlice}");
        Console.WriteLine($"Секретный ключ Боба: {secretKeyBob}");
    }
    
}
