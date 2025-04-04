using System.Numerics;
using System.Security.Cryptography;

namespace Shifr_lab6;

public class DSA
{
     static Random random = new Random();



    public  static (BigInteger p, BigInteger q, BigInteger g) GenerateParameters()
    {
        BigInteger q =PrimeGen.GenerateRandomPrime(160);
        BigInteger p;
        do
        {
            p = PrimeGen.GenerateRandomPrime(1024);
        } while ((p - 1) % q != 0);
        
        BigInteger h;
        do
        {
            h = PrimeGen.GeneratePrimesInRange(p - 1) + 1;
        } while (BigInteger.ModPow(h, (p - 1) / q, p) <= 1);
        
        BigInteger g = BigInteger.ModPow(h, (p - 1) / q, p);
        return (p, q, g);
    }

    public static (BigInteger x, BigInteger y) GenerateKeys(BigInteger p, BigInteger q, BigInteger g)
    {
        BigInteger x = PrimeGen.GeneratePrimesInRange(q - 1) + 1;
        BigInteger y = BigInteger.ModPow(g, x, p);
        return (x, y);
    }

    public static (BigInteger r, BigInteger s) Sign(BigInteger p, BigInteger q, BigInteger g, BigInteger x, string message)
    {
        BigInteger k;
        BigInteger r, s;
        BigInteger hash = HashMessage(message, q);
        do
        {
            k = PrimeGen.GeneratePrimesInRange(q - 1) + 1;
            r = BigInteger.ModPow(g, k, p) % q;
            s = (ModInverse(k,q) * (hash + x * r)) % q;
        } while (r == 0 || s == 0);
        return (r, s);
    }
    
    public static bool Verify(BigInteger p, BigInteger q, BigInteger g, BigInteger y, string message, BigInteger r, BigInteger s)
    {
        if (r <= 0 || r >= q || s <= 0 || s >= q) return false;
        BigInteger w = ModInverse(s, q);
        BigInteger hash = HashMessage(message, q);
        BigInteger u1 = (hash * w) % q;
        BigInteger u2 = (r * w) % q;
        BigInteger v = ((BigInteger.ModPow(g, u1, p) * BigInteger.ModPow(y, u2, p)) % p) % q;
        return v == r;
    }

    public static BigInteger HashMessage(string message, BigInteger q)
    {
        using (SHA1 sha1 = SHA1.Create())
        {
            byte[] hash = sha1.ComputeHash(System.Text.Encoding.UTF8.GetBytes(message));
            return new BigInteger(hash) % q;
        }
    }
    
    
    // расширенный алгоритм Евклида
    static BigInteger ModInverse(BigInteger a, BigInteger m)
    {
        BigInteger m0 = m, y = 0, x = 1;
        while (a > 1)
        {
            BigInteger q = a / m;
            BigInteger t = m;
            m = a % m;
            a = t;
            t = y;
            y = x - q * y;
            x = t;
        }
        return x < 0 ? x + m0 : x;
    }

}