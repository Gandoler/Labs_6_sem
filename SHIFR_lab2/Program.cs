using SHIFR_lab2;

public static class Program
{

    public static void Main()
    {
        string msg = "Privet";

        string shfrMsg = Sender.SHifrMessage(msg);
        Console.WriteLine(shfrMsg);
        Recipient.Instance.ReadShifredMail(shfrMsg);
    }
    
    
}