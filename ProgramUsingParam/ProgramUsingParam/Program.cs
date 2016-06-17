using System;

class Program
{
    static int SumArray(params object[] x)
    {
        int sum = 0;
        foreach (int[] array in x)
        {
            foreach (int i in array)
            {
                sum += i;
            }
        }
        return sum;           
    }

    static void Main()
    {
        int[] array1 = { 1, 2, 3, 4, 5, 6,10 };
        int[] array2 = { 2, 3, 4, 5, 6, 7, 8, 9, 10 };
        int[] array3 = { 1, 2,10 };

        Console.WriteLine("La suma es: {0}",SumArray(array1,array2,array3));
        Console.ReadLine();
    }

}
