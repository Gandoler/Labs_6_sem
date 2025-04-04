using System.Diagnostics;
using System.Numerics;

namespace Shifr_lab5;

public static class PrimeGenerator
{
    
    public static BigInteger GenerateRandomBigInteger(int bitLength)
    {
        Random random = new Random();
        byte[] bytes = new byte[(bitLength + 7) / 8]; // Байты для хранения числа
        random.NextBytes(bytes);

        // Устанавливаем старший бит (чтобы число было n-битным)
        bytes[bytes.Length - 1] |= (byte)(1 << ((bitLength - 1) % 8));

        // Устанавливаем младший бит (чтобы число было нечётным)
        bytes[0] |= 1;

        return new BigInteger(bytes);
    }

    
    public static void GeneratePrimesInRange()
    {
        Console.Write("Введите нижнюю границу диапазона: ");
        BigInteger lower = BigInteger.Parse(Console.ReadLine());
        Console.Write("Введите верхнюю границу диапазона: ");
        BigInteger upper = BigInteger.Parse(Console.ReadLine());

        Stopwatch stopwatch = Stopwatch.StartNew();
        List<BigInteger> primes = new List<BigInteger>();

        for (BigInteger i = lower; i <= upper; i++)
        {
            if (IsProbablyPrime(i, 10)) 
                primes.Add(i);
        }

        stopwatch.Stop();
        Console.WriteLine("Простые числа в заданном диапазоне:");
        primes.ForEach(p => Console.WriteLine(p));
        Console.WriteLine($"Время выполнения: {stopwatch.Elapsed}");
    }
    
    
    public static BigInteger GenerateRandomPrime(int bitLength)
    {
        BigInteger prime;
        do
        {
            prime = GenerateRandomBigInteger(bitLength);
        } while (!IsProbablyPrime(prime, 10));
        return prime;
    }
    
    
    public static void GenerateLargePrime()
    {
        Console.Write("Введите количество бит: ");
        int bitLength = int.Parse(Console.ReadLine());
        Console.Write("Введите количество проверок в тесте Рабина-Миллера: ");
        int iterations = int.Parse(Console.ReadLine());

        Stopwatch stopwatch = Stopwatch.StartNew();

        int attempts = 0;
        BigInteger prime;
        do
        {
            prime = GenerateRandomBigInteger(bitLength);
            attempts++;
        } while (!IsProbablyPrime(prime, iterations));

        stopwatch.Stop();

        Console.WriteLine($"Сгенерированное простое число: {prime}");
        Console.WriteLine($"Количество попыток: {attempts}");
        Console.WriteLine($"Время выполнения: {stopwatch.Elapsed}");
    }
    
    public static bool IsProbablyPrime(BigInteger number, int iterations)
    {
        if (number < 2) return false;
        if (number == 2 || number == 3) return true;
        if (number % 2 == 0) return false;

        BigInteger d = number - 1;
        int s = 0;
        while (d % 2 == 0)
        {
            d /= 2;
            s++;
        }

        for (int i = 0; i < iterations; i++)
        {
            BigInteger a = GenerateRandomBigInteger((int)Math.Log((double)number, 2));
            if (Witness(a, number, d, s)) return false;
        }
        return true;
    }
    
    public static bool Witness(BigInteger a, BigInteger n, BigInteger d, int s)
    {
        BigInteger x = BigInteger.ModPow(a, d, n);
        if (x == 1 || x == n - 1) return false;

        for (int r = 1; r < s; r++)
        {
            x = BigInteger.ModPow(x, 2, n);
            if (x == n - 1) return false;
        }
        return true;
    }
}
