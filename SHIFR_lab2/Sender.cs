using System;
using System.Text;

namespace SHIFR_lab2;

public static class Sender
{
    // Функция для шифрования символа
    public static int ShifrChar(char c, int e, int n)
    {
        return ModularExponentiation(Convert.ToInt32(c), e, n);
    }

    // Функция для шифрования строки
    public static string ShifrMessage(string msg)
    {
        (int e, int n) publicKey = Recipient.Instance.GetPublicKeyFromRecipient();

        StringBuilder shifrdString = new StringBuilder();
        foreach (var VARIABLE in msg)
        {
            shifrdString.Append(ShifrChar(VARIABLE, publicKey.e, publicKey.n) + ", ");
        }
        return shifrdString.ToString();
    }

    // Быстрое возведение в степень по модулю (ускоряет шифрование)
    private static int ModularExponentiation(int baseNum, int exp, int mod)
    {
        int result = 1;
        baseNum = baseNum % mod;

        while (exp > 0)
        {
            if ((exp & 1) == 1) // Если exp нечетное
                result = (result * baseNum) % mod;

            exp = exp >> 1; // exp /= 2
            baseNum = (baseNum * baseNum) % mod;
        }

        return result;
    }
}