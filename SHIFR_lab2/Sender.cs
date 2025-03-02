using System.Text;

namespace SHIFR_lab2;

public static class Sender
{
    public static int ShifrChar(char c, int e, int n)
    {
        return (int)Math.Pow(Convert.ToInt32(c), e) % n;
    }
    
    public static string SHifrMessage(string msg)
    {
        (int, int) publicKey = Recipient.Instance.GetPublicKeyFromRecipient();
        
        StringBuilder shifrdString = new StringBuilder();
        foreach (var VARIABLE in msg)
        {
            shifrdString.Append(ShifrChar(VARIABLE, publicKey.Item1, publicKey.Item2) + ", ");
        }
        return shifrdString.ToString();
    }
}