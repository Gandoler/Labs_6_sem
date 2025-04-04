using System;
using System.Numerics;
using Shifr_lab6;

class Program
{
    static void Main()
    {
        var (p, q, g) = DSA.GenerateParameters();
        var (x, y) = DSA.GenerateKeys(p, q, g);
        string message = "Hello, DSA!";
        var (r, s) = DSA.Sign(p, q, g, x, message);
        
        
        
        //сверка 
        bool isValid = DSA.Verify(p, q, g, y, message, r, s);
        Console.WriteLine($"Подпись верна: {isValid}");
    }
}
