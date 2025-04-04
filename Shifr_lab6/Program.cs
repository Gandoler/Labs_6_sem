using System;
using System.Numerics;
using System.Security.Cryptography;
using Shifr_lab6;


class Program
{
    static void Main()
    {
        ElGamalSignature.GenerateKeys();
        BigInteger message = new BigInteger(123456);
        var signature = ElGamalSignature.Sign(message);
        Console.WriteLine($"Message: {message}");
        Console.WriteLine($"Signature: r = {signature.Item1}, s = {signature.Item2}");
        Console.WriteLine($"Verification: {ElGamalSignature.Verify(message, signature.Item1, signature.Item2)}");

        Console.WriteLine("\n\n");
        /// а тут в середине исправим
        
        BigInteger message2 = new BigInteger(123456);
        var signature2 = ElGamalSignature.Sign(message2);
        message2 = new BigInteger(1234523456); //тут в серединке изменяем 
        Console.WriteLine($"Message: {message2}");
        Console.WriteLine($"Signature: r = {signature.Item1}, s = {signature.Item2}");
        Console.WriteLine($"Verification: {ElGamalSignature.Verify(message2, signature.Item1, signature.Item2)}");
        
    }
}