using System.Text;

namespace SHIFR_lab2;

public class Recipient
{
    
    private static Recipient instance = new Recipient();
    private int p;
    private int q;
    private int e;
    private int phie;
    private int n;

    public static Recipient Instance => instance;
    private Recipient(){}
    
    private void GetSimpledivisors(int num, List<int> result)
    {
        
        for (int i = 2; i*i <= num; i++)
        {
            while (num % i == 0)
            {
                result.Add(i);
                num /= i;
            }
        }
        if (num > 1) result.Add(num);
     
    }
    
    private int GetE()
    {
        List<int> list = new List<int>();
        GetSimpledivisors(p, list);
        bool isGoodNum = true;
        for (int i = 2; i <= phie; i++)
        {
            foreach (var simplediv in list)
            {
                isGoodNum = true;
                if (i % simplediv == 0)
                {
                    isGoodNum = false;
                    break;
                }

                if (isGoodNum) return i;
            }
        }

        return -1;
    }

    
    private int GetD()
    {
        int infinityLoopStoop = 10000;
        int d = 1;
        while ((d * e) % phie != 1)
        {
            d++;
            if(d > infinityLoopStoop)return -1;
        }
        if(((d * e) % phie != 1)) return d;
        return -1;
    }

    private char unshifrChar(string i, int d)
    {
        return (char)(Math.Pow((Convert.ToInt32(i)), d) % n);
    }
    
    public (int, int) GetPublicKeyFromRecipient()
    {
        p = new Random().Next(10,1000);
        q = new Random().Next(10,1000);
        
        n = p * q;
        phie = (p - 1) * (q - 1);
        e = GetE();
        if (e < 0) throw new Exception("Не удалось подобрать число\n");
        return (e, n);
    }

    public void ReadShifredMail(string mail_shfr)
    {
        int d = GetD();
        if (d < 1) throw new Exception("Опа d не получилось");

        StringBuilder UnshifredMail = new StringBuilder();
        foreach (var VARIABLE in mail_shfr.Split(", "))
        {
            UnshifredMail.Append(unshifrChar(VARIABLE, d));
        }

        Console.WriteLine(UnshifredMail.ToString());

    }
}