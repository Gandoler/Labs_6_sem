using System.Drawing;
using System.Text;

namespace SHIFR_lab3;

public class LSBSteganography
{
    
    private static LSBSteganography _instance = new();
    public static LSBSteganography Instance => _instance;

    private LSBSteganography()
    {
        
    }
    public void HideMessage(string imagePath, string message, string outputPath)
    {
        
        
        Bitmap picture = new Bitmap(imagePath);
        message += (char)0xFF; // Добавляем маркер конца сообщения
        byte[] messageBytes = Encoding.ASCII.GetBytes(message);

        int byteIndex = 0;
        for (int y = 0; y < picture.Height && byteIndex < messageBytes.Length; y++)
        {
            for (int x = 0; x < picture.Width && byteIndex < messageBytes.Length; x++)
            {
                Color pixel = picture.GetPixel(x, y);
                byte hideByte = messageBytes[byteIndex++];

                // Вставляем 2 младших бита в каждый цветовой канал (R, G, B, A)
                byte newR = (byte)((pixel.R & 0xFC) | ((hideByte >> 6) & 0x3));
                byte newG = (byte)((pixel.G & 0xFC) | ((hideByte >> 4) & 0x3));
                byte newB = (byte)((pixel.B & 0xFC) | ((hideByte >> 2) & 0x3));
                byte newA = (byte)((pixel.A & 0xFC) | (hideByte & 0x3));

                picture.SetPixel(x, y, Color.FromArgb(newA, newR, newG, newB));
            }
        }

        picture.Save(outputPath);
        picture.Dispose();
        Console.WriteLine("Сообщение спрятано!");
    }
    
    
    public  void ExtractMessage(string imagePath)
    {
        Bitmap bmp = new Bitmap(imagePath);
        MemoryStream messageStream = new MemoryStream();

        for (int y = 0; y < bmp.Height; y++)
        {
            for (int x = 0; x < bmp.Width; x++)
            {
                Color pixel = bmp.GetPixel(x, y);

                // Достаём 2 младших бита из каждого цветового канала
                byte hideByte = (byte)(
                    ((pixel.R & 0x3) << 6) |
                    ((pixel.G & 0x3) << 4) |
                    ((pixel.B & 0x3) << 2) |
                    (pixel.A & 0x3)
                );

                if (hideByte == 0xFF) // Конец сообщения
                {
                    string message = Encoding.ASCII.GetString(messageStream.ToArray());
                    Console.WriteLine("Извлечённое сообщение: " + message);
                    return;
                }

                messageStream.WriteByte(hideByte);
            }
        }

        Console.WriteLine("Сообщение не найдено!");
    }

}