using System;
using Imax.Shared;

namespace Imax.Console
{
    internal class Program
    {
        private static void Main()
        {
            var city = SelectCity();

            var storage = new NativeStorageProvider();
            var authToken = storage.AuthToken;
            if (string.IsNullOrEmpty(authToken))
            {
                var credentialsProvider = new ConsoleCredentialsProvider();
                var loginRequest = new LoginRequest(credentialsProvider.Login, credentialsProvider.Password);
                var response = ImaxApi.Login(loginRequest).Result;
                if (response.Succeeded)
                {
                    authToken = storage.AuthToken = response.Token;
                }
                else
                {
                    return;
                }
            }

            var profileRequest = new ProfileRequest(authToken);
            var profileResponse = ImaxApi.Profile(profileRequest).Result;

            var registerRequest = new RegisterRequest(new CustomerName("Vasya", null, "Pupkin"), Gender.Male, new DateTime(2012, 12, 21), PhoneNumber.Parse("+380123456789"), "example@nowhere.com", "qwerty");
            var registerResponse = ImaxApi.Register(registerRequest).Result;
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