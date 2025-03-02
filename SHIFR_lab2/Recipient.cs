using System;
using System.Collections.Generic;
using System.Text;

namespace SHIFR_lab2
{
    public class Recipient
    {
        private static Recipient instance = new Recipient();
        private int p;
        private int q;
        private int e;
        private int phie;
        private int n;

        public static Recipient Instance => instance;
        private Recipient() { }

        // Генерация простого числа в заданном диапазоне
        private int GeneratePrime(int min, int max)
        {
            Random rnd = new Random();
            while (true)
            {
                int num = rnd.Next(min, max);
                if (IsPrime(num)) return num;
            }
        }


        // Проверка, является ли число простым
        private bool IsPrime(int num)
        {
            if (num < 2) return false;
            for (int i = 2; i * i <= num; i++)
            {
                if (num % i == 0)
                    return false;
            }
            return true;
        }

        // Метод для получения простых делителей числа
        private void GetSimpleDivisors(int num, List<int> result)
        {
            for (int i = 2; i * i <= num; i++)
            {
                while (num % i == 0)
                {
                    result.Add(i);
                    num /= i;
                }
            }
            if (num > 1) result.Add(num);
        }

        // Нахождение НОД (алгоритм Евклида)
        private int GCD(int a, int b)
        {
            while (b != 0)
            {
                int temp = b;
                b = a % b;
                a = temp;
            }
            return a;
        }

        // Выбор e — должно быть взаимно простым с φ(n)
        private int GetE()
        {
            // Перебираем кандидатов начиная с 3 (обычно e не равен 2)
            for (int i = 3; i < phie; i += 2)
            {
                if (GCD(i, phie) == 1)
                    return i;
            }
            return -1;
        }

        // Нахождение d — обратного элемента e по модулю φ(n) с помощью расширенного алгоритма Евклида
        private int GetD()
        {
            int d, y;
            ExtendedEuclidean(e, phie, out d, out y);
            if (d < 0) d += phie; // Делаем d положительным
            return d;
        }

        // Расширенный алгоритм Евклида
        private void ExtendedEuclidean(int a, int b, out int x, out int y)
        {
            if (b == 0)
            {
                x = 1;
                y = 0;
                return;
            }

            int x1, y1;
            ExtendedEuclidean(b, a % b, out x1, out y1);
            x = y1;
            y = x1 - (a / b) * y1;
        }

        // Быстрое возведение в степень по модулю
        private int ModularExponentiation(int baseNum, int exp, int mod)
        {
            int result = 1;
            baseNum = baseNum % mod;

            while (exp > 0)
            {
                if ((exp & 1) == 1)
                    result = (result * baseNum) % mod;
                exp = exp >> 1;
                baseNum = (baseNum * baseNum) % mod;
            }
            return result;
        }

        // Метод дешифрования одного символа (принимает строковое представление числа)
        private char UnshifrChar(string s, int d)
        {
            int num = Convert.ToInt32(s);
            int decrypted = ModularExponentiation(num, d, n);
            return (char)decrypted;
        }

        // Генерация публичного ключа (e, n) получателя
        public (int, int) GetPublicKeyFromRecipient()
        {
            p = GeneratePrime(50, 200); // Генерируем p и q в диапазоне 50–200
            q = GeneratePrime(50, 200);
            n = p * q;
            phie = (p - 1) * (q - 1);
            e = GetE();
            if (e < 0)
                throw new Exception("Не удалось подобрать число e.");
            return (e, n);
        }

        // Метод расшифровки зашифрованного сообщения
        public void ReadShifredMail(string mail_shfr)
        {
            int d = GetD();
            if (d < 1)
                throw new Exception("Ошибка: не удалось вычислить d.");

            StringBuilder unshifredMail = new StringBuilder();
            // Используем RemoveEmptyEntries, чтобы убрать пустые элементы
            foreach (var token in mail_shfr.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries))
            {
                unshifredMail.Append(UnshifrChar(token, d));
            }

            Console.WriteLine("Расшифрованное сообщение: " + unshifredMail.ToString());
        }
    }
}
