
using SHIFR_lab3;

public static class Program
{



    public static void Main()
    {
        
        string inputImage = "/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab3/8.bmp";
        string outputImage = "/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab3/8out.bmp";
        string message = "Hellsefo, world!";

        LSBSteganography.Instance.HideMessage(inputImage, message, outputImage);
        LSBSteganography.Instance.ExtractMessage(outputImage);
    }
    
}