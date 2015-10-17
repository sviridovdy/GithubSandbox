using System;
using Imax.Shared;

namespace Imax.Console
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var city = SelectCity();
            var storage = new NativeStorageProvider();
            var authToken = storage.AuthToken;
            if (string.IsNullOrEmpty(authToken))
            {
                var credentialsProvider = new ConsoleCredentialsProvider();
                var registerRequest = new RegisterRequest(credentialsProvider.Login, credentialsProvider.Password);
                var response = ImaxApi.Register(registerRequest).Result;
                if (response.Succeeded)
                {
                    authToken = storage.AuthToken = response.Token;
                }
                else
                {
                    return;
                }
            }

            var profileRequest = new ProfileRequest(city.Id, authToken);
            var profileResponse = ImaxApi.Profile(profileRequest).Result;
        }

        private static City SelectCity()
        {
            System.Console.Clear();
            var cities = ImaxApi.GetCities().Result.Cities;
            for (int i = 0; i < cities.Length; i++)
            {
                System.Console.WriteLine($"{i}. {cities[i].Name}");
            }
            System.Console.WriteLine("Enter city number...");
            while (true)
            {
                int number;
                if (int.TryParse(System.Console.ReadLine(), out number))
                {
                    if (number >= 0 && number < cities.Length)
                    {
                        return cities[number];
                    }
                }
            }
        }
    }
}