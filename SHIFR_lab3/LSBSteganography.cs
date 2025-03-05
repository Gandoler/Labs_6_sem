using System.Drawing;
using System.Text;

namespace SHIFR_lab3;

public class LSBSteganography
{
    const int HEADER_SIZE = 54; // Размер заголовка BMP

    private static LSBSteganography _instance = new();
    public static LSBSteganography Instance => _instance;

    private LSBSteganography()
    {
        
    }
    public void HideMessage(string imagePath, string message, string outputPath)
    {


        byte[] bmpbytes = File.ReadAllBytes(imagePath);
        byte[] msgBytes = Encoding.ASCII.GetBytes(message);
        byte[] Hidemsg = new byte[msgBytes.Length + 1];
    

        Array.Copy(msgBytes, Hidemsg, msgBytes.Length); 
        Hidemsg[Hidemsg.Length - 1] = 0xFF;

       
        if (HEADER_SIZE + Hidemsg.Length * 4 > bmpbytes.Length)
        {
            Console.WriteLine("Ошибка: изображение слишком мало для скрытия сообщения.");
            return;
        }

        for (int i = 0; i < Hidemsg.Length; i++)
        {
            int pixelOffset = HEADER_SIZE + i * 4;

            bmpbytes[pixelOffset] &= 0xFC;
            bmpbytes[pixelOffset] |= (byte)((Hidemsg[i] >> 6) & 0x03);

            bmpbytes[pixelOffset + 1] &= 0xFC;
            bmpbytes[pixelOffset + 1] |= (byte)((Hidemsg[i] >> 4) & 0x03);

            bmpbytes[pixelOffset + 2] &= 0xFC;
            bmpbytes[pixelOffset + 2] |= (byte)((Hidemsg[i] >> 2) & 0x03);

            bmpbytes[pixelOffset + 3] &= 0xFC;
            bmpbytes[pixelOffset + 3] |= (byte)(Hidemsg[i] & 0x03);
        }

        File.WriteAllBytes(outputPath, bmpbytes);
        Console.WriteLine("Сообщение скрыто.");
    }


    
    
    public void ExtractMessage(string imagePath)
    {
        byte[] bmpBytes = File.ReadAllBytes(imagePath);
        MemoryStream messageStream = new MemoryStream();

        for (int i = 0; HEADER_SIZE + i * 4 < bmpBytes.Length; i++)
        {
            int pixelOffset = HEADER_SIZE + i * 4;
            byte extractedByte = 0;

            extractedByte |= (byte)((bmpBytes[pixelOffset] & 0x03) << 6);
            extractedByte |= (byte)((bmpBytes[pixelOffset + 1] & 0x03) << 4);
            extractedByte |= (byte)((bmpBytes[pixelOffset + 2] & 0x03) << 2);
            extractedByte |= (byte)(bmpBytes[pixelOffset + 3] & 0x03);

            if (extractedByte == 0xFF)
                break;

            messageStream.WriteByte(extractedByte);
        }

        foreach (var VARIABLE in messageStream.ToArray())
        {
            Console.Write((char)VARIABLE);
        }
        
        Console.WriteLine("\nСообщение извлечено.");
    }

}

