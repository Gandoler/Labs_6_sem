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
        
        private int GeneratePrime(int min, int max)
        {
            Random rnd = new Random();
            while (true)
            {
                int num = rnd.Next(min, max);
                if (IsPrime(num)) return num;
            }
        }

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

      
        private int GetE()
        {
          
            for (int i = 3; i < phie; i += 2)
            {
                if (GCD(i, phie) == 1)
                    return i;
            }
            return -1;
        }

        private int GetD()
        {
            int d = 0, x1 = 0, x2 = 1, y1 = 1, tempPhie = phie, tempE = e;
            while (tempE > 0)
            {
                int temp = tempPhie / tempE;
                int remainder = tempPhie % tempE;
                tempPhie = tempE;
                tempE = remainder;
                int x = x2 - temp * x1;
                x2 = x1;
                x1 = x;
                int y = d - temp * y1;
                d = y1;
                y1 = y;
            }
            if (tempPhie == 1)
                return d + (d < 0 ? phie : 0); // Убедимся, что d > 0
            throw new Exception("Ошибка при вычислении d.");
        }

        private static int ModularExponentiation(int baseNum, int exp, int mod)
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
        
        private char UnshifrChar(string s, int d)
        {
            int num = Convert.ToInt32(s);
            return (char)ModularExponentiation(num, d, this.n);
        }


        public (int, int) GetPublicKeyFromRecipient()
        {
            p = GeneratePrime(50, 200); 
            q = GeneratePrime(50, 200);
            n = p * q;
            phie = (p - 1) * (q - 1);
            e = GetE();
            if (e < 0)
                throw new Exception("Не удалось подобрать число e.");
            return (e, n);
        }

  
        public void ReadShifredMail(string mail_shfr)
        {
            int d = GetD();
            if (d < 1)
                throw new Exception("Ошибка: не удалось вычислить d.");

            StringBuilder unshifredMail = new StringBuilder();
            
            foreach (var token in mail_shfr.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries))
            {
                unshifredMail.Append(UnshifrChar(token, d));
            }

            Console.WriteLine("Расшифрованное сообщение: " + unshifredMail.ToString());
        }
    }
}
