using System;

namespace SHIFR_lab2;

class Program
{
    static void Main()
    {
        Console.WriteLine("Введите сообщение для шифрования:");
        string message = Console.ReadLine();

        // Отправитель шифрует сообщение
        string encryptedMessage = Sender.ShifrMessage(message);
        Console.WriteLine("Зашифрованное сообщение: " + encryptedMessage);

        // Получатель расшифровывает сообщение
        Recipient.Instance.ReadShifredMail(encryptedMessage);
    }
}