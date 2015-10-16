namespace Imax.Console
{
    internal class ConsoleCredentialsProvider
    {
        private string password;

        public string Login => "sviridovdy@gmail.com";

        public string Password => password ?? (password = System.Console.ReadLine());
    }
}