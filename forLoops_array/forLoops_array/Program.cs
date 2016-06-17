using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace forLoops_array
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("How many elements the array has?");
            int HowMany = int.Parse(Console.ReadLine());
            int[] xCoords = new int[HowMany];
            int[] yCoords = new int[HowMany];
            int slope = 2;

            for (int index = 0; index < xCoords.Length; index++)
            {
                xCoords[index] = index;//Console.SetCursorPosition
                yCoords[index] = index * slope;

            }
            for (int index = 0; index < xCoords.Length; index++)
            {
                Console.CursorTop = slope * HowMany;
                Console.SetCursorPosition(xCoords[index], Console.CursorTop - yCoords[index]);
                Console.WriteLine("x");
            }

            // Now we create a random matrix
            double[,] matrix = new double[5, 5];

            for (int i = 0; i < 4; i++)
            {
                for (int j = 0; j < 4; j++)
                {
                    matrix[i,j] = new Random(DateTime.Now.Millisecond).NextDouble();
                    Console.WriteLine(matrix[i,j].ToString());
                }
            }
            Console.ReadLine();
        }
    }
}
