using System.Text;
using Shifr_lab4;

public static class Program
{



   public static void Main()
    {
        string key = "qwertywsfe";
        byte[] keyBytes = Encoding.ASCII.GetBytes(key);

        Blowfish blow = new Blowfish(BlowfishConstants.P, BlowfishConstants.SBox, keyBytes);

        string msg = "privenijinjnjt";

        ulong[] msgBlocks = StringToBlocks(msg);

        ulong[] encrypted = blow.ShifrMessage(msgBlocks);

        string CryptoMsgBase64 = Convert.ToBase64String(BlocksToByteArray(encrypted));
        Console.WriteLine("Encrypted message (Base64): " + CryptoMsgBase64);

        ulong[] decrypted = blow.DecryptMessage(encrypted);

        string decryptedMsg = BlocksToString(decrypted);
        Console.WriteLine("Decrypted message: " + decryptedMsg);
    }

    private static ulong[] StringToBlocks(string input)
    {
        int numBlocks = (input.Length + 7) / 8; 
        ulong[] blocks = new ulong[numBlocks];

        for (int i = 0; i < numBlocks; i++)
        {
            ulong block = 0;
            for (int j = 0; j < 8; j++)
            {
                if (i * 8 + j < input.Length)
                {
                    block |= (ulong)input[i * 8 + j] << (56 - j * 8);
                }
            }
            blocks[i] = block;
        }

        return blocks;
    }

  
    private static string BlocksToString(ulong[] blocks)
    {
        StringBuilder sb = new StringBuilder();
        foreach (var block in blocks)
        {
            for (int i = 0; i < 8; i++)
            {
                char ch = (char)((block >> (56 - i * 8)) & 0xFF);
                if (ch != '\0') // Убираем нулевые байты
                {
                    sb.Append(ch);
                }
            }
        }
        return sb.ToString();
    }

  
    private static byte[] BlocksToByteArray(ulong[] blocks)
    {
        byte[] byteArray = new byte[blocks.Length * 8];
        for (int i = 0; i < blocks.Length; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                byteArray[i * 8 + j] = (byte)((blocks[i] >> (56 - j * 8)) & 0xFF);
            }
        }
        return byteArray;
    }

    
    
    
}