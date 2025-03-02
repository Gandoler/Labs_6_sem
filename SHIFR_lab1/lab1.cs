namespace ConsoleApp2;

public static class lab1
{
    
    public static void Num1(string filepath)
    {Console.WriteLine("num1\n");
        Console.WriteLine( File.ReadAllBytes(filepath).Length);
        Console.WriteLine("\n\n");
    }


    public static void Num2(string filepath)
    {
        Console.WriteLine("\nnum2\n");
        byte[] bytefile = File.ReadAllBytes(filepath);
        int[] byterasp = new int[256];
        foreach (byte b in bytefile)
        {
            int bytenum = b;
            byterasp[bytenum]++;
        }

        for (int i = 0; i < byterasp.Length; i++)
        {
            if (i % 20 == 0)
            {
                Console.WriteLine("");
            }
            Console.Write(byterasp[i]+"-" +i+"\t");
        }
        Console.WriteLine("\n\n");
    }

    public static void GenerateKey()
    {
        Random random = new Random();
        byte[] key = new byte[256];

        for (int i = 0; i <key.Length; i++)
        {
            key[i] = (byte)random.Next(256);
        }
        File.WriteAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/key.txt", key);
        Console.WriteLine("\nKEY\n");
        for (int i = 0; i < key.Length; i++)
        {
            if (i % 60 == 0)
            {
                Console.WriteLine("");
            }
            Console.Write(key[i]+"-" +i+"\t");
        }
        Console.WriteLine("\n\n");
        
    }

    public static void Num3Shifr()
    {
        Console.WriteLine("\nnum3\n");
        byte[] bytefile = File.ReadAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/NewFile1.txt");
        byte[] byteshifr = File.ReadAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/key.txt");

        byte[] exitshifrdile = new byte[bytefile.Length];
        Console.WriteLine("\n FILE\n");
        for (int i = 0; i < bytefile.Length; i++)
        {
            if (i % 20 == 0)
            {
                Console.WriteLine("");
            }
            Console.Write(bytefile[i]+"-" +i+"\t");
        }
        Console.WriteLine("\n\n");
        for (int i = 0; i < bytefile.Length; i++)
        {
            exitshifrdile[i] = byteshifr[bytefile[i] % 256];  
        }

        File.WriteAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/exitshifr.txt", exitshifrdile);
        Console.WriteLine("\nshifr\n");
        for (int i = 0; i < exitshifrdile.Length; i++)
        {
            if (i % 20 == 0)
            {
                Console.WriteLine("");
            }
            Console.Write(exitshifrdile[i]+"-" +i+"\t");
        }
        Console.WriteLine("\n\n");
    }

    public static void Num3DeShifr()
    {
        Console.WriteLine("\nnum3\n");
        byte[] byteShifredFile = File.ReadAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/exitshifr.txt");
        byte[] key = File.ReadAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/key.txt");

        byte[] exitDEshifrdile = new byte[byteShifredFile.Length];

        for (int i = 0; i < byteShifredFile.Length; i++)
        {

            int index = Array.IndexOf(key, byteShifredFile[i]);

          
            exitDEshifrdile[i] = (byte)index;
        }

        File.WriteAllBytes("/Users/gl.krutoimail.ru/RiderProjects/Labs_6_sem/SHIFR_lab1/TEXT_files/exitDEshifr.txt", exitDEshifrdile);
        Console.WriteLine("\nDEshifr\n");
        for (int i = 0; i < exitDEshifrdile.Length; i++)
        {
            if (i % 20 == 0)
            {
                Console.WriteLine("");
            }
            Console.Write(exitDEshifrdile[i]+"-" +i+"\t");
        }
        Console.WriteLine("\n\n");
    }


}