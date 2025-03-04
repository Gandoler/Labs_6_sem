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

    public static string ShifrMessage(string msg)
    {
        (int e, int n) publicKey = Recipient.Instance.GetPublicKeyFromRecipient();
        return string.Join(", ", msg.Select(c => ShifrChar(c, publicKey.e, publicKey.n)));
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
}