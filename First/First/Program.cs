using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace First
{
    class Program
    {
        static void Main(string[] args)
        {
            //string name;
            int edad1, edad2;
            string fecha_nac;
            string FirstName = "Eldher";
            string LastName = "Hernandez";
            Console.WriteLine("Hola Mundo, me llamo " + FirstName + " " + LastName );
            Console.WriteLine("Hola Mundo, me llamo " + LastName + " " + FirstName);
            Console.WriteLine("\n\r");
            Console.WriteLine("Escribe tu nombre para reemplazar el mio");
            FirstName = Console.ReadLine();
            Console.WriteLine("Escribe tu apellido para reemplazar el mio");
            LastName = Console.ReadLine();
            Console.WriteLine("Nombre cambiado, ahora me llamo " + FirstName + " " +LastName );
            
            Console.WriteLine("Escribe tu año de nacimiento y te digo tu edad");
            edad1 = int.Parse(Console.ReadLine());
            edad2 = 2016 - edad1;
            Console.WriteLine("Tu edad es " + edad2.ToString());
            Console.ReadLine();

            Console.WriteLine("Introduce tu fecha de nacimiento separada por -");
            fecha_nac = Console.ReadLine();
            string[] fechas = fecha_nac.Split('-');
            if (int.Parse(fechas[1]) < 6)
                Console.WriteLine("Tienes " + edad2.ToString() + " años");
            else
                if (int.Parse(fechas[0]) < 16)
                Console.WriteLine("Tienes " + edad2.ToString() + " años");
            else
                edad2 = 2016 - int.Parse(fechas[2]) - 1;
                Console.WriteLine("Tienes " + edad2 + " años");

            Console.ReadLine();
            int i = 10 % 3;
            int y = 10 % 5;
            string word = string.Empty;
            // FizzBuzz
            for(i = 1; i <=100; i++)
            {
                if (i % 3 == 0)
                    word = "Fizz";
                if (i % 5 == 0)
                    word = "Buzz";
                if (i % 15 == 0)
                    word = "FizzBuzz";
                if ((i % 3 != 0) && (i % 5 != 0))
                    word = i.ToString();

                Console.WriteLine(word);
            }
            Console.ReadLine();


        }
    }
}
