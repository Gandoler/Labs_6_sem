using System.Numerics;
using System.Security.Cryptography;

namespace Shifr_lab6;

public static class PrimeGen
{
    public static BigInteger RandomBigInteger(BigInteger min, BigInteger max)
    {
        byte[] bytes = max.ToByteArray();
        BigInteger num;
        do
        {
            new Random().NextBytes(bytes);
            num = new BigInteger(bytes);
        } while (num < min || num >= max);
        return num;
    }
    
    
    public static bool IsProbablePrime(this BigInteger value, int certainty)
    {
        if (value < 2) return false;
        if (value % 2 == 0) return value == 2;
        BigInteger d = value - 1;
        int s = 0;
        while (d % 2 == 0)
        {
            d /= 2;
            s++;
        }
        Random rng = new Random();
        for (int i = 0; i < certainty; i++)
        {
            BigInteger a = RandomBigInteger(2, value - 2);
            BigInteger x = BigInteger.ModPow(a, d, value);
            if (x == 1 || x == value - 1) continue;
            for (int r = 1; r < s; r++)
            {
                x = BigInteger.ModPow(x, 2, value);
                if (x == 1) return false;
                if (x == value - 1) break;
            }
            if (x != value - 1) return false;
        }
        return true;
    }
    public static BigInteger GeneratePrime(int bitLength)
    {
        using (var rng = new RNGCryptoServiceProvider())
        {
            byte[] bytes = new byte[bitLength / 8];
            BigInteger num;
            do
            {
                rng.GetBytes(bytes);
                bytes[bytes.Length - 1] |= 0x01;
                num = new BigInteger(bytes);
            } while (!num.IsProbablePrime(10));
            return num;
        }
    }

    public static BigInteger GenerateGenerator(BigInteger p)
    {
        return RandomBigInteger(2, p - 1);
    }

    

    public static BigInteger ModInverse(BigInteger a, BigInteger m)
    {
        BigInteger m0 = m, t, q;
        BigInteger x0 = 0, x1 = 1;
        if (m == 1) return 0;
        while (a > 1)
        {
            q = a / m;
            t = m;
            m = a % m;
            a = t;
            t = x0;
            x0 = x1 - q * x0;
            x1 = t;
        }
        if (x1 < 0) x1 += m0;
        return x1;
    }

}