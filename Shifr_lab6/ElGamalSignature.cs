using System.Numerics;
using System.Security.Cryptography;

namespace Shifr_lab6
{
    public class ElGamalSignature
    {
        // Статическая переменная для генерации случайных чисел
        private static Random random = new Random();

        // Параметры Эль-Гамаля: p - простое число, g - генератор, x - секретный ключ, y - открытый ключ
        private static BigInteger p, g, x, y;

        // Метод для генерации ключей
        public static void GenerateKeys(int bitLength = 512)
        {
            // Генерация простого числа p и генератора g для подписи
            p = PrimeGen.GeneratePrime(bitLength);
            g = PrimeGen.GenerateGenerator(p);

            // Генерация секретного ключа x, который должен быть в пределах [2, p-2]
            x = PrimeGen.RandomBigInteger(2, p - 2);

            // Открытый ключ y = g^x mod p
            y = BigInteger.ModPow(g, x, p);
        }

        // Метод для подписания сообщения
        public static (BigInteger, BigInteger) Sign(BigInteger message)
        {
            BigInteger k;
            // Генерация случайного числа k, которое взаимно простое с p-1
            do
            {
                k = PrimeGen.RandomBigInteger(2, p - 2);
            } while (BigInteger.GreatestCommonDivisor(k, p - 1) != 1); // k должно быть взаимно простым с p-1

            // Вычисление r = g^k mod p
            BigInteger r = BigInteger.ModPow(g, k, p);

            // Вычисление s = (message - x * r) * k^(-1) mod (p - 1)
            BigInteger s = ((message - x * r) * PrimeGen.ModInverse(k, p - 1)) % (p - 1);
            
            // Если s отрицательно, добавляем p - 1, чтобы привести в положительный диапазон
            if (s < 0) s += p - 1;

            // Возвращаем пару значений (r, s) как подпись
            return (r, s);
        }

        // Метод для проверки подписи
        public static bool Verify(BigInteger message, BigInteger r, BigInteger s)
        {
            // Проверка валидности значений r и s
            if (r <= 0 || r >= p || s <= 0 || s >= p - 1) return false;

            // Вычисление v1 = y^r * r^s mod p
            BigInteger v1 = BigInteger.ModPow(y, r, p) * BigInteger.ModPow(r, s, p) % p;

            // Вычисление v2 = g^message mod p
            BigInteger v2 = BigInteger.ModPow(g, message, p);

            // Проверка, равны ли вычисленные значения
            return v1 == v2;
        }
    }
}
