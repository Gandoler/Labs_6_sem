using ConsoleApp2;

class Program
{



    public static void Main(string[] args)
    {
        string Filename = "/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/Veni.doc";
        lab1.Num1(Filename);
        
        lab1.Num2(Filename);
        
        lab1.GenerateKey();
        
        lab1.Num3Shifr();
        lab1.Num3DeShifr();
    }
}