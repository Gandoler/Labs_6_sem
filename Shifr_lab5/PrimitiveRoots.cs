using System.Diagnostics;
using System.Numerics;

namespace Shifr_lab5;

public static class PrimitiveRoots
{
    
    public static void FindPrimitiveRoots()
    {
        Console.Write("Введите простое число: ");
        BigInteger prime = BigInteger.Parse(Console.ReadLine());

        Stopwatch stopwatch = Stopwatch.StartNew();
        List<BigInteger> primitiveRoots = new List<BigInteger>();

        for (BigInteger i = 2; i < prime && primitiveRoots.Count < 100; i++)
        {
            if (IsPrimitiveRoot(i, prime))
                primitiveRoots.Add(i);
        }

        stopwatch.Stop();

        Console.WriteLine("Первые 100 первообразных корней:");
        primitiveRoots.ForEach(p => Console.WriteLine(p));
        Console.WriteLine($"Время выполнения: {stopwatch.Elapsed}");
    }
    public static bool IsPrimitiveRoot(BigInteger a, BigInteger p)
    {
        HashSet<BigInteger> remainders = new HashSet<BigInteger>();

        // Перебираем степени от 1 до p-1 и собираем остатки от деления a^i mod p
        for (BigInteger i = 1; i < p; i++)
        {
            remainders.Add(BigInteger.ModPow(a, i, p));
        }

        // Если количество уникальных остатков равно p-1, то это первообразный корень
        return remainders.Count == (int)(p - 1);
    }
    
}