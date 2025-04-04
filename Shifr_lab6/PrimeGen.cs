using System.Numerics;

namespace Shifr_lab6;

public class PrimeGen
{
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
    
    public static BigInteger GeneratePrimesInRange(BigInteger upper)
    {
        for (BigInteger i = upper; i >=0; i--)
        {
            if (IsProbablyPrime(i, 10)) 
                return i;
        }
       throw new Exception("не сгенерировалось");
    }
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
    
    public static BigInteger GenerateRandomPrime(int bitLength)
    {
        BigInteger prime;
        do
        {
            prime = GenerateRandomBigInteger(bitLength);
        } while (!IsProbablyPrime(prime, 10));
        return prime;
    }
}