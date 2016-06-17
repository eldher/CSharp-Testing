using System;

namespace CarClass
{
    class Car
    {
        private static int CarCounter = 0;
        private string plates = null;

        public Car(string plate)
        {
            this.plates = plate;
            CarCounter++;                        
        }
        public static int GetCarsCount()
        {
            return Car.CarCounter;
        }
        public string GetPlate()
        {
            return this.plates;
        }    

    }

    class UseCar
    {
        static void Main()
        {
            Console.WriteLine("Inserte la placa del vehiculo");
            Car[] lote = new Car[10];
            for (int i = 0; Car.GetCarsCount()<5; i++)
            {
                //string plate = Console.ReadLine();
                lote[i] = new Car(Console.ReadLine());
            }
        }            
    }
}
