using SHIFR_lab3;

public static class Program
{



    public static void Main()
    {
        
        string inputImage = "input.bmp";
        string outputImage = "output.bmp";
        string message = "Hello, world!";

        LSBSteganography.Instance.HideMessage(inputImage, message, outputImage);
        LSBSteganography.Instance.ExtractMessage(outputImage);
    }
    
}